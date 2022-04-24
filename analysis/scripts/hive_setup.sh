#!/bin/bash

#create external table if not exists default.coin_quotes (
#    name string,
#    id string,
#    symbol string,
#    current_price string,
#    last_updated string
#  )
#  stored as parquet 
#  location '/tmp/coin_data'
#  tblproperties ("parquet.compress"="SNAPPY");

background=""

# get arguments                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         
while getopts  b: flag
do
    case "${flag}" in
        b) background="-${OPTARG}";;
    esac
done

docker-compose exec $background spark spark-submit /w205/project3/w205-project3-alam-jenez-tully/analysis/src/setup_hive_tables.py
