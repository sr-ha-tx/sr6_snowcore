use role sysadmin;
create database if not exists sales_dwh;
grant create schema on database sales_dwh to role snowpark_role;grant create schema on database sales_dwh to role snowpark_role; 
grant modify on database sales_dwh to role snowpark_role; 
grant monitor on database sales_dwh to role snowpark_role; 
grant usage on database sales_dwh to role snowpark_role;

use role snowpark_role;
use database sales_db;
create schema if not exists source;
create schema if not exists curated;
create schema if not exists consumptiion;
create schema if not exists audit;
create schema if not exists common;

alter schema sales_db set data_retention_time_in_days=0;

show schemas;
show warehouses;