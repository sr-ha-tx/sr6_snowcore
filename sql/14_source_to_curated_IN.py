import os
from snowflake.snowpark import Session, DataFrame
from snowflake.snowpark.functions import col, lit, row_number, rank
from snowflake.snowpark import Window
import sys
import logging
from my_globals import spark_conn_params

# Initiate Loggong at INFO level
logging.basicConfig(stream=sys.stdout, level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s', datefmt='%I:%M:%S')

def get_snowpark_session() -> Session:
    return Session.builder.configs(spark_conn_params).create()

def filter_dataset(df, column_name, filter_criterion) -> DataFrame:
    return_df = df.filter(col(column_name) == filter_criterion)
    return return_df

def main():
    session = get_snowpark_session()
    sales_df = session.table('sales_db.source.in_sales_order')
    forex_df = session.table('sales_db.common.exchange_rate')

    sales_df = sales_df.filter(col('PAYMENT_STATUS') == 'Paid' and col('SHIPPING_STATUS') == 'Delivered')

    sales_df = sales_df.with_column('COUNTRY', lit('IN')).with_column('REGION', lit('APAC'))

    sales_df = sales_df.join(forex_df, sales_df['ORDER_DT'] == forex_df['EXCHANGE_DT'], join_type='left')

    sales_df = sales_df.with_column('order_rank', rank().over(Window.partitionBy(col('ORDER_DT')).order_by(col('_metadata_last_modified').desc()))).filter(col('order_rank')==1)

    sales_df.select(
        col('SALES_ORDER_KEY'),
        col('ORDER_ID'),
        col('ORDER_DT'),
        col('CUSTOMER_NAME'),
        col('MOBILE_KEY'),
        col('Country'),
        col('Region'),
        col('ORDER_QUANTITY'),
        lit('INR').alias('LOCAL_CURRENCY'),
        col('UNIT_PRICE').alias('LOCAL_UNIT_PRICE'),
        col('PROMOTION_CODE').alias('PROMOTION_CODE'),
        col('FINAL_ORDER_AMOUNT').alias('LOCAL_TOTAL_ORDER_AMT'),
        col('TAX_AMOUNT').alias('local_tax_amt'),
        col('USD2INR').alias("Exhchange_Rate"),
        (col('FINAL_ORDER_AMOUNT')/col('USD2INR')).alias('US_TOTAL_ORDER_AMT'),
        (col('TAX_AMOUNT')/col('USD2INR')).alias('USD_TAX_AMT'),
        col('payment_status'),
        col('shipping_status'),
        col('payment_method'),
        col('payment_provider'),
        col('mobile').alias('conctact_no'),
        col('shipping_address')
    ).write.save_as_table('sales_db.curated.in_sales_order', mode='append')

if __name__ == '__main__':
    main()

