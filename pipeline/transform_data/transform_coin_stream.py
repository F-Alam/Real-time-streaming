#!/usr/bin/env python
"""Extract events from kafka and write them to hdfs
"""
import json
from pyspark.sql import SparkSession, Row
from pyspark.sql.functions import udf, from_json
from pyspark.sql.types import StructType, StructField, StringType, FloatType, DateType

def coin_event_schema():
    """                                                                                                                                                                                   root
    |-- name: string (nullable = true)
    |-- symbol: string (nullable = true)
    |-- id: string (nullable = true)
    |-- current_price: string (nullable = true)
    |-- last_updated: string (nullable = true)
   """
    final_schema = StructType([
        StructField("name", StringType(), True),
        StructField("id", StringType(), True),
        StructField("symbol", StringType(), True),
        StructField("current_price", StringType(), True),
        StructField("last_updated", StringType(), True)])

    return final_schema

def main():
    """main
    """
    spark = SparkSession \
        .builder \
        .appName("ExtractEventsJob") \
        .enableHiveSupport() \
        .getOrCreate()
    
    spark.sparkContext.setLogLevel("ERROR")

    raw_events = spark \
        .readStream \
        .format("kafka") \
        .option("kafka.bootstrap.servers", "kafka:29092") \
        .option("subscribe", "coin_quotes") \
        .load()
    
    extracted_coin_quotes_events = raw_events \
        .select(raw_events.value.cast('string').alias('raw_event'),
                raw_events.timestamp.cast('string'),
                from_json(raw_events.value.cast('string'),
                          coin_event_schema()).alias('json')) \
        .select('json.*')
#        .select('raw_event', 'timestamp', 'json.*')

    sink = extracted_coin_quotes_events \
        .writeStream \
        .format("parquet") \
        .option("checkpointLocation", "/tmp/checkpoints_for_coin_quotes_events") \
        .option("path", "/tmp/coin_data") \
        .trigger(processingTime="10 seconds") \
        .start()

    sink.awaitTermination()
    
if __name__ == "__main__":
    main()
