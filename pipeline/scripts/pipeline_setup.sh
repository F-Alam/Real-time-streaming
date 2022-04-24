#!/bin/bash
# This file contains a script that brings up the pipeline, sets up the kafka topics
# and then seeds the pipeline with data for processing requests from users.

# bring the cluster up

PATH=$PATH:.:../transform_data:../get_data:../init:../../analysis/scripts

echo "Bringing up cluster"
echo "cluster_up.sh"
cluster_up.sh

if [[ ($? != 0) ]]
then
    echo "Issue with cluster_up.sh command"
    exit 1
fi

# setup the topics for kafka
echo "Setup kafka topics"
echo "setup_events.sh"
setup_events.sh 

if [[ ($? != 0) ]]
then
    echo "Issue with setting up kafka topics"
    exit 1
fi

echo "Setup Coin gathering (flask)"
# setup flask to run in the background with
echo "gatherbitcoin.sh -b d "
gatherbitcoin.sh -b d

echo "Checking if flask and coin pipeline is up"

# check to see if it is up and running
waiting=""

for i in {1..90}
do
     p=`docker-compose exec mids kafkacat -C -b kafka:29092 -t coin_quotes -C -q -e  | grep current_price`

     if [[ "$p" != "" ]]
     then
	break
     fi
	
     if [[ "$waiting" == "" ]]
     then
         echo -n "Waiting for flask finance pipeline to come up"
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



if [[ ($p == "") ]]
then
    echo "Issue with bringing up flask finance pipeline"
    exit 1
fi

echo "Coin finance pipeline is up"


echo "Setting up transform coin streaming spark"
echo "transformcoin.sh -b d"
transformcoin.sh -b d

echo "Waiting for streaming spark to be up"
waiting=""

for i in {1..90}
do
     p=`docker-compose exec cloudera hadoop fs -ls /tmp/coin_data | grep -F "/tmp/coin_data/_spark_metadat"`

     if [[ "$p" != "" ]]
     then
        break
     fi

     if [[ "$waiting" == "" ]]
     then
         echo -n "Waiting On Transform Streaming to place results"
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

if [[ ($p == "") ]]
then
    echo "Issue with bringing up coin transformation "
    exit 1
fi

echo "Coin Transform Streaming is Up!"

# initialize the coin data with historical information
echo "Initializing pipeline with historical data"
echo "init_coin_data.sh > /dev/null"

init_coin_data.sh > /dev/null

echo "Setup Hive Tables for Presto"
echo "hive_setup.sh"
hive_setup.sh

# set up interactive shell with presto
#echo "Running presto interactive shell"
#echo "docker-compose exec presto presto --server presto:8080 --catalog hive --schema default"


echo "Please Pick you interface to access Presto or Exit"
while true; do
    read -p "Do you wish to use (P)resto,(J)upyter notebook or (E)xit? [p/j/e]: " pje
    case $pje in
        [Pp]* ) echo -e '\nUsing Presto'; presto_up.sh; break;;
        [Jj]* ) echo -e '\nUsing Jupyter'; notebook_up.sh; break;;
	[Ee]* ) echo -e '\nMoving To Exit Script'; break;;
            * ) echo "Please answer (P)resto, J(upyter) or (E)xit.";;
    esac
done

# shut down the cluster
echo "Cluster $p is stll Up!"
while true; do
    read -p "Do you wish to bring the cluster down and restart? [y/n]: " yn
    case $yn in
	[Yy]* ) echo -e '\nBringing cluster down'; docker-compose down; break;;
        [Nn]* ) echo -e '\nLeaving cluster unchanged'; exit;;
            * ) echo "Please answer yes or no.";;
    esac
done
