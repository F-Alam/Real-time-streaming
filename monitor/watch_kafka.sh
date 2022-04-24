#!/bin/bash

docker-compose exec mids kafkacat -C -b kafka:29092 -t coin_quotes -o beginning
