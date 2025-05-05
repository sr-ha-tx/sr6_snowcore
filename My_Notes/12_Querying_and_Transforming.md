## Metadata for Staged Files
Snowflake automatically generates metadata for files in internal and external stages. This metadata is stored in virtual columns that can be  
1. Queried using SELECT
2. Loaded into table along with regular columns.

- METADATA**$FILENAME** name of staged file current row belongs to.
- METADATA**$FILE_ROW_NUMBER** row number for row in file
- METADATA**$FILE_CONTENT_KEY** checksum for staged file
- METADATA**$FILE_LAST_MODIFIED** last mod time of staged file as TIMESTAMP_NTZ
- METADATA**$START_SCAN_TIME** Start Timestamp of operation for each record in the staged file. TIMESTAMP_LTZ

## Transforming Data During Load
COPY command supports  
- Col reordering, omission, casts using a SELECT statement
- The ENFORCE_LENGTH | TRUNCATECOLUMNS option, which can truncate text strings that exceed col length

## TABLE SCHEMA EVOLUTION
Snowflake supports  
- auto adding new columns
- auto dropping the NOT NULL constraint from columns that are missing values in new data files.  

**ENABLE_SCHEMA_EVOLUTION** parameter to TRUE in CREATE TABLE / ALTER TABLE  

Loading data from files evolves the table columns when all of following are true  
- COPY INTO includes **MATCH_BY_COLUMN_NAME** option
- The role used to load the data has the EVOLVE SCHEMA or OWNERSHIP privilege on table.  

By default, this feature is limited to adding a max 10 columns or evolving no more than 1 schema per COPY operation.  
No limit on dropping NOT NULL constraints.  

```sql
-- Create table t1 in schema d1.s1, with the column definitions derived from the staged file1.parquet file.
USE SCHEMA d1.s1;

CREATE OR REPLACE TABLE t1
  USING TEMPLATE (
    SELECT ARRAY_AGG(object_construct(*))
      FROM TABLE(
        INFER_SCHEMA(
          LOCATION=>'@mystage/file1.parquet',
          FILE_FORMAT=>'my_parquet_format'
        )
      ));

-- Row data in file1.parquet.
+------+------+------+
| COL1 | COL2 | COL3 |
|------+------+------|
| a    | b    | c    |
+------+------+------+

-- Describe the table.
-- Note that column c2 is required in the Parquet file metadata. Therefore, the NOT NULL constraint is set for the column.
DESCRIBE TABLE t1;
+------+-------------------+--------+-------+---------+-------------+------------+-------+------------+---------+-------------+
| name | type              | kind   | null? | default | primary key | unique key | check | expression | comment | policy name |
|------+-------------------+--------+-------+---------+-------------+------------+-------+------------+---------+-------------|
| COL1 | VARCHAR(16777216) | COLUMN | Y     | NULL    | N           | N          | NULL  | NULL       | NULL    | NULL        |
| COL2 | VARCHAR(16777216) | COLUMN | N     | NULL    | N           | N          | NULL  | NULL       | NULL    | NULL        |
| COL3 | VARCHAR(16777216) | COLUMN | Y     | NULL    | N           | N          | NULL  | NULL       | NULL    | NULL        |
+------+-------------------+--------+-------+---------+-------------+------------+-------+------------+---------+-------------+

-- Use the SECURITYADMIN role or another role that has the global MANAGE GRANTS privilege.
-- Grant the EVOLVE SCHEMA privilege to any other roles that could insert data and evolve table schema in addition to the table owner.

GRANT EVOLVE SCHEMA ON TABLE d1.s1.t1 TO ROLE r1;

-- Enable schema evolution on the table.
-- Note that the ENABLE_SCHEMA_EVOLUTION property can also be set at table creation with CREATE OR REPLACE TABLE
ALTER TABLE t1 SET ENABLE_SCHEMA_EVOLUTION = TRUE;

-- Load a new set of data into the table.
-- The new data drops the NOT NULL constraint on the col2 column.
-- The new data adds the new column col4.
COPY INTO t1
  FROM @mystage/file2.parquet
  FILE_FORMAT = (type=parquet)
  MATCH_BY_COLUMN_NAME = CASE_INSENSITIVE;

-- Row data in file2.parquet.
+------+------+------+
| col1 | COL3 | COL4 |
|------+------+------|
| d    | e    | f    |
+------+------+------+

-- Describe the table.
DESCRIBE TABLE t1;
+------+-------------------+--------+-------+---------+-------------+------------+-------+------------+---------+-------------+
| name | type              | kind   | null? | default | primary key | unique key | check | expression | comment | policy name |
|------+-------------------+--------+-------+---------+-------------+------------+-------+------------+---------+-------------|
| COL1 | VARCHAR(16777216) | COLUMN | Y     | NULL    | N           | N          | NULL  | NULL       | NULL    | NULL        |
| COL2 | VARCHAR(16777216) | COLUMN | Y     | NULL    | N           | N          | NULL  | NULL       | NULL    | NULL        |
| COL3 | VARCHAR(16777216) | COLUMN | Y     | NULL    | N           | N          | NULL  | NULL       | NULL    | NULL        |
| COL4 | VARCHAR(16777216) | COLUMN | Y     | NULL    | N           | N          | NULL  | NULL       | NULL    | NULL        |
+------+-------------------+--------+-------+---------+-------------+------------+-------+------------+---------+-------------+
-- Note that since MATCH_BY_COLUMN_NAME is set as CASE_INSENSITIVE, all column names are retrieved as uppercase letters.
```

