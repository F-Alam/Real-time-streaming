## W205 - Project 3 - "_Real-time streaming of digital currency data for investors_"
### __Team__: Greg Tully, Ferdous Alam, Ricardo Jenez
### __Date__: 4/11/2021

### Project Pipeline:

#### [Pipeline Diagram](w205_Project3_Pipeline_Diagram.pdf)
    
#### Pipeline Description:
The Pipeline for this projects consists of two areas (1) __Financial Data Pipeline__ and (2) __Portfolio Management__: 
1. __Financial Data Pipeline__:
* The first is a batch processing pipeline that gathers financial data from [CoinGecko](https://www.coingecko.com/en), a site that provides crypto currency market data. It pulls the latest updates on the series of coins that are currently supported in our reporting system. Requests can be made to this system through a curl request that will either get the current data on a series of bitcoin values or  gather historical data over the range specified.
* Once this data is received, the data is presented through Kafka to be received and is stored as necessary to satisfy customer requests.
* The parts of this system is logically a Kafka implementation and Flask which does the asynchromous requests to an external service to gather data about a variety of digital coins. Flask then produces all events to Kafka so that it is ready for a Spark system to consume the data and log it to HDFS in a fashion that allows it to queried using Presto.

2. __User Interaction Processing System__:
* The second part of the system constitutes the streaming part that reads the coin events from the Financial Data Pipeline and writes them to parquet files suitable for querying with Presto.
* Requests are made by a user using Curl (can be simulated) with a particular portfolio. This request travels through Flask which posts events though Kafka to have Presto requests for the data to provide portfolio tracking. If the data is not already stored, a request is made to Financial Data Pipeline to gather the missing data. 
* As complete a response is given to the user and as data arrives from the financial pipeline, updates are made to the portfolio value until the full return and a graph of the performance over the time frame that was requested.