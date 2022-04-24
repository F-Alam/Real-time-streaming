#!/bin/bash
# This file contains a script that connects to presto
#
echo "Connecting to Presto"

docker-compose exec presto presto --server presto:8080 --catalog hive --schema default



