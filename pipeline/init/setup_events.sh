#!/bin/bash
echo "Creating topics coin_events, coins_manage_events"
docker-compose exec kafka kafka-topics --create --topic 'coin_events' --partitions 1 --replication-factor 1 --if-not-exists --zookeeper zookeeper:32181
docker-compose exec kafka kafka-topics --create --topic 'coin_quotes' --partitions 1 --replication-factor 1 --if-not-exists --zookeeper zookeeper:32181
docker-compose exec kafka kafka-topics --create --topic 'coin_history' --partitions 1 --replication-factor 1 --if-not-exists --zookeeper zookeeper:32181
docker-compose exec kafka kafka-topics --create --topic 'coin_quotes_request' --partitions 1 --replication-factor 1 --if-not-exists --zookeeper zookeeper:32181
docker-compose exec kafka kafka-topics --create --topic 'coin_history_request' --partitions 1 --replication-factor 1 --if-not-exists --zookeeper zookeeper:32181
docker-compose exec kafka kafka-topics --create --topic 'coin_manage_events' --partitions 1 --replication-factor 1 --if-not-exists --zookeeper zookeeper:32181
