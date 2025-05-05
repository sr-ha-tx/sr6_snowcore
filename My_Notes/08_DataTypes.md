# Snowflake Data Types

## Binary Input Output
Snowflake supports three binary formats or encoding schemes: hex, base64 and UTF-8

Hex is default binary format.  

**base64**  
- because base64-encoded data is pure ascii text. Binary date that represents music/utf data can be encoded and stored as ascii text
- base64-encoded data does not contain control characters so less risky that characters can be interpreted as commands.

requires compute and uses about 1/3 more storage.

Session 
File Format Option for Loading/Unloading Binary Values  
- BINARY_FORMAT



## DATE & TIME
Input Formats
- DATE_INPUT_FORMAT
- TIME_INPUT_FORMAT
- TIMESTAMP_INPUT_FORMAT

Output Formats
- DATE_OUTPUT_FORMAT
- TIME_OUTPUT_FORMAT
- TIMESTAMP_OUTPUT_FORMAT
- TIMESTAMP_LTZ_OUTPUT_FORMAT
- TIMESTAMP_NTZ_OUTPUT_FORMAT
- TIMESTAMP_TZ_OUTPUT_FORMAT

TIMESTAMP_TYPE_MAPPING

## Time Zone
- TIMEZONE parameter


## SEMI-STRUCTURED DATA

**JSON**  


**AVRO**  
utilizes schema dfefined by JSON to produce serialized data in a compact binary format.  
Snowflake reads AVRO data into a single VARIANT column. You can query just as JSON  
Example of AVRO schema
```sql
{
    'type': 'record',
    'name': 'person',
    'namespace': 'example.avro',
    'fields': [
        {'name': 'fullname', 'type': 'string'},
        {'name': 'age', 'type': ['int', 'null']},
        {'name': 'gender', 'type': ['string', 'null']}
    ]
}
```

**ORC** Optimized Row Columnar  
is a binary format to store hive data.  
Snowflake reads ORC data into a single VARIANT column.  

**PARQUET**
compressed, efficient columnar data representation designed for projects in hadoop ecosystem.  
is a binary format so not possible to give a readable example.  

## Querying Semi-Structured data
Extracting values by Path using **GET_PATH** function  
```sql
SELECT GET_PATH(src, 'vehicle[0]:make') FROM car_sales;

+----------------------------------+
| GET_PATH(SRC, 'VEHICLE[0]:MAKE') |
|----------------------------------|
| "Honda"                          |
| "Toyota"                         |
+----------------------------------+
```

Parsing Directly from staged files  
Staged File  
```sql
{
    "root": [
        {
            "employees": [
                {
                    "firstName": "Anna",
                    "lastName": "Smith"
                },
                {
                    "firstName": "Peter",
                    "lastName": "Jones"
                }
            ]
        }
    ]
}
```

Query directly  
```sql
SELECT 'The First Employee Record is '||
    S.$1:root[0].employees[0].firstName||
    ' '||S.$1:root[0].employees[0].lastName
FROM @%customers/contacts.json.gz (file_format => 'my_json_format') as S;

+----------------------------------------------+
| 'THE FIRST EMPLOYEE RECORD IS '||            |
|      S.$1:ROOT[0].EMPLOYEES[0].FIRSTNAME||   |
|      ' '||S.$1:ROOT[0].EMPLOYEES[0].LASTNAME |
|----------------------------------------------|
| The First Employee Record is Anna Smith      |
+----------------------------------------------+
```

The variant data type imposes a 16MB size limit on individual rows.  

**NULL values**
Snowflake supports 2 types of NULL values in semi-structured data:  
- SQL NULL - it means the same thing for semi-structured as it means for structured data types- the value is missing or unknown.  
- JSON null - In a variant column, JSON null values are stored as a string containing the word "null" to distinguish from SQL NULL values.

```sql
select 
    parse_json(NULL) AS "SQL NULL", 
    parse_json('null') AS "JSON NULL", 
    parse_json('[ null ]') AS "JSON NULL",
    parse_json('{ "a": null }'):a AS "JSON NULL",
    parse_json('{ "a": null }'):b AS "ABSENT VALUE";
+----------+-----------+-----------+-----------+--------------+
| SQL NULL | JSON NULL | JSON NULL | JSON NULL | ABSENT VALUE |
|----------+-----------+-----------+-----------+--------------|
| NULL     | null      | [         | null      | NULL         |
|          |           |   null    |           |              |
|          |           | ]         |           |              |
+----------+-----------+-----------+-----------+--------------+
```

To convert a VARIANT null to SQL NULL
```sql
select 
    parse_json('{ "a": null }'):a,
    to_char(parse_json('{ "a": null }'):a);
+-------------------------------+----------------------------------------+
| PARSE_JSON('{ "A": NULL }'):A | TO_CHAR(PARSE_JSON('{ "A": NULL }'):A) |
|-------------------------------+----------------------------------------|
| null                          | NULL                                   |
+-------------------------------+----------------------------------------+
```

**Semi-structured Data Files and Columnarization**
SF extracts as much info into columnar form. Rest is stored as a single column in a parsed semi-structured structure.  
Elements below are not extracted into a column:  
- elements that contain even a single "null" (not the ones with missing values)
- elements that contain multiple data types.

