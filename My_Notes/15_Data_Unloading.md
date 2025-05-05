# Unloading Data

## Bulk Unloading into Single/Multiple Files
The copy into command provides a copy option (SINGLE) for unloading into a single or multiple files.  
default is SINGLE = FALSE  
The location path specified for command can contain a filename prefix that is assigned to all data files generated. If a prefix is not specified, Snowflake  
prefixes the generated filenames with **data_**  
appends a suffix that ensures each filename is unique across parallel execution threads eg. **data_stats_0_1_0**.  

MAX_FILE_SIZE copy to control max size of each created file.  (default 16777216 16MB)

PARTITION BY copy option for partitioned unloading of data to stages.  

## Output Data File Details
|Feature|Supported|Notes|
|---|---|---|
|Location Of Files|Local Files|unloaded to internal location, the can use GET|
||S3| unloaded to user-supplied S3 buckets and then downloaded by AWS utils|
|File Formats|Delimited| any valid delimiter(default ,)|
||JSON| |
||Parquet| |
|File encoding|UTF-8| output files are always encoded utf8|

## Compression of Output Data Files
|Location of files| Supported | Notes |
|---|---|---|
|Internal/External|gzip/bzip2/Brotli/Zstandard|default gzip|

## Encryption of Output Data Files
|Location of files| Supported | Notes |
|---|---|---|
|Internal | 128/256 bits | default 128 for internal. 256 can be enabled with extra config |
|External | User Supp Key | Data files unloaded to Cloud Storage can be encrypted if a key os proviced to SF |

## UNLOAD TO JSON
```sql
-- Unload the data to a file in a stage
COPY INTO @mystage
 FROM (SELECT OBJECT_CONSTRUCT('id', id, 'first_name', first_name, 'last_name', last_name, 'city', city, 'state', state) FROM mytable)
 FILE_FORMAT = (TYPE = JSON);
 ```

 ## Unloading a relational table to Parquet with multiple Columns
 ```sql
 COPY INTO @mystage/myfile.parquet FROM (SELECT id, name, start_date FROM mytable)
  FILE_FORMAT=(TYPE='parquet')
  HEADER = TRUE;
  ```
  By default, when table data is unloaded to Parquet files, fixed-point number columns are unloaded as DECIMAL columns, while floating-point number columns are unloaded as DOUBLE columns.

Floating-point Numbers Truncated  
When floating-point number columns are unloaded to CSV or JSON files, Snowflake truncates the values to approximately (15,9).