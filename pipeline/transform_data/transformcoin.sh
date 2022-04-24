#!/bin/bash
# transform coins and write to parquet and other instruments
#
#

background=""

# get arguments                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         
while getopts  b: flag
do
    case "${flag}" in
        b) background="-${OPTARG}";;
    esac
done

docker-compose exec $background spark spark-submit /w205/project3/w205-project3-alam-jenez-tully/pipeline/transform_data/transform_coin_stream.py
