## W205 - Project 3 - "_Real-time streaming of digital currency data for investors_"
### __Team__: Greg Tully, Ferdous Alam, Ricardo Jenez
### __Date__: 4/11/2021

### Example of Output from Automated Pipeline Set Up:
Use pipeline_setup.sh script in order to bring up the the whole pipeline:
```
jupyter@~/w205/project3/w205-project3-alam-jenez-tully/pipeline/scripts (main)$ ./pipeline_setup.sh 
Bringing up cluster
cluster_up.sh
Fist making sure cluster is down
Creating network "pipeline_default" with the default driver
Creating pipeline_cloudera_1  ... done
Creating pipeline_mids_1      ... done
Creating pipeline_zookeeper_1 ... done
Creating pipeline_presto_1    ... done
Creating pipeline_spark_1     ... done
Creating pipeline_kafka_1     ... done
Waiting for cluster to come up [may take up to 120 seconds]....5....10..
Cluster cloudera kafka mids presto spark zookeeper is Up!
Setup kafka topics
setup_events.sh
Creating topics coin_events, coins_manage_events
WARNING: Due to limitations in metric names, topics with a period ('.') or underscore ('_') could collide. To avoid issues it is best to use either, but not both.
Created topic coin_events.
WARNING: Due to limitations in metric names, topics with a period ('.') or underscore ('_') could collide. To avoid issues it is best to use either, but not both.
Created topic coin_quotes.
WARNING: Due to limitations in metric names, topics with a period ('.') or underscore ('_') could collide. To avoid issues it is best to use either, but not both.
Created topic coin_history.
WARNING: Due to limitations in metric names, topics with a period ('.') or underscore ('_') could collide. To avoid issues it is best to use either, but not both.
Created topic coin_quotes_request.
WARNING: Due to limitations in metric names, topics with a period ('.') or underscore ('_') could collide. To avoid issues it is best to use either, but not both.
Created topic coin_history_request.
WARNING: Due to limitations in metric names, topics with a period ('.') or underscore ('_') could collide. To avoid issues it is best to use either, but not both.
Created topic coin_manage_events.
Setup Coin gathering (flask)
gatherbitcoin.sh -b d 
Checking if flask and coin pipeline is up
Waiting for flask finance pipeline to come up...5..Coin finance pipeline is up
Setting up transform coin streaming spark
transformcoin.sh -b d
Waiting for streaming spark to be up
Waiting On Transform Streaming to place resultsCoin Transform Streaming is Up!
Initializing pipeline with historical data
init_coin_data.sh > /dev/null
Setup Hive Tables for Presto
hive_setup.sh
Using Spark's default log4j profile: org/apache/spark/log4j-defaults.properties
21/04/11 23:39:04 INFO SparkContext: Running Spark version 2.2.0
21/04/11 23:39:04 WARN NativeCodeLoader: Unable to load native-hadoop library for your platform... using builtin-java classes where applicable
21/04/11 23:39:04 INFO SparkContext: Submitted application: Setup Hive Job
21/04/11 23:39:04 INFO SecurityManager: Changing view acls to: root
21/04/11 23:39:04 INFO SecurityManager: Changing modify acls to: root
21/04/11 23:39:04 INFO SecurityManager: Changing view acls groups to: 
21/04/11 23:39:04 INFO SecurityManager: Changing modify acls groups to: 
21/04/11 23:39:04 INFO SecurityManager: SecurityManager: authentication disabled; ui acls disabled; users  with view permissions: Set(root); groups with view permissions: Set(); users  with modify permissions: Set(root); groups with modify permissions: Set()
21/04/11 23:39:05 INFO Utils: Successfully started service 'sparkDriver' on port 40591.
21/04/11 23:39:05 INFO SparkEnv: Registering MapOutputTracker
21/04/11 23:39:05 INFO SparkEnv: Registering BlockManagerMaster
21/04/11 23:39:05 INFO BlockManagerMasterEndpoint: Using org.apache.spark.storage.DefaultTopologyMapper for getting topology information
21/04/11 23:39:05 INFO BlockManagerMasterEndpoint: BlockManagerMasterEndpoint up
21/04/11 23:39:05 INFO DiskBlockManager: Created local directory at /tmp/blockmgr-8fcc6b14-e19e-416b-a53e-acd17b8fd32a
21/04/11 23:39:05 INFO MemoryStore: MemoryStore started with capacity 366.3 MB
21/04/11 23:39:05 INFO SparkEnv: Registering OutputCommitCoordinator
21/04/11 23:39:05 WARN Utils: Service 'SparkUI' could not bind on port 4040. Attempting port 4041.
21/04/11 23:39:05 INFO Utils: Successfully started service 'SparkUI' on port 4041.
21/04/11 23:39:05 INFO SparkUI: Bound SparkUI to 0.0.0.0, and started at http://172.27.0.6:4041
21/04/11 23:39:06 INFO SparkContext: Added file file:/w205/project3/w205-project3-alam-jenez-tully/analysis/src/setup_hive_tables.py at file:/w205/project3/w205-project3-alam-jenez-tully/analysis/src/setup_hive_tables.py with timestamp 1618184346125
21/04/11 23:39:06 INFO Utils: Copying /w205/project3/w205-project3-alam-jenez-tully/analysis/src/setup_hive_tables.py to /tmp/spark-ba574d50-1398-4b63-8407-c8e5c558fd2e/userFiles-ee8b1d46-19ed-4974-b42f-74a6b6842b7f/setup_hive_tables.py
21/04/11 23:39:06 INFO Executor: Starting executor ID driver on host localhost
21/04/11 23:39:06 INFO Utils: Successfully started service 'org.apache.spark.network.netty.NettyBlockTransferService' on port 46505.
21/04/11 23:39:06 INFO NettyBlockTransferService: Server created on 172.27.0.6:46505
21/04/11 23:39:06 INFO BlockManager: Using org.apache.spark.storage.RandomBlockReplicationPolicy for block replication policy
21/04/11 23:39:06 INFO BlockManagerMaster: Registering BlockManager BlockManagerId(driver, 172.27.0.6, 46505, None)
21/04/11 23:39:06 INFO BlockManagerMasterEndpoint: Registering block manager 172.27.0.6:46505 with 366.3 MB RAM, BlockManagerId(driver, 172.27.0.6, 46505, None)
21/04/11 23:39:06 INFO BlockManagerMaster: Registered BlockManager BlockManagerId(driver, 172.27.0.6, 46505, None)
21/04/11 23:39:06 INFO BlockManager: Initialized BlockManager: BlockManagerId(driver, 172.27.0.6, 46505, None)
21/04/11 23:39:06 INFO SharedState: loading hive config file: file:/spark-2.2.0-bin-hadoop2.6/conf/hive-site.xml
21/04/11 23:39:06 INFO SharedState: Setting hive.metastore.warehouse.dir ('null') to the value of spark.sql.warehouse.dir ('file:/spark-2.2.0-bin-hadoop2.6/spark-warehouse').
21/04/11 23:39:06 INFO SharedState: Warehouse path is 'file:/spark-2.2.0-bin-hadoop2.6/spark-warehouse'.
21/04/11 23:39:08 INFO HiveUtils: Initializing HiveMetastoreConnection version 1.2.1 using Spark classes.
21/04/11 23:39:08 INFO metastore: Trying to connect to metastore with URI thrift://cloudera:9083
21/04/11 23:39:09 INFO metastore: Connected to metastore.
21/04/11 23:39:09 INFO SessionState: Created local directory: /tmp/b1ab0027-456f-404d-9552-c7a871e5990b_resources
21/04/11 23:39:09 INFO SessionState: Created HDFS directory: /tmp/hive/root/b1ab0027-456f-404d-9552-c7a871e5990b
21/04/11 23:39:09 INFO SessionState: Created local directory: /tmp/root/b1ab0027-456f-404d-9552-c7a871e5990b
21/04/11 23:39:09 INFO SessionState: Created HDFS directory: /tmp/hive/root/b1ab0027-456f-404d-9552-c7a871e5990b/_tmp_space.db
21/04/11 23:39:09 INFO HiveClientImpl: Warehouse location for Hive client (version 1.2.1) is file:/spark-2.2.0-bin-hadoop2.6/spark-warehouse
21/04/11 23:39:10 INFO SessionState: Created local directory: /tmp/bc0fc446-69ab-4214-9291-310c7d66f69a_resources
21/04/11 23:39:10 INFO SessionState: Created HDFS directory: /tmp/hive/root/bc0fc446-69ab-4214-9291-310c7d66f69a
21/04/11 23:39:10 INFO SessionState: Created local directory: /tmp/root/bc0fc446-69ab-4214-9291-310c7d66f69a
21/04/11 23:39:10 INFO SessionState: Created HDFS directory: /tmp/hive/root/bc0fc446-69ab-4214-9291-310c7d66f69a/_tmp_space.db
21/04/11 23:39:10 INFO HiveClientImpl: Warehouse location for Hive client (version 1.2.1) is file:/spark-2.2.0-bin-hadoop2.6/spark-warehouse
21/04/11 23:39:10 INFO StateStoreCoordinatorRef: Registered StateStoreCoordinator endpoint
Please Pick you interface to access Presto or Exit
Do you wish to use (P)resto,(J)upyter notebook or (E)xit? [p/j/e]: j

Using Jupyter
Creating jupyter notebook - this script will run in the foreground because we need to get the token
[I 23:39:44.122 NotebookApp] Writing notebook server cookie secret to /root/.local/share/jupyter/runtime/notebook_cookie_secret
[I 23:39:44.162 NotebookApp] Serving notebooks from local directory: /w205
[I 23:39:44.162 NotebookApp] 0 active kernels 
[I 23:39:44.162 NotebookApp] The Jupyter Notebook is running at: http://0.0.0.0:8888/?token=36ca98eaed4d58f5776f699c6960049e21975eff82ef4184
[I 23:39:44.162 NotebookApp] Use Control-C to stop this server and shut down all kernels (twice to skip confirmation).
[C 23:39:44.163 NotebookApp] 
    
    Copy/paste this URL into your browser when you connect for the first time,
    to login with a token:
        http://0.0.0.0:8888/?token=36ca98eaed4d58f5776f699c6960049e21975eff82ef4184


```