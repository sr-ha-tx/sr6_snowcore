# Micro Partitions
contiguous units of storage 50-500MB uncompressed  
Groups of rows in table are mapped to individual micro-partitions, stored in columnar fashion.  

> Clustering Information maintained for Micro-Partitions
>> total # of micro partitions  
>> the # of m partitions containing values that overlap with each other (in a subset of columns)
>> the depth of overlapping micro-partitions.

SYSTEM$CLUSTERING_DEPTH  
SYSTEM$CLUSTERING_INFORMAION  (can pass optional parameter of desired colum(s) to get values)

Considerations for Clustering Key
- A large enough number of distinct values to enable effective pruning on table  
- A small enough number of disctict values to allow SF to effectively group rows into same partitions.


Snowflake recommends ordering the clustering columns from LOWEST cardinality to HIGHEST cardinality.  

**Clustering Keys can be of any data type except GEOGRAPHY, VARIANT, OBJECT or ARRAY.**  
can conmtain expression with path (and type) from variant  
for VARCHAR columns only first 5 bytes are used  

> Automatic Clustering
>> Non blocking  
>> Can be suspended/resumed ALTER TABLE .... RESUMNE/SUSPEND RECLUSTER  
>> SF manages the compute required and account is billed for actual credits consumed by auto reclustering.  
>> if a table is created by CLONING, be default the recluster is suspended and needs to be enabled.  

## Temporary Tables
only in session  



## TABLE COMPARISON
|Type|Persistense|Cloning|TimeTravel|FailSafe|
|---|---|---|---|---|
|Temporary|Remainder of Session| to Temp/Transient|0-1 day|0|
|Transient|until Dropped| to Temp/Transient|0-1 day|0|
|Permanent|until Dropped| to Temp/Transient/Permanent|0-1/90 day|7|

## External Table
allows to query data stored in an external stage as if the data were inside a table in Snowflake.  
SCHEMA on READ  
All external tables include the following columns  
- VALUE - a variant column that represents a single row in the external file.(select * returns this col)  
- METADATA$FILENAME - pseudocolumn identifying name and path of data file.  
- METADATA$FILE_ROW_NUMBER - pseudocolumn specifing record number in staged file.  

Sizing Recommendations:  
|Format|Recommended|Notes|
|---|---|---|
|Parquet files|256-512MB||
|Parquet Row Groups|16-256MB|when Parquet files include multiple, they can be processed parallel|
|All other formats|16-256MB||

Paritions Added Automatically (when it's created and ALTER EXTERNAL TABLE <> REFRESH) 
```sql
CREATE EXTERNAL TABLE
  <table_name>
     ( <part_col_name> <col_type> AS <part_expr> )
     [ , ... ]
  [ PARTITION BY ( <part_col_name> [, <part_col_name> ... ] ) ]
  ..
```

Partitions Added Manually  
```sql
CREATE EXTERNAL TABLE
  <table_name>
     ( <part_col_name> <col_type> AS <part_expr> )
     [ , ... ]
  [ PARTITION BY ( <part_col_name> [, <part_col_name> ... ] ) ]
  PARTITION_TYPE = USER_SPECIFIED
  ..
  ```
The partition column definitions are expressions that parse the column metadata in the internal METADATA$EXTERNAL_TABLE_PARTITION column.  
The object owner adds partitions to the external table metadata manually by executing the ALTER EXTERNAL TABLE .. ADD PARTITION command:  
```sql
ALTER EXTERNAL TABLE <name> ADD PARTITION ( <part_col_name> = '<string>' [ , <part_col_name> = '<string>' ] ) LOCATION '<path>'
```

Delta Lake Support  
is a table format on your data lake that supports ACID(Atomicity, Consistency, Isolation, Durability) transactions among other features. All data in delta lake is tored in Apache Parquet format.  
Use TABLE_FORMAT = DELTA parameter  

Persisted Query Results  
For 24 hours. Following operations invalidate and purge the query result cache
- any DDL modifying external table definition  
- changes in the set of files registered in external table metadata.Both auto and manual REFRESH invalidate cache.(if auto refresh is disabled or manual refresh is not done, outdated results.)  


Apache Hive Metastore Integration  
The hive connector detects metastore events and transmits them to snowflake to keep external tables synchronized with hive metastore.  

SYSTEM$EXTERNAL_TABLE_PIPE_STATUS  

## SEARCH OPTIMIZATION SERVICE
It aims to significantly improve performance of certain types of queries on tables, including:  
- selective point lookup queries on tables.  
- substring and regular expression searches  
- queries on fields in VARIANT OBJECT or ARRAY columns.  
- Queries using geospatial functions with GEOGRAPHY values.  

Substring searches are not optimized if you omit the ON clause.  
```sql
ALTER TABLE mytable ADD SEARCH OPTIMIZATION ON SUBSTRING(mycol);
```
wroks best when patterns are at least 5 character long  

Fields in **VARIANT** columns  
SOS can improve point lookup queries performance  
must enable using the ON clause  
```sql
ALTER TABLE mytable ADD SEARCH OPTIMIZATION ON EQUALITY(myvariantcol);
ALTER TABLE t1 ADD SEARCH OPTIMIZATION ON EQUALITY(c4:user:uuid);
```

Describe SEARCH OPTIMIZATION on <table\>

SYSTEM$ESTIMATE_SEARCH_OPTIMIZATION_COSTS  



## VIEWS

Advantages:  
1. Modular Code
2. Allow granting access to subset of data  
3. Can improve performance

Limitations:  
1. cannot ALTER
2. no aoto propagationof changes to a table
3. read-only

## Secure Views
- For non secure views Internal Optimizations can inadvertently expose data.
- For a non-secure view, the view definition is visible to other users.  

Sample of inadvertent data exposure  
```sql
SELECT *
    FROM widgets_view
    WHERE 1/iff(color = 'Purple', 0, 1) = 1;
    ```
Failure of above leads to inference that atleast one purple widget exists.

Viewing the definition for secure views.
- definition is only exposed to auth users (ie. USERS who have been granted the role that owns the view)


## Materialized Views
Limitations
1. only a single table
2. Joins including self joins are not supported
3. A mat view cannot query a) mat view b) non-mat view c) UDTF
4. A mat-view cannot include UDF/Window/HAVIN/ORDER BY/LIMIT/GROUP BY not within SLEECT/nesting of subqueries
5. Many aggregate functions ar enot allowed.