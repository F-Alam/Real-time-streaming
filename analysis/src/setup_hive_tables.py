#!/usr/bin/env python
"""Extract events from kafka and write them to hdfs
"""
import json
from pyspark.sql import SparkSession, Row
from pyspark.sql.functions import udf, from_json
from pyspark.sql.types import StructType, StructField, StringType, FloatType, DateType

def main():
    """main
    """
    spark = SparkSession \
        .builder \
        .appName("Setup Hive Job") \
        .enableHiveSupport() \
        .getOrCreate()
    
    spark.sparkContext.setLogLevel("ERROR")

    query = """
    create external table if not exists default.coin_quotes (
         name string,
         id string,
         symbol string,
         current_price string,
        last_updated string
    )
    stored as parquet
    location '/tmp/coin_data'
    tblproperties ("parquet.compress"="SNAPPY")
    """
    spark.sql(query)


if __name__ == "__main__":
    main()
