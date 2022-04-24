## W205 - Project 3 - "_Real-time streaming of digital currency data for investors_"
### __Team__: Greg Tully, Ferdous Alam, Ricardo Jenez
### __Date__: 4/11/2021

### __Summary__:

#### Research Question:
- Digital currencies such as bitcoin have taken off—bitcoin launched in 2009 with almost no value and today it is worth nearly __$60,000!__
- With so much [hype](https://www.forbes.com/advisor/investing/bitcoin-price-near-highs/) around digital currencies, prices can be highly volatile. For example, in the first weekend of 2021, __bitcoin rose 20%. The next Sunday, it fell 20%__.
- Savvy investors can exploit market volatility to generate significant returns; however, they need real-time financial data at their fingertips to monitor performance and identify potential signals to trade on.
- To address this challenge, our team set out to build a streaming digital currency data pipeline so that an investor can have full access to real-time data for decision-making.

#### Streaming Data: 
-  [CoinGecko](https://www.coingecko.com/en) provides digital currency data such as live quotes, trading volume, and historical data on more than 7,000 coins, such as bitcoin, litecoin, ethereum.
- The [CoinGecko API](https://www.coingecko.com/en/api) is free and allows up to 10 calls per second which is more than enough to set up a real-time streaming pipeline ([API documentation here](https://www.coingecko.com/api/documentations/v3)).

#### Pipeline Overview: 
1.  __Flask__ requests __historic__ and __real-time__ digital currency quotes (e.g., bitcoin, litecoin, ethereum) from the __CoinGecko API__ and produces events to the __Kafka__ broker.
2. __Spark__ consumes these events from __Kafka__ and writes them to __parquet files__ in __HDFS__. These parquet files are appended, in real time, to a table in __Hive__ and ready for query.
3. Financial analytics can be done in __real-time__ using __Presto__ (via Jupyter notebook) to query the streaming data from the table in Hive.

#### Pipeline Set Up Instructions:
1. Type the command "__./pipeline_setup.sh__" at the bash prompt.
2. Watch the terminal as the pipeline sets up. Status messages will automatically print out indicating progress.
3. You may type the command "__./watch_kafka.sh__" in another terminal to watch the Kafka logs for events.
4. When the pipeline is set up and streaming data, a URL with a token to a Jupyter notebook will print.
5. Copy & paste the URL into your browser when you connect for the first time. 
6. Run the code in the notebook to analyze and plot streaming data in real-time.

#### Links to Reports:
- [Code Description](docs/Code.md)
- [Pipeline Description](docs/Pipeline.md)
- [Analysis Example](analysis/notebooks/project-3-presto.ipynb)
- [Project Presentation](docs/w205_Project3_Presentation.pdf)

#### Tools to replicate:
- Flask
- Kafka
- Spark (Pyspark)
- Hadoop - Cloudera
- Hive
- Presto
- Python
- JSON
- Jupyter Notebook