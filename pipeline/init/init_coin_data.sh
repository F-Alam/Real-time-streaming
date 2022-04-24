#!/bin/bash
# initialize historical data for coins
#
d=`date +'%-Y-%-m-%-d'`

docker-compose exec mids curl -H "Content-Type:application/json" -X POST http://localhost:5000/coinquote -d '{"coins": "litecoin,bitcoin,ethereum"}'
docker-compose exec mids curl -H "Content-Type:application/json" -X POST http://localhost:5000/coinhistory -d '{"coinhistory": {"name": "litecoin","start":"2013-1-1", "end":"'$d'"}}'
docker-compose exec mids curl -H "Content-Type:application/json" -X POST http://localhost:5000/coinhistory -d '{"coinhistory": {"name": "bitcoin","start":"2013-1-1", "end":"'$d'"}}'
docker-compose exec mids curl -H "Content-Type:application/json" -X POST http://localhost:5000/coinhistory -d '{"coinhistory": {"name": "ethereum","start":"2013-1-1", "end":"'$d'"}}'


