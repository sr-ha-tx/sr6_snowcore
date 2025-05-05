from snowflake.snowpark import Session
from my_globals import *
import sys
import logging

# Initiate Loggong at INFO level
logging.basicConfig(stream=sys.stdout, level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s', datefmt='%I:%M:%S')

# Session builder wrapper function'
def get_snowpark_session() -> Session:
    return Session.builder.configs(spark_conn_params).create()

def main():
    session = get_snowpark_session()

    context_df = session.sql("select current_role(), current_database(), current_schema(), current_warehouse()")
    context_df.show()
    customer_df = session.sql("select c_custkey,c_name,c_phone,c_mktsegment from snowflake_sample_data.tpch_sf1.customer limit 10")
    customer_df.show(5)
    session.close()

if __name__ == '__main__':
    main()