#!/bin/bash
# This file brings up the cluster for project-2
# The steps are:
#  make sure cluster is down and get permission to bring it down if it is still up
# After that  we do the docker-compose up and then monitor the logs to and docker-compose ps to to see when the
# cluster is up
#
echo 'Fist making sure cluster is down'
p=`docker-compose ps | grep Up |  awk -F '_' '{print $2}'`
p="${p//$'\n'/ }"
if [[ ("$p" == *"cloudera"*) ]]  && [[ ("$p" == *"zookeeper"* ) ]] && [[ ( "$p" == *"kafka"* ) ]] && [[ ( "$p" == *"spark"* ) ]] && [[ ( "$p" == *"mids"* ) ]]
then
    echo "Cluster $p is stll Up!"
    while true; do
	read -p "Do you wish to bring the cluster down and restart? [y/n]: " yn
	case $yn in
            [Yy]* ) echo -e '\nBringing cluster down'; docker-compose down; break;;
            [Nn]* ) echo -e '\nLeaving cluster unchanged'; exit;;
            * ) echo "Please answer yes or no.";;
	esac
    done
fi

# Bring cluster up	
docker-compose up -d

# start checking for when the cluser is up
# sleep after each check - the total time to wait is about a minute (on average about 30 seconds)
#
waiting=""

for i in {1..90}
do   
     z=`docker-compose logs zookeeper | grep -i "INFO binding to port 0.0.0.0/0.0.0.0:32181 (org.apache.zookeeper.server.NIOServerCnxnFactory)"`
     k=`docker-compose logs kafka | grep -i "started (kafka.server.KafkaServer)"`
     s=`docker-compose logs spark | grep -F "Config process done. Ready for startup"`
     c=`docker-compose logs  cloudera | grep -F "Started Hive Server2 (hive-server2):[  OK  ]"`
     p=`docker-compose logs  presto | grep -F "======== SERVER STARTED ========"`
     
     if [[ "$z" != "" ]] && [[ "$k" != "" ]] && [[ "$s" != "" ]] && [[ "$c" != "" ]] && [[ "$p" != "" ]]
     then
	 p=`docker-compose ps | grep Up |  awk -F '_' '{print $2}'`
	 p="${p//$'\n'/ }"
	 if [[ ("$p" == *"cloudera"*) ]]  && [[ ("$p" == *"zookeeper"* ) ]] && [[ ( "$p" == *"kafka"* ) ]] && [[ ( "$p" == *"spark"* ) ]] && [[ ( "$p" == *"mids"* ) ]] && [[ ( "$p" == *"presto"* ) ]]
	 then
	     echo ""
	     echo "Cluster $p is Up!"
	     exit 0
	 fi
     fi
     if [[ "$waiting" == "" ]]
     then
	 
	 echo -n "Waiting for cluster to come up [may take up to 120 seconds]."
	 waiting="."
     else
	 n=$(($i%5))
	 if [[ $n == 0 ]]
	 then
	     echo -n $i
	 else
	     echo -n $waiting
	 fi
	 sleep 1
     fi
done

echo
echo 'Cluster failed to come up!'

exit 1



