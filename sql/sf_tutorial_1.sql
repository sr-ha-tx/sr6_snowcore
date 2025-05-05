select current_role(), current_warehouse(), current_database(), current_schema(), current_available_roles(), current_client(), current_ip_address(), current_date();
use role accountadmin;show warehouses;use role sysadmin;
select current_region();
use role sysadmin;
create warehouse my_wh;
-- create a database
create database my_db
comment = 'this is my DB';

--drop database my_db;

show databases like 'MY%';

create schema my_schema
comment = 'this is my schema';

show schemas like 'MY%';

create or replace table my_table(
    id int autoincrement,
    num number,
    num10_1 number(10,1),
    decimal20_2 decimal(20,2),
    numeric numeric(30,3),
    int int,
    integer integer
);
describe table my_table;

select get_ddl('table', 'my_table');
use role sysadmin;
use warehouse COMPUTE_WH;
insert into my_db.my_schema.my_table(num, num10_1, decimal20_2, numeric, int, integer)
values (1.1,1.25,1.3,1.4,1.5,1.6)
,(2,2.5,2.6,2.7,2.8,2.9);

select * from my_table;

create or replace table my_table2(
    id int autoincrement,
    v varchar,
    v50 varchar(50),
    c char,
    c10 char(10),
    s string,
    s20 string(20),
    t text,
    t30 text(30)
);
describe table my_table2;

create or replace table my_ts_table(
    id int,
    today date default current_date() not null,
    now_time time default current_time() not null ,
    now_ts timestamp default current_timestamp() not null
);
desc table my_ts_table;

insert into my_ts_table(id) values (1);
select * from my_ts_table;


create or replace table my_constraints_table(
    emp_pk string primary key,
    fname string not null,
    lname string not null,
    flag string default 'active',
    unique_code string unique
);
insert into my_constraints_table(emp_pk, fname, lname, unique_code)
values ('100', 'John1', 'K', '1000'),
       ('100', 'John1', 'K', '1000');

select * from my_constraints_table;

-- Loading data using PUT command
-- Create a named stage
-- put <local file path> @<named stage>;
-- list @my_stg; will list all files in stage
-- To read a file from stage
--      select t.$1, t.$2, t.$3 ...  from @<named_stage> (file_format => 'my_csv_format') t
-- Copy from Stage into Table
-- copy into <table_name> from @<stage_name>;
create or replace file format my_csv_format
    type = 'csv'
    field_delimiter = ',';

-- Below both are valid ways to insert data from existing table into new table
-- create table <name> as select * from <existing_table>;
-- insert into <name> (*columns)
--     select * from <existing_table>;

-- select current_timestamp();

-- alter session set timezone = 'America/Chicago';

-- show parameters like '%TIME%';

-- use role sysadmin; alter account set TIMEZONE ='America/Chicago';
select * from MY_DB.INFORMATION_SCHEMA.TABLES where table_name like 'MY%';