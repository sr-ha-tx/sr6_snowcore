## Continuous Data Loading
- Snowpipe
- Snowpipe Streaming
- Snowflake Connector for Kafka
- Third Party data integration tools

## Continuous Data Transformation
Dynamic tables are declarative automated data pipelijnes that simplify.  

## Change Data Tracking
Streams  

## Tasks
recurring schedule for a SQL




# DYNAMIC TABLES
is a table that materializes the results of a query that you specify.  
because the content of dyn table is fully determined by given query, it cannot be changed by using DML. The automated refresh process materializes the query results into a dynamic table.  

**REPLICATING** a DB with dynamic table is not possible. It will **FAIL**  

> Simple Example
```sql
CREATE OR REPLACE TABLE raw
(var VARIANT);

CREATE OR REPLACE DYNAMIC TABLE names
TARGET_LAG = '1 minute'
WAREHOUSE = mywh
AS
SELECT var:id::int id,
var:fname::string fname,
var:lname::string lname from raw;
```

![](Images\dynamic_tables.png)

Dynamic Table Privileges
|Privilege|Usage|
|---|---|
|SELECT| enables executing SELECT on dynamic table|
|MONITOR| enables viewing details of Dyn Tab. DESCRIBE DYNAMIC TABLES and SHOW DYNAMIC TABLES|
|OPERATE| enables viewing details DESCRIBE and altering WAREHOUSE and TARGET_LAG|
|OWNERSHIP| full control over dyn tab. Only a single role at a time |
|ALL [PRIVILEGS]| grants all privileges|

Costs:  
- Storage - flat rate per TB
- Cloud Services Compute - use cloud services to trigger refreshes when an underlying base object has changed. This cost is subject to constraint that SF only bills if the daily Cloud Services cost is > 10% of daily warehouse cost for the account.  
- Virtual Warehouse Compute - they require virtual warehouses which are billed per second.


## Streams and Dynamic Tables
- REFRESH - they can be incremental or full refresh.
- Stream type - only support standard streams.  

