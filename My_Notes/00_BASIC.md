# Snowflake Tutorial Concepts

## Available Roles at Account Creation
```
- ORGADMIN
- ACCOUNTADMIN
- SYSADMIN
- SECURITYADMIN
- USERADMIN
- PUBLIC
```
- **ACCOUNTADMIN** inherits everything from SYSADMIN & SECURITYADMIN
- **SECURITYADMIN** inherits everything from USERADMIN
- **SYSADMIN** is used to create and inherits all other custom roles 
- **PUBLIC** is inherited by all other roles

![](My_Notes\Images\default_role_hierarchy.png)

## Time Travel
### Snowflake Time Travel  
>To support Time Travel, the following SQL extensions have been implemented:
AT|BEFORE clause based on  
TIMESTAMP  
OFFSET  
STATEMENT  
`UNDROP** commmand for databases, tables, schemas.`  
![](My_Notes\Images\time_travel.png)

#### Data Retention Period  
The standard retention period is 1 day(24 hours) and is automatically enabled for all Snowflake accounts.
- **Standard** Edition - 0 to 1 day at the account and object level.
- **Enterprise** Edition and higher -  
`  0-1 for Transient DB/Schema/Tables`  
` 0-90 for Permanent/Temporary DB/Scema/Tables`

> `DATA_RETENTION_TIME_IN_DAYS` object parameter can be used by users with ACCOUNTADMIN role to set default for ACCOUNT  
The same parameter can be used to explicitly override when creating a DB/Schema or Table.  
It can be changed for those objects at any time.  
ACCOUNTADMIN can apply a `MIN_DATA_RETENTION_TIME_IN_DAYS`

> Sample Queries  
`select * from my_table at(timestamp => 'Fri, 01 May 2015 16:20:00 -07:00'::timestamp_tz);`  
`select * from my_table at(offset => -60*5);`  
`select * from my_table before(statement => '58afg8i8a8fbv9-gafu8af-98f6ak9bfa8');`  
``CREATE TABLE|SCHEMA|DATABSE <restored_db\> CLONE mytab|mysch|mydb at|before(---);`  

> Listing Dropped Objects  
`show [TABLES | SCHEMAS | DATABASES] HISTORY [LIKE <pattern\>] [IN [DB/SCHEMA]];`  
Once the retention period has passed, its no longer displayed with HISTORY
  
<br />

## Types of Table
1. **PERMANENT** - Last until deleted
1. **TRANSIENT** - Last until deleted (but no time travel and fail safe copies)
1. **TEMPORARY** - Last only for the session
<br />
<br />

## ACCOUNTADMIN Role
>The account administrator (i.e users with the ACCOUNTADMIN system role) role is the most powerful role in the system. This role alone is responsible for configuring parameters at the account level. Users with the ACCOUNTADMIN role can view and manage Snowflake billing and credit data, and can stop any running SQL statements.  
Note that ACCOUNTADMIN is **not a superuser role**. This role only allows viewing and managing objects in the account if this role, or a role lower in a role hierarchy, has sufficient privileges on the objects.  
In the system role hierarchy, the other administrator roles are children of this role:  
>>- The user administrator (USERADMIN) role includes the privileges to create and manage users and roles (assuming ownership of those roles or users has not been transferred to another role).  
>>- The security administrator (i.e users with the SECURITYADMIN system role) role includes the global MANAGE GRANTS privilege to grant or revoke privileges on objects in the account. The USERADMIN role is a child of this role in the default access control hierarchy.  
>>- The system administrator (SYSADMIN) role includes the privileges to create warehouses, databases, and all database objects (schemas, tables, etc.).  

<br />

## Data Type Notes
>- By default all decimal/int/integer/number/numeric treated as NUMERIC(38,0) if size is not explicitly mentioned
>- By default unsized string/varchar/text will be treated as VARCHAR(16777216) ~16MB [char treated as 1 length]
>- For floats always specify precision otherwise it will waste a lot of storage.
>- NULL is considered NULL and not false in case of **boolean**
>- TIME is taken with default precision of 9
>- TIMEZONE is defaulted to TIMESTAMP_NTZ(9) so no timezone info is saved.

## Loading Data into Tables
- UI loads are limited to under 50MB


## CONSTRAINTS
- Snowflake supports defining and maintaining constraints, but **DOES NOT** enforce them except **NOT NULL**. Hence **Primary Key** and **UNIQUE** are not enforced.


## CREATE USER (use USERADMIN role)  
```
CREATE OR REPLACE USER [IF NOT EXISTS] <USER_NAME>  
[ objectProperties ]  
[ objectParams ]  
[ sessionParams ]  
[ [ WITH ] TAG ( <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' , ... ] ) ]  
```
 >objectProperties ::=  
  PASSWORD = '\<string>'  
  LOGIN_NAME = \<string>  
  DISPLAY_NAME = \<string>  
  FIRST_NAME = \<string>  
  MIDDLE_NAME = \<string>  
  LAST_NAME = \<string>  
  EMAIL = \<string>  
  MUST_CHANGE_PASSWORD = TRUE | FALSE  
  DISABLED = TRUE | FALSE  
  DAYS_TO_EXPIRY = \<integer>  
  MINS_TO_UNLOCK = \<integer>  
  DEFAULT_WAREHOUSE = \<string>  
  DEFAULT_NAMESPACE = \<string>  
  DEFAULT_ROLE = \<string>  
  DEFAULT_SECONDARY_ROLES = ( 'ALL'|'NONE' )  
  MINS_TO_BYPASS_MFA = \<integer>  
  RSA_PUBLIC_KEY = \<string>  
  RSA_PUBLIC_KEY_2 = \<string>  
  COMMENT = '<string_literal>'  

 >objectParams ::=  
  NETWORK_POLICY = \<string>  

 >sessionParams ::=
  ABORT_DETACHED_QUERY = TRUE | FALSE  
  AUTOCOMMIT = TRUE | FALSE  
  BINARY_INPUT_FORMAT = \<string>  
  BINARY_OUTPUT_FORMAT = \<string>  
  DATE_INPUT_FORMAT = \<string>  
  DATE_OUTPUT_FORMAT = \<string>  
  ERROR_ON_NONDETERMINISTIC_MERGE = TRUE | FALSE  
  ERROR_ON_NONDETERMINISTIC_UPDATE = TRUE | FALSE  
  JSON_INDENT = \<num>  
  LOCK_TIMEOUT = \<num>  
  QUERY_TAG = \<string>  
  ROWS_PER_RESULTSET = \<num>  
  SIMULATED_DATA_SHARING_CONSUMER = \<string>  
  STATEMENT_TIMEOUT_IN_SECONDS = \<num>  
  STRICT_JSON_OUTPUT = TRUE | FALSE  
  TIMESTAMP_DAY_IS_ALWAYS_24H = TRUE | FALSE  
  TIMESTAMP_INPUT_FORMAT = \<string>  
  TIMESTAMP_LTZ_OUTPUT_FORMAT = \<string>  
  TIMESTAMP_NTZ_OUTPUT_FORMAT = \<string>  
  TIMESTAMP_OUTPUT_FORMAT = \<string>  
  TIMESTAMP_TYPE_MAPPING = \<string>  
  TIMESTAMP_TZ_OUTPUT_FORMAT = \<string>  
  TIMEZONE = \<string>  
  TIME_INPUT_FORMAT = \<string>  
  TIME_OUTPUT_FORMAT = \<string>  
  TRANSACTION_DEFAULT_ISOLATION_LEVEL = \<string>  
  TWO_DIGIT_CENTURY_START = \<num>  
  UNSUPPORTED_DDL_ACTION = \<string>  
  USE_CACHED_RESULT = TRUE | FALSE  
  WEEK_OF_YEAR_POLICY = \<num>  
  WEEK_START = \<num>  

## ROLES
```
CREATE [ OR REPLACE ] ROLE [ IF NOT EXISTS ] <name>  
[ [ WITH ] TAG ( <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' , ... ] ) ]  
[ COMMENT = '<string_literal>' ]
```
```
GRANT ROLE <name> TO { ROLE <parent_role_name> | USER <user_name> }
```

> **Samples**  
grant usage on warehouse my_wh to role role_dev;  
grant usage on database my_db to role role_dev;  
grant select on future tables in schema my_db.my_schema to role role_dev;  
grant create database on account to role role_dev;

<br />

## Micro-Partitions
Contiguous units of storage between 50-500MB uncompressed each  
Groups of rows in tables are mapped into individual micro-partitions, organized in **columnar fashion**  
Not all predicate expressions can be used to prune.  
For example, Snowflake **does not prune micro-partitions based on a predicate with a subquery, even if the subquery results in a constant**.  
Micro-partitioning is automatically performed on all Snowflake tables. Tables are transparently partitioned using the ordering of the data as it is inserted/loaded.  

`select SYSTEM$CLUSTERING_INFORMATION(\<TABLE_NAME>) to get clustering information.`

> Impact of Micropartitions  
**DML** DML operations like DELETE/UPDATE/MERGE take advantage of underlying micro-partition metadata.  
**QUERY PRUNING** a query that specifies a filter predicate that accesses 10% of the values should ideally scan only 10% of micro-partitions.  
Snowflake uses columnar scanning of partitions so that an entire partition is not scanned if a query only filters by one column.  

## Clustering
Snowflake maintains below Clustering Information for micro-partitions in a table  
Total # of MP  
The # of MP containing values that overlap with each other (in a specified subset of table columns).  
The depth of the overlapping MP  

> Clustering Depth  
measures the average depth (1 or greater) of the overlapping MP for specified columns in table. Smaller is better.

> Monitoring Clustering Info for tables.  
**system$clustering_depth**  
**system$clustering_information**

> **Automatic Clustering**  
You simply define a clustering key to enable auto clustering.  
**CREATE TABLE .. CLUSTER BY (expr1 [, expr2 ..])**  
However this does not apply to CREATE TABLE .. CLONE .. tables. The new table starts with Automatic Clustering suspended.  
>> **ALTER TABLE .. { SUSPEND | RESUME } RECLUSTER**  
> Non-blocking DML  
> No need to provision a Virtual Warehouse, snowflake will provision one and bill you for usage.  

## External Tables
Allows to query data stored in an external stage. Lets you store certain file level metadata including filenames, versions and related properties in Snowflake. Can access data in any format that the COPY INTO command supports. READ ONLY. Use materialized views to improve query performance.  
If SF encounters error while scanning a file in cloud storage, the file is skipped and scanning continues. Partial data can be returned before the error.  

All external tables include the following
- **VALUE**                    a variant type column that represents a single row in external file.  
- **METADATA$FILENAME**        a pseudocolumn that identifies staged file including path in stage.  
- **METADATA$FILE_ROW_NUMBER** a pseudocolumn that shows the row number for each record in staged file.  

```
CREATE OR REPLACE EXTERNAL TABLE \<TABLE_NAME> (  
  col1 as (value:c1::varchar),  
  ...  
)  
with location=\<STAGE_NAME>  
auto_refresh = false
PARTITION by .....  
file_format = (format_name = file_format);  
```

Partitioning External Tables.  
- **Added automatically**  
define partition column in new external table as expression that parse the path and/or filename information stored in METADATA$FILENAME  
```
CREATE EXTERNAL TABLE
  <table_name\>  
     ( <part_col_name\> <col_type\> AS <part_expr\> )  
     [ , ... ]  
  [ PARTITION BY ( <part_col_name\> [, <part_col_name\> ... ] ) ]  
  ..
```  
Snowflake computes and adds partitions based on the defined part column expression whenever metadata is **refreshed.**  

- **Partitions Added Manually**  
define partition_type as user-defined and specifies only data types of partition columns.  
```
CREATE EXTERNAL TABLE
  <table_name\>
     ( <part_col_name\> <col_type\> AS <part_expr\> )
     [ , ... ]
  [ PARTITION BY ( <part_col_name\> [, <part_col_name\> ... ] ) ]
  PARTITION_TYPE = USER_SPECIFIED
  ..  
```
The partition column definitions are expression that parse the column metadata in the internal(hidden) metadata$external_table_partition column.  
The object owner adds partitions to external table manually by executing  

ALTER EXTERNAL TABLE .. ADD PARTITION command.  

ALTER EXTERNAL TABLE <name\> ADD PARTITION ( <part_col_name\> = '<string\>' [ , <part_col_name\> = '<string\>' ] ) LOCATION '<path\>'  

>Information Schema has some relevant external tables info:  
>>View
- EXTERNAL_TABLES view  
>>Table Functions
- AUTO_REFRESH_REGISTRATION_HISTORY
- EXTERNAL_TABLES_FILES
- EXTERNAL_TABLE_FILE_REGISTRATION_HISTORY

## Sequence Objects
`create or replace sequence seq_00 start=1 increment=2 comment='trial sequence';`  
`show sequences` to list all sequences.

## Supported File Formats
> CSV  
JSON  
XML  
AVRO  
ORC  
PARQUET

## Stages
- Table Stage @%[TABLE_NAME]
- User Stage @~
- Named Internal Stage @[STAGE_NAME]
- Named External Stage @[STAGE_NAME]  

`remove <STAGE/folder/file> - to remove a file/folder`  
`drop stage <stage_name> - to drop a stage`  
`list @~ pattern='.*csv';` - list based on patterns only  




## PUT & COPY
**put** does not use a compute WH but copy does  

```
COPY INTO [nasmespace.]\<table_name>  
FROM {internalStage | externalStage | externalLocation } -*can also pass (SELECT cols_with_xfm from src)* for xfm  
[ FILES = ('\<filename>' [ ,'\<filename> ] [,...] ) ]  
[ PATTERN = '\<regex_pattern>' ]  
[ FILE_FORMAT = ( {FORMAT_NAME = '[\<namespace>.] \<file_format_name>' | TYPE = {CSV|JSON|AVRO|ORC|PARQUET|XML} [formatTypeOptions ] } ) ]  
[ copyOptions ]
[ VALIDATION_MODE = RETURN_\<n>_ROWS | RETURN_ERRORS | RETURN_ALL_ERRORS ]

ON_ERROR=ABORT_STATEMENT (*default*) | SKIP_FILE | SKIP_FILE_2 (*skip if n errors*) | SKIP_FILE_1% (*skip if 1% errors*)  

NULL_IF = ('null') -*in File Format*  
EMPTY_FIELD_AS_NULL = TRUE  

PURGE = TRUE *will purge the file from stage once loaded*
```


## Validation
validation_mode = 'RETURN_ERRORS' / 'RETURN_10_ROWS' - does not load the data but it needs a virtual warehouse.


Validate  
select * from table(validate(\<tablename>, job_id => '_last'));

For **PARQUET** can only produce one and only one column of type variant, object, or array. Load data into separate columns using the MATCH_BY_COLUMN_NAME copy option or copy with transformation.  
eg. MATCH_BY_COLUMN_NAME = CASE_INSENSITIVE  

For JSON you have option STRIP_OUTER_ARRAY=TRUE  

COPY metadata stored for 64 days  
PIPE metadata stored for 14 days  

>ACCOUNT_USAGE  
>>LOAD_HISTORY - 365 days tracks COPY INTO  
>>COPY_HISTORY - 365 days tracks COPY INTO + Snowpipe runs  

>INFORMATION_SCHEMA  
>>LOAD_HISTORY - tracks COPY INTO (14 days or 10k rows)  
>>COPY HISTORY - tracks COPY INTO + SNOWPIPE (14 days no row limit)  




## PIPES  
> CREATE [OR REPLACE] PIPE [IF NOT EXISTS] \<name>  
[AUTO_INGEST = [TRUE | FALSE] ]  
[AWS_SNS_TOPIC = \<string>]  
[INTEGRATION = \<string>]  
[COMMENT = \<string> ]  
AS \<COPY STATEMENT>  

> alter pipe <pipe_name> refresh; -this will start pipe copy from external without SNS  

> alter pipe <pipe_name> set pipe_execution_paused = true;

> select system$pipe_status(<pipe_name>);

> select * from table(validate_pipe_load(   
  pipe_name => 'my_pipe',  
  start_time => DATEADD(hour, -1, CURRENT_TIMESTAMP())));    

> alter pipe <pipe_name> refresh prefix='/cust_10*' modified_after='2011-11-11T13:56:56-08:00';


## Storage Integrations
> Can only be created by **ACCOUNTADMIN** role  
> Other roles can be granted **CREATE STAGE** and **USAGE** of created INTEGRATIONS  
> create storage integration awstrial  
    type = external_stage  
    storage_provider = s3  
    storage_aws_role_arn = 'arn:aws:iam::704358581097:role/sf_s3_full_access'  
    enabled = true  
    storage_allowed_locations = ( 's3://sftrialintegration/' )  
    -- storage_blocked_locations = ( 's3://<location1>', 's3://<location2>' )  
    -- comment = '<comment>';  

> grant create stage on schema my_db.my_schema to role role_dev;  
grant usage on integration awstrial to role role_dev;

>>**External Stage**  
create stage my_s3_stage storage_integration = awstrial url = 's3://sftrialintegration/ext/' file_format = csv_ff;  

## External Tables
> For external tables Snowflake automatically adds a column **value** which has a JSON representation of each row with key values named as c1, c2, c3 ... for all teh columns in that row. 

> Every external table will have a **value** field (variant type) and below **metadata** field
>>- metadata$filename - name of file  
>>- metadata$file_row_number - row number in the staged file for the row  
>>- metadata$file_content_key - checksum of staged data file  
>>- metadata$file_last_modified - TIMESTAMP_NTZ of the file for row  
>>- metadata$start_scan_time - TIMESTAMP_LTZ Start timestamp of operation for each record in file

> CREATE OR REPLACE EXTERNAL TABLE my_s3_cust_ext (  
  CUSTOMER_ID int as (value:c1::number),  
  FIRST_NAME string as (value:c2::string),  
  LAST_NAME string as (value:c3::string)  
)  
[partition by (partition_col)]  
with location=@my_s3_stage  
auto_refresh = false  
file_format = (format_name = csv_ff)

> To **refresh** - alter external table \<table> refresh;

> For external tables with **auto_refresh** enabled. Notification Channel can be found by running
>> show external tables;  
>> To check the internal pipe status  
>>>select **system$external_table_pipe_status**('my_s3_cust_auto_refresh_ext');  

>> external table files can be queried from INFORMATION_SCHEMA  
select * from table(information_schema.external_table_files(table_name => 'my_s3_cust_ext'));

>> Retrieve the metadata stored for all files referenced by external tables  
select * from table(information_schema.**external_table_file_registration_history**(table_name=>'\<external table>'))

>> Retrieve billing history for all auto refresh external tables in account  
>> retrieves history for a 30min range, in 5 min periods  
>> select * from table(information_schema.auto_refresh_registration_history(date_range_start=>\<timestamp>  
date_range_end=>\<timestamp>  
object_type=>'external_table'  
))

> Can be described in 2 formats
>> desc external table \<table> type = 'column'; - gives column based desc  
>> desc external table \<table> type = 'stage'; - gives stage information  


## Cloning
> Same as Zero copy cloning

> create or replace [table|database|schema|stream|stage|file format|sequence|task]  
clone [source table|database|schema|stream|stage|file format|sequence|task]  
[ {AT|BEFORE} ({TIMESTAMP=>\<timestamp>} | OFFSET=>\<time_diff> | STATEMENT=>\<statementid>)];

> DB clone will consist of
>> - all schemas
>>> - Permanent tables
>>> - File Formats
>>> - Sequences
>>> - Named External Stages
>>> - Pipes (cannot be cloned directly, only with schema)
>>> - Streams
>>> - Tasks

> Roles and Grants for child level objects are copied however **DB level** roles and grants are not copied.

> For clone tables ACTIVE_BYTES will be 0 (when no change) since its a zero copy clone  
SNOWFLAKE.ACCOUNT_USAGE.TABLE_STORAGE_METRICS  
as we start making changes active bytes start being used.  

> Can only CLONE a transient table into a transient table

> Temporary table can be cloned to TRANSIENT/TEMPORARY tables

> External tables and Internal Stages cannot be cloned

## Data Sharing
> Direct Share - When in same region with same provider no extra cost.

> Provider pays for storage and Consumer uses its own compute.  
> Replication needed for cross-region or cross-cloud shares. Extra costs  

> Reader account - Provider pays for storage and compute both.  
20 reader account allowed by default. Can be increased by support on request.  

## STREAMS
> first class object that can be set upon PERM/TRANS/TEMP/EXTERNAL tables

> adds 3 columns metedata$action, metadata$isupdate, metedata$row_id

> CREATE OR REPLACE STREAM \<STREAM>  
ON TABLE \<TABLE NAME>  
[ APPEND_ONLY = TRUE ] _for external tables use INSERT ONLY = true_  

> show streams;  
Stream also has data retention period. By default it is 14 days.  
Streams cannot be undrop.  

> When a stream is consumed by a DML operation, the offset is moved to that point of time.  

>> ### Consume records from stream
>> To consume stream data, your SQL should be part of a transaction like shown below or a stored procedure  
 
 >>begin transaction;  
>>
>> insert into \<consumer>  
 select cols from \<stream>  
 where metadata$action = 'INSERT' and  
 metadata$isupdate = 'FALSE';  
>>
 >>commit;


## TASKS
> CREATE RE REPLACE TASK \<task>  
WAREHOUSE = \<warehouse>  
SCHEDULE = '1 minute' _can also use cron syntax_  
*[ WHEN  
SYSTEM$STREAM_HAS_DATA('my_stream') ]*
as  
\<STEATEMENT> | \<call my_stored_proc>; _one single statement or call SP_  

> *schedule = 'using cron 5 * * * SUN America/Los_Angeles'*  

> *user_task_managed_initial_warehouse_size - 'XSMALL'* - serverless task  

> for dependencies can use *after = \<parent task>* instead of SCHEDULE  

> once task is created it is in suspended state and needs to be resumed

> show tasks;

> alter task \<task> resume;  

> table(information_schema.task_history())

> grant execute task, execute managed task to role \<role>;

> for dependent tasks, the child tasks should be resumed first and then parent.  


## Roles Grants Users
> show grants to role \<role>;

> show grants on role \<role>;

>create role 'PM_ROLE';  
grant role 'PM_ROLE' to role 'SECURITYADMIN';  
create role 'DEV_ROLE';  
grant role 'DEV_ROLE' to role 'PM_ROLE';  
create role 'ANLYS_ROLE';  
grant role 'ANLYS_ROLE' to role 'PM_ROLE';  
create role 'QA_ROLE';  
grant role 'QA_ROLE' to role 'ANLYS_ROLE';

> use role sysadmin;  
grant create warehouse on account to role 'PM_ROLE';  
grant create database on account to role 'PM_ROLE';

> alter user \<user> set DEFAULT_ROLE = \<default_role>;  
alter user \<user> set DEFAULT_SECONDARY_ROLE = \<secondary_role>;  
use secondary role all;


## Stored Procedures
> allows controlled operations by using 'caller rights' and 'owner rights'  

> CREATE OR REPLACE PROCEDURE \<proc_name(proc_param proc_param_type)>  
RETURNS \<return type>  
LANGUAGE \<language>  
[ VOLATILE | IMMUTABLE ] *just a helper hint*  
CALLED ON NULL INPUT *(default option else **STRICT** | RETURNS NULL ON NULL INPUT)*  
COMMENT = 'sdasd'  
EXECUTE AS owner | caller  
AS  
>>\$$  
.. stored procedure body ..  
return 'SP executed successfully';  
\$$;

> Javascript APIs for SP (can use try catch block for error handling)  
>> var sql_query = "select cols from table where col = '"+*inparam*+"'";  
var sql_statement = snowflake.createStatement( {sqlText: sql_query} );  
var result_scan = sql_statement.execute()  
while(result_scan.next()) {  
  return_value += "\n";  
  return_value += result_scan.getColumnValue(1);   
  return_value += " " + result_scan.getColumnValue(2);  
  return_value += " " + result_scan.getColumnValue(3) + ",";  
}  
return return_value;

> SP allows recursion with max depth of 5  

## User Defined Functions
> UDF can be used inline in SQL  
> show functions; *will list all UDF and builtins*  
>describe function \<func_name(params)>;*params are required*  

> CREATE OR REPLACE [SECURE] FUNCTION calculate_profit(retail_price number, purchase_price number, sold_qty number)  
>returns number(10,2)  
> [ NOT NULL | RETURNS NULL ON NULL INPUT ] *applies to javascript and will not allow UDF to return NULL*  
> LANGUAGE [ sql | javascript ]  
>as  
>\$$  
>
>> select ((retail_price - purchase_price) * sold_qty);  
>
>\$$  


## Views in Snowflake
> You can access views even if you do not have access to base tables  
> CREATE OR REPLACE [*force*] [*SECURE*] [*recursive*] [*materialized*] VIEW \<view_name> as  
>> .. SELECT QUERY .. ;  

> Only secure views can be shared  

> show terse views; *-terse brings less details*  

> show views in [database|schema|account] \<database_name|schema_name>  

**Materialized views**
> cannot use limit  
> cannot use more than one tables  

**Recursive View**
> base element **UNION ALL** join with the view  
> Column list is must for recursive views


## Information Schema


## Resource Monitors
> Available in ACCOUNTADMIN role  
> only one RM at account level  
> can have one per warehouse, auto reassigned if new created  
> can provide privilege to other roles to specific RMs  
> **show resource monitors;**  



show locks;  
show transactions [in account];  




## UNLOADING
> COPY INTO {internalStage | externalStage | externalLocation }  
FROM { [namespace.]TABLE_NAME | query }  
[ PARTITION BY \<expr> ]  
[ FILE_FORMAT .......... ]  
[ copyOptions ]  
[VALIDATION_MODE = RETURN_ROWS ]  
[HEADER = TRUE | FALSE ]  

>copyOptions  
Overwrite  
Output a single file  
Specify max file size  
Include query_id in filename  
print detailed ouput  

> NULL_IF = ('null')  
COMPRESSION = GZIP  
OVERWRITE = TRUE  
INCLUDE_QUERY_ID = TRUE  
DETAILED_OUTPUT = TRUE  
PARTITION BY ('date=' || transaction_date)  
*with parquet* HEADER=TRUE *will get column names from table otherwise generic col names are used by default*  



## APPROXIMATE QUERY PROCESSING
> MINHASHsno

## PARSE_JSON
> This function converts JSON-formatted data to a **VARIANT** value.  
INSERT INTO my_table (my_variant_col) SELECT parse_json('{..}');

## Storing Semi-Structured Data
> Semi-Structured data is typically stored in the following SF data types.  
> - **ARRAY**  
> - **OBJECT** - similar to JSON object, also called dictionary, hash or map
> - **VARIANT** - a data type that can hold value of any other data type (incl ARRAY and OBJECT)  

> Querying Semi Structured Data
>> Accessing Elements of Array by Index or by Slice  
>> - select my_array_col[2] from my_table; //Index start from Zero(0)
>> - select **array_slice**(my_array_col, 5, 10) from my_table; //starting element 5 up to **NOT INCLUDING** 10

>> Accessing Elements Of an Object by Key
>> - select my_variant_col['key1'] from my_table;  
>> OR  select my_variant_col:key1 from my_table  

>> Trasversing Semi Structured Data  
Insert a colon(:) between the variant col name and any first level element.
The variant values of types VARCHARs, DATEs, TIMEs, TIMESTAMPs in results are double quoted. Operators : and subsequent . and [], always return VARIANT values containing strings.  
Column names are case insensitive but **element** names are case sensitive.  

>> Using FLATTEN funtion to parse ARRAYs  
FLATTEN is a table function that produces a lateral view of a VARIANT, OBJECT or ARRAY column. The function return a row for each object and the FLATTEN modifier joins data with any information outside of the object.



## Supported functions during COPY
- ARRAY_CONSTRUCT ( [ <expr1\>] [, <expr2\> [, ...] ] ) returns a constructed array. Can have diff data types.

- OBJECT_CONSTRUCT returns an object  
    OBJECT_CONSTRUCT( [<key1\>, <value1\> [, <key2\>, <value2\> ...]] )  *keys are strings, values any type*  
    OBJECT_CONSTRUCT (*) *the object is contructed using attribute names as keys and assocaiated tuple values as values*  
  
    if the key or value is NULL (ie SQL NULL), it is omitted. A kv pair with not-null string key and a JSON NULL as value (ie parse_json('NULL') is not omitted.  
    order is not guaranteed.  

    OBJECT_CONSTRUCT supports expressions and queries to add, modify or omit values from JSON object.  
    ```sql
    SELECT OBJECT_CONSTRUCT(
    'foo', 1234567,
    'dataset_size', (SELECT COUNT(*) FROM demo_table_1),
    'distinct_province', (SELECT COUNT(DISTINCT province) FROM demo_table_1),
    'created_date_seconds', extract(epoch_seconds, created_date)
    )
    FROM demo_table_1;
    +-------------------------------------------------------------------------------+
    | OBJECT_CONSTRUCT(                                                             |
    |     'FOO', 1234567,                                                           |
    |     'DATASET_SIZE', (SELECT COUNT(*) FROM DEMO_TABLE_1),                      |
    |     'DISTINCT_PROVINCE', (SELECT COUNT(DISTINCT PROVINCE) FROM DEMO_TABLE_1), |
    |     'CREATED_DATE_SECONDS', EXTRACT(EPOCH_SECONDS, CREATED_DATE)              |
    |     )                                                                         |
    |-------------------------------------------------------------------------------|
    | {                                                                             |
    |   "created_date_seconds": 1579305600,                                         |
    |   "dataset_size": 2,                                                          |
    |   "distinct_province": 2,                                                     |
    |   "foo": 1234567                                                              |
    | }                                                                             |
    | {                                                                             |
    |   "created_date_seconds": 1579392000,                                         |
    |   "dataset_size": 2,                                                          |
    |   "distinct_province": 2,                                                     |
    |   "foo": 1234567                                                              |
    | }                                                                             |
    +-------------------------------------------------------------------------------+
    ```



## Data Governance
- CREATE MASKING POLICY  
```sql
CREATE [ OR REPLACE ] MASKING POLICY [ IF NOT EXISTS ] <name> AS
( <arg_name_to_mask> <arg_type_to_mask> [ , <arg_1> <arg_type_1> ... ] )
RETURNS <arg_type_to_mask> -> <expression_on_arg_name>
[ COMMENT = '<string_literal>' ]
[ EXEMPT_OTHER_POLICIES = { TRUE | FALSE } ]
```

## TAG
A tag is a schema level object that can be assigned to another snowflake object.  
Tag must be unique for a schema and value is always a string.  
- 50 tags limit on Table/View object  
- 50 extra on all columns combined in Table/View  
24 hour to UNDROP 

select SYSTEM$GET_TAG_ALLOWED_VALUES(DATABASE.SCHEMA.TAG);

```sql
CREATE TAG <tag_name/> allowed_values <value1\>, <value2\> ... ;

ALTER TAG <tag_name/> add allowed_values <new_value/>;

ALTER TAG <tag_name/> drop allowed_values <old_value/>;
```

SNOWFLAKE.ACCOUNT_USAGE.TAGS has all tags
SYSTEM$GET_TAG(<TAG>, <TABLE>, <COLUMN>)


## Classification
1. EXTRACT_SEMANTIC_CATEGORIES
2. REVIEW
3. ASSOCIATE_SEMANTIC_CATEGORY_TAGS


## Masking Policies
Schema level objects
```sql
create masking policy employee_ssn_mask as (val string) returns string ->
  case
     when current_role() in ('PAYROLL') THEN val
     ELSE '******'
  end;

create masking policy employee_ssn_detokenize as (val string) return string ->
  case
    when current_role('PAYROLL') then ssn_unprotect(val)
    else val -- sees tokenized data
  end;
```








## Pending Study
> INFER_SCHEMA  
> ARRAY_AGG  
## Resource Monitor (account level object)
> You can create multiple resource monitors to action and notify based on limits defined for usage.  
UNstructured data support
 Scoped URl
 File URL
 Pre-Signed URL


 CREATE TASK
 SHARING in SF editions
 Continuous Data Protection temp table
 SOS
 
 Editions and Features:
 https://docs.snowflake.com/en/user-guide/intro-editions

 consume a stream
 dynamic data masking
 query caching and changes

Create a view aag(ssn), grant access to view, mask ssn in table, get a distinct count

Table functions
validation mode
privatelink minimum edition
cardinality and clustering
warehouse required for?  alter table/materialized view/listing atage/get from stage/exec stored procedure
actions on resource monitors
current_odbc_client() curent_jdbc_version() current_client() current_version()
is alter view possible?


