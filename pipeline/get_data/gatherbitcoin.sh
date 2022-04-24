#!/bin/bash
# get bitcoin and other instruments
#
# setup environment by making sure the right python libraries are loaded
#

background=""

# get arguments                                                                                                                                                                                                                                                              
while getopts  b: flag
do
    case "${flag}" in
        b) background="-${OPTARG}";;
    esac
done
docker-compose exec mids pip install flask_apscheduler >& /dev/null

d=`pwd`

docker-compose exec $background mids   env FLASK_APP=/w205/project3/w205-project3-alam-jenez-tully/pipeline/get_data/finance_data.py   flask run --host 0.0.0.0
