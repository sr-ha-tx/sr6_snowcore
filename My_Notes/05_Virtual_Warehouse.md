## Query Processing and Concurrency
The number of queries concurrent is determined by the size and complexity of each query.  
As queries are submitted the warehose calculates and reserves resources. If the warehouse  
does not have enough remining, the query is queued.
- STATEMENT_QUEUED_TIMEOUT_IN_SECONDS
- STATEMENT_TIMEOUT_IN_SECONDS

## Precedence for Warehouse Defaults
When a user connects to Snowflake and start a session, Snowflake determines the default warehouse for the session in the following order:

Default warehouse for the user,

» overridden by…

Default warehouse in the configuration file for the client utility (SnowSQL, JDBC driver, etc.) used to connect to Snowflake (if the client supports configuration files),

» overridden by…

Default warehouse specified on the client command line or through the driver/connector parameters passed to Snowflake.

Note

In addition, the default warehouse for a session can be changed at any time by executing the USE WAREHOUSE command within the session.

## Scaling Policy
|Policy  | Description | WH STarts | WH Shuts Down |
|---      | ---        |   ---     | ---           |
|Standard|Minimizes Queueing|Immediately when a query queues or systems detects one more executable query|After 2-3 checks 1min interval|
|Economy|Minimizes Costs|Waits for a 6min busy load|After 5-6 consecutive 1 min interval checks|


## Default Concurrency Level

default MAX_CONCURRENCY_LEVEL is 8.  
Can be edited by
```
ALTER WAREHOUSE my_wh SET MAX_CONCURRENCY_LEVEL = 4;
```