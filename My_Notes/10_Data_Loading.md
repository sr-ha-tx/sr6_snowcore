# Data Loading in Snowflake
you cannot access data held in archival cloud storage classes that require restoration before it can be retrieved.  

Bulk vs Continuous Loading  
## Bulk loading using the COPY command
enables loading batches of data from files already available in cloud storage, or copying local data files to internal stage before loading into tables using COPY command.  

relies on user-provided virtual arehouses, which are specified in the COPY statement.  

Simple XFM during a load  
- Column reordering
- Column omission  
- Casts  
- truncating text strings that exceed target col length  

## Continuous Loading using Snowpipe
toload small volumes of data and incrementally make them available for analysis. Snowpipe loads data within minutes after files are added to stage and submitted for ingestion.

relies on compute provided by Snowflake. These serverless computes are auto resized, scaled and charged using per-second billing. Data ingestion is charged baased upon the actual workloads.  

> Simple XFM during a load  
suppports same xfm as by bulk loading COPY statement.  
> 
>Data pipelines can leverage Snowpipe to continuously load micro batches of data into staging tables for transformations and optimization using automated tasks and the CDCinfo in streams.  


> Data Pipelines for complex transformations  
> adata pipeline enables applying complex transformations to loaded data.This workflow generally leverages Snowpipe to load "raw" data into a staging table and then uses a series of table streams and tasks to transform and optimize new data for analysis.


## Loading Data from Apache Kafka
Snowflake connector for Kafka


## Detection of Column definitions in Stageed Semi-Structured Data Files

**INFER_SCHEMA**  
detects column definitions in a set of staged data filesand retrieves metadata in a format suitable for creating SF objects.  

**GENERATE_COLUMN_DESCRIPTION**  
generates a list of columns from a set of staged files using the INFER_SCHEMA function output.  

**CREATE TABLE ...USING TEMPLATE**
```sql
CREATE [ OR REPLACE ] TABLE <table_name>
  [ COPY GRANTS ]
  USING TEMPLATE <query>
  [ ... ]
  ```

## Compression of Staged Files
|Feature|Supported|Notes|
|---|---|---|
|Uncompressed Files|gzip|Auto compressed during staging unless explicitly disabled|
|Already Compressed|gzip,bzip2,deflate,raw_deflate|Auto detect the compression|
|Already Compressed|Brotlu, Zstandard|Auto-detection not yet supported|

## General File Sizing Recommendations
The # of load operations that run in prallel cannot exceed the number of data file to be loaded. To optimize the number of parallel operations for a load, we recoomend to produce data files roughly 100-250MB or larger in size **COMPRESSED**  

## Continuous Data Loads (ie. Snowpipe) and File sizing
Loading 100-250MB compressed sized files reduces the overhead charge relative to ampunt of total data loaded to the point that overhead cost is immaterial.  

If it tzkes more than a minute to accumulate MBs of data in source, consider creating a smaller file once per minute.  
Creating smaller files and staging them in cloud more often than once per minute has following disadvatages:  
1. a reduction in latency between staging and loading data cannot be guaranteed.
2. an overhead to manage files in the internal load queue is included in utilization costs charged for snowpipe.


# Loading Data

## Lists of Files
COPY INTO <table\> command includes FILES parameter to load files by specific names.
```sql
COPY INTO load1 FROM @%load1/data1/ FILES=('test1.csv', 'test2.csv', 'test3.csv')
```

## Pattern Matching
```sql
COPY INTO people_data FROM @%people_data/data1/
   PATTERN='.*person_data[^0-9{1,3}$$].csv';
```

Executing Parallel COPY statements that reference same file  
When a COPY statement is executed, Snowflake sets a load status in the table metadata for the data files referenced in the statement. This prevents parallel copy  

Loading Older Files

## LOAD METADATA
maintains detailed metadata for each table into which data is loaded, including  
- Name of each file which was loaded
- File Size
- ETag for the file
- Number of rows in file
- Timestamp of last load for file
- info about errors encountered.  
This load metadata expires 64 days. If the last_modified date for a staged data file is <= 64 days, the COPY command can determine its load status and prevent duplication.

LAST_MODIFIED is the later of a. file initial staged or b. when last modified.

If LAST_MODIFIED date is older than 64 days, the load status is still known if either of following occured less than equal to 64 days prior:
1. The file was loaded successfully
2. The initial set of data for table was loaded

However, COPY command cannot definitely determine whether a file has been loaded already if LAST_MODIFIED older than 64 days and initial load was older than 64 days. In this case, to prevent accidental reload, the command **skips** the file by default.  

**WORAROUNDS**  
To load files whose metadata has expired, set LOAD_UNCERTAIN_FILES copy option to TRUE.

alternatively, set FORCE option to load all files ignoring metadata.


**CSV Data** Trimming Leading Spaces
```sql
 "value1", "value2", "value3"
```

The command trims the leading space and removes the quotation marks enclosing each field.
```sql
COPY INTO mytable
FROM @%mytable
FILE_FORMAT = (TYPE = CSV TRIM_SPACE=true FIELD_OPTIONALLY_ENCLOSED_BY = '0x22');

SELECT * FROM mytable;

+--------+--------+--------+
| col1   | col2   | col3   |
+--------+--------+--------+
| value1 | value2 | value3 |
+--------+--------+--------+
```

## Copying data from Stage
While copying from table stage, you can omit from clause as SF will by default take from table stage.  
```sql
COPY INTO mytable FILE_FORMAT = (TYPE = CSV FIELD_DELIMITER = '|' SKIP_HEADER = 1);
```

**Validating your Data Load**  
Tovalidate data in an uploaded file, execute COPY INTO ..  in validation mode using the **VALIDATION_MODE** parameter  
**ON_ERROR** copy option indicates what action to perform if errors are encountered during loadeing.  

Snowflake retails historical data for COPY INTO commands executed witin last 14 days. the metadata can be used to monitor and manage the loading process, including deleting files after upload completes.  

- Use LIST command to view status of data files that have been staged.
- Monitor the status of each COPY INTO command in History page of classic console  
- Use **VALIDATE** function tovalidate the data files you've loaded and retrieve any errors
- Use the **LOAD_HISTORY** information schema view to retrieve the history of data loaded using COPY INTO

## Allowingthe VPC IDs
SYSTEM$GET_SNOWFLAKE_PLATFORM_INFO();



## Configuring Storage Integration
- Step 1 : Configure Secure Access to S3 Bucket  
AWS Access reuirements
GetBucketLocation  
GetObject  
GetObjectVersion  
ListBucket  

PutObject
DeleteObject

Create an IAM policy with these permissions.  

- Step 2 : Create an AWS IAM Role  
Another AWS Account  
attach created policy  

- Step 3 : Create Storage Integration
```sql
CREATE STORAGE INTEGRATION <integration name/>
TYPE = EXTERNAL_STAGE
STORAGE_PROVIDER = 'S3'
ENABLED = TRUE
STORAGE_AWS_ROLE_ARN = '<iam_role/>'
STORAGE_ALLOWED_LOCATIOND = ('s3://<bucket>/<path>/' ...)
[ STORAGE_BLOCKED_LOCATIOND = ('s3://<bucket>/<path>/' ...) ]
```

- Step 4 : Retrieve AWS IAM User for SF account
```sql
DESC INTEGRATION <integration_name/>
```
record the STORAGE_AWS_IAM_USER_ARN  
STORAGE_AWS_EXTERNAL_ID  

- Step 5 : Set Trusted Identity in AWS
```sql
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "AWS": "<snowflake_user_arn>"
      },
      "Action": "sts:AssumeRole",
      "Condition": {
        "StringEquals": {
          "sts:ExternalId": "<snowflake_external_id>"
        }
      }
    }
  ]
}
```




























