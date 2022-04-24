# This file implements the back end of the financial data pipeline
# It accomplishes one important purpose, it connects with coingecko to get all the quotes about various digital
# currencies including the two most important: current quotes, and historical data
# requests can come in via http or by kafka
# all information gets pushed to events in kafka to be handled by the rest of the pipeline
# One important part of this code is that each request to coingecko is scheduled to prevent
# our DOS'ing them in some way and be shutdown

import json
import datetime
import logging
import copy
import dateutil

# set up for all things kafka
from kafka import KafkaProducer
from kafka import KafkaConsumer
from flask import Flask, request

from flask import Flask
# import scheduling package to allow us to schedule requests for information form coinggeck
from flask_apscheduler import APScheduler
# set up for hannding post requests
import requests

# Enable scheduling package
# set configuration values
class Config(object):
    SCHEDULER_API_ENABLED = True

# set up logging for the system for our app scheduler
logging.basicConfig()
log = logging.getLogger('apscheduler.executors.default')
log.setLevel(logging.ERROR)  # DEBUG

fmt = logging.Formatter('%(levelname)s:%(name)s:%(message)s')
h = logging.StreamHandler()
h.setFormatter(fmt)
log.addHandler(h)

# create app to schedule task
app = Flask(__name__)
app.config.from_object(Config())

# set up kafka conumers and producers
producer = KafkaProducer(bootstrap_servers='kafka:29092')
consumer = KafkaConsumer("coin_quotes","coin_history",
                         bootstrap_servers='kafka:29092',
                         value_deserializer=lambda m: json.loads(m.decode('utf-8')))

# log events to kafka
def log_to_kafka(topic, event):
    event.update(request.headers)
    producer.send(topic, json.dumps(event).encode())

# Send messages to kafka that is specific to finance application
def send_to_kafka(topic,event):
    producer.send(topic, json.dumps(event).encode())

# initialize scheduler for regular updates
scheduler = APScheduler()

# initialize with some coins that we want to pull in
coins_to_get = {"coins":"litecoin,bitcoin,ethereum"}


# get coin prices
def get_coin_prices(coin_info):
    # Get the price of specific coins
    coins=coin_info.get("coins",coin_info.get("coinquote",""))
#    print(coins)
    payload = {'vs_currency':'usd', 'ids' : coins}
    res = requests.get('https://api.coingecko.com/api/v3/coins/markets', params=payload)
    dictFromServer = res.json()
    coins_event = {'event_type': 'get_coin_prices'}
    send_to_kafka('coin_events', coins_event)
    price_list={}
    for i in range(len(dictFromServer)):
        price_list[dictFromServer[i]['name']] = dictFromServer[i]["current_price"]
#        print(dictFromServer[i]["last_updated"])
        coin_quotes = {# 'event_type': 'coin_quotes',
                       'name' : dictFromServer[i]['name'],
                       'id' : dictFromServer[i]['id'],
                       'symbol' : dictFromServer[i]["symbol"],
                       'current_price': dictFromServer[i]["current_price"],
                       'last_updated' : dateutil.parser.parse(dictFromServer[i]["last_updated"]).isoformat()
                       } # , 'detail': json.dumps(dictFromServer[i])}
        print(coin_quotes)
        send_to_kafka('coin_quotes', coin_quotes)
    return(price_list)
        
# get coin histories
def get_coin_history(coin_history):
    # get the history of coin prices from start to end date
    #
    start_date = datetime.datetime.strptime(coin_history["start"], '%Y-%m-%d')
    end_date = datetime.datetime.strptime(coin_history["end"], '%Y-%m-%d')

    price_history={}
    start_date = (start_date - datetime.datetime(1970,1,1)).total_seconds()
    end_date = (end_date - datetime.datetime(1970,1,1)).total_seconds()
    res = requests.get("https://api.coingecko.com/api/v3/coins/" + coin_history["name"] + "/market_chart/range?vs_currency=usd&from=" +
                       str(start_date) + "&to=" + str(end_date) + "&localization=false")
    dictFromServer = res.json()

   
    coin_prices = {#'event_type': 'coin_history', 
                    coin_history["name"] : dictFromServer}
#    print(coin_prices)
    send_to_kafka('coin_history', coin_prices)

    for k,v in dictFromServer.items():
        if k == 'prices': 
            for i in range(len(v)):
#                print("v1=",v[i][1],"v0=",type( v[i][0]))
                coin_quotes = {#'event_type': 'coin_quotes',
                               "name": "",
                               "id": coin_history["name"],
                               "symbol": "",
                               'current_price': v[i][1],
                               'last_updated':  datetime.datetime.fromtimestamp(float(v[i][0])/1000.0).isoformat()
                               }
                print(coin_quotes)
                send_to_kafka('coin_quotes', coin_quotes)
    return coin_prices

#
# get coins needed for value request from a kafka message
#
def get_coins_data(value):
    return(value)

# get coin history neede

def get_coins_history(value):
    return(value)

#
# process a kafka message
#
def process_messsage(m):
    if m.topic == "coin_quotes_request":
        coin_info = get_coins_data(m.value)
        get_coin_prices(coin_info)
        consumer.task_done(m)

    if m.topic == "coin_history_request":
        coin_history_info = get_coins_history(m.value)
        get_coin_history(coin_history_info)
        consumer.task_done(m)
        
# interval example
@scheduler.task('interval', id='do_job_1', seconds=10, misfire_grace_time=900, max_instances=1)
def job1():
    get_coin_prices(coins_to_get)
#    for m in consumer:
#        process_message(m)


# schedule picking up various jobs
scheduler.init_app(app)
scheduler.start()


@app.route("/")
def default_response():
    default_event = {'event_type': 'default'}
    log_to_kafka('events', default_event)
    return "This is the default response!\n"


@app.route("/coinquote", methods = ['POST'])
def coinquote():
    """
    get a quote of seleted coins. Set for getting the ongoing prices through scheduled requests
    """
    global coins_to_get
    p={}
    if request.headers['Content-Type'] == 'application/json':
        
        coins_event = {'event_type': 'coins_set_event', 'attributes': json.dumps(request.json)}
        log_to_kafka('coins_quote_events', coins_event)
        coins_to_get = copy.deepcopy(request.json) # set up for recurring request
        p= get_coin_prices(request.json)
    return str(p) + '\n'
        
@app.route("/coinhistory", methods = ['POST'])
def coinhistory():
    """
    Get the history for a specific
    """
    h={}
    if request.headers['Content-Type'] == 'application/json':
        coins_event = {'event_type': 'coins_history_event', 'attributes': json.dumps(request.json)}
        log_to_kafka('coins_history_events', coins_event)
        h = get_coin_history(request.json['coinhistory'])
    return str(h) + '\n'

if __name__ == '__main__':
    app.run()
