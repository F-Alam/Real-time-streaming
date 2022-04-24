## W205 - Project 3 - "_Real-time streaming of digital currency data for investors_"
### __Team__: Greg Tully, Ferdous Alam, Ricardo Jenez
### __Date__: 4/11/2021

### Code:

#### Code for Automated Pipeline Set Up:
- [__pipeline_setup.sh__](pipeline/scripts/pipeline_setup.sh): This file contains a script that sets up the entire pipeline ([example of the script output](docs/Pipeline_script_example.md):
    1. __Sets up Clusters__: Full cluster waiting until ready to go ([__cluster_up.sh__](pipeline/scripts/cluster_up.sh)).
    2. __Creates Topics__: Creates Kafka topics ([__setup_events.sh__](pipeline/init/setup_events.sh)).
    3. __Produces events to Kafka__: Produces streaming coin data using Flask ([__gatherbitcoin.sh__](pipeline/get_data/gatherbitcoin.sh)) and gathers historic coin data ([__init_coin_data.sh__](pipeline/init/init_coin_data.sh)).
    4. __Consumes events from Kafka__: Sets up Spark streaming to consume the coin data ([__transformcoin.sh__](pipeline/transform_data/transformcoin.sh)).
    5. __Analytics with Presto__: Sets up a Hive table for Presto querying ([__hive_setup.sh__](analysis/scripts/hive_setup.sh)) and launches Jupyter notebook ([__notebook_up.sh__](analysis/scripts/notebook_up.sh)) to run Presto queries (from the parquet tables set up in Hive) and show example analyitcs.
    
---
#### Code for each stage of Pipeline:
#### 1. Set up Clusters:
- Pipeline_setup first starts ([__cluster_up.sh__](pipeline/scripts/cluster_up.sh)) to execute the following:
    - Check that all Docker clusters are down.
    - Read [__docker-compose.yml__](pipeline/docker-compose.yml) to spin up the Docker clusters for Kafka, Spark, Coudera Hadoop, Presto, Zookeeper, and Mids.
    - The script waits for all the clusters to come up before moving on.

#### 2. Create Topics:
- Pipeline_setup starts [__setup_events.sh__](pipeline/init/setup_events.sh), a script that creates all the Kafka topics for the pipeline.
- The user can run [__watch_kafka.sh__](monitor/watch_kafka.sh) in a seperate terminal to watch the Kafka logs for events.

#### 3. Produce events to Kafka:
- Pipeline_setup starts [__gatherbitcoin.sh__](pipeline/get_data/gatherbitcoin.sh), a script that launches [__finance_data.py__](pipeline/get_data/finance_data.py) to set up the Flask scheduler to connect with CoinGecko and request coin data.
- Flask starts to produce  events to Kafka.
- Pipeline_set up then starts [__init_coin_data.sh__](pipeline/init/init_coin_data.sh), a script that does curl calls to Flask to gather historic data on currencies from Jan 1, 2013 to present. This enables analytics on historic data such as long-term returns or trends.

#### 4. Consume events from Kafka:
- Pipeline_setup starts [__transformcoin.sh__](pipeline/transform_data/transformcoin.sh), a script that launches [__transform_coin_stream.py__](pipeline/transform_data/transform_coin_stream.py) to set up a streaming Spark job to consume the coin data events produced by Flask through the Kafka broker.
- The script defines a schema and then writes the events as parquet files in a temporary folder in the Hadoop Distributed File System (HDFS) environment, suitable for Presto to query.

#### 5. Analytics in a Jupyter notebook with Presto:
- Pipeline_setup starts [__hive_setup.sh__](analysis/scripts/hive_setup.sh), a script that launches [__setup_hive_tables.py__](analysis/src/setup_hive_tables.py) to initialize a table in Hive that the parquet files can be read into and Presto can read from.
- Once the table in Hive is ready, Pipeline_setup starts ([__notebook_up.sh__](analysis/notebooks/project-3-presto.ipynb)), a script that launches a Jupyter notebook to run example Presto queries and create plot tables & charts for analysis.