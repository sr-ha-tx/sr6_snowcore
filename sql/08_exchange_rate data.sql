-- put file://my-location/forex/exchange-rate.csv @my_internal_stg/exchange/ parallel=10 auto_compress=false;;

list @sales_db.common.int_stage/exchange/;

use schema common;
show tables;
drop table sales_db.common.exchange_rate;
drop table sales_db.common.exchange_rate;
create or replace transient table exchange_rate(
    exchange_dt date, 
    usd2usd decimal(10,7),
    usd2eu decimal(10,7),
    usd2can decimal(10,7),
    usd2uk decimal(10,7),
    usd2inr decimal(10,7),
    usd2jp decimal(10,7)
);

copy into sales_db.common.exchange_rate
from 
(
select 
    t.$1::date as exchange_dt,
    to_decimal(t.$2) as usd2usd,
    to_decimal(t.$3,12,10) as usd2eu,
    to_decimal(t.$4,12,10) as usd2can,
    to_decimal(t.$4,12,10) as usd2uk,
    to_decimal(t.$4,12,10) as usd2inr,
    to_decimal(t.$4,12,10) as usd2jp
from 
     @sales_db.common.int_stage/exchange/exchange-rate-data.csv
     (file_format => 'sales_db.common.my_csv_format') t
);

select * from sales_db.common.exchange_rate limit 100;

select * from sales_db.source.in_sales_order limit 100;