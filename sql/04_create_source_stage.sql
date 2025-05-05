use schema source;
create or replace stage int_stage;
create or replace temp stage temp_stage;


-- following put command can be executed
/*
-- csv example
date1 2020-01-02
date2 2020-01-31
put file://data/3-region-sales-data/sales/source=IN/format=csv/date=2020-01-02/order-20200102.csv @sales_dwh.source.my_internal_stg/sales/source=IN/format=csv/date=2020-01-02 auto_compress=False overwrite=True, parallel=3 ;
put file://data/3-region-sales-data/sales/source=IN/format=csv/date=2020-01-31/order-20200131.csv @sales_dwh.source.my_internal_stg/sales/source=IN/format=csv/date=2020-01-31 auto_compress=False overwrite=True, parallel=3 ;

-- json example
put file://data/3-region-sales-data/sales/source=FR/format=json/date=2020-01-02/order-20200102.json @sales_dwh.source.my_internal_stg/sales/source=FR/format=json/date=2020-01-02 auto_compress=False overwrite=True, parallel=3 ;
put file://data/3-region-sales-data/sales/source=FR/format=json/date=2020-01-31/order-20200131.json @sales_dwh.source.my_internal_stg/sales/source=FR/format=json/date=2020-01-31 auto_compress=False overwrite=True, parallel=3 ;

-- parquet example
put file://data/3-region-sales-data/sales/source=US/format=parquet/date=2020-01-02/order-20200102.snappy.parquet @sales_dwh.source.my_internal_stg/sales/source=US/format=parquet/date=2020-01-02 auto_compress=False overwrite=True, parallel=3 ;
put file://data/3-region-sales-data/sales/source=US/format=parquet/date=2020-01-31/order-20200131.snappy.parquet @sales_dwh.source.my_internal_stg/sales/source=US/format=parquet/date=2020-01-31 auto_compress=False overwrite=True, parallel=3 ;
*/

show warehouses;
show stages;
list @int_stage;
remove @int_stage;


select * from sales_db.common.exchange_rate limit 100;