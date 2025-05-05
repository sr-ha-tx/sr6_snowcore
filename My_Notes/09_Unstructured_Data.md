# Unstructured Data
Snowflake supports
1. securely access data file in cloud storage
2. share file URLs with collaborators and partners
3. Load file access URLs and other file metadata into Snowflake tables
4. Process Unstructured data.

## Types of URLs available to acces files
- Scoped URL - encoded URL that permits temp access to staged file without granting privileges to the stage. The URL expires when the persisted query result period ends (currently 24 hours) **BUILD_SCOPED_FILE_URL**

- File URL - URL that identifies the DB schema stage and file path to a set of files. A role that has sufficient privileges on the stage can access teh files. **BUILD_STAGE_FILE_URL**

- Pre-signed URL - Simple HTTPS URL used to access a file via a web browser. File is temp accessible using a pre-signed access token. The expiration time for the token is configurable. **GET_PRESIGNED_URL**

## Directory Tables
store a catalog of staged files in cloud storage. Roles with sufficient privileges can query a directory table to retrieve file URLs to access the staged files.
Implicit object layered on top of stages. Can be added during CREATE STAGE or ALTER STAGE
```sql
CREATE STAGE mystage
  URL = 's3://..../..'
  DIRECTORY = (ENABLE = TRUE, AUTO_REFRESH = FALSE)
  FILE_FORMAT = myformat;

ALTER STAGE mystage REFERSH SUBPATH = "relpath";

select * from DIRECTORY(@<mystage>);
```





**SQL Functions**
- GET_STAGE_LOCATION - returns the URL for internal/external named stage using the stage name as input.
- GET_RELATIVE_PATH - extracts teh path of a staged file releative to its location in the stage using the stage name and absolute file path in cloud storage as inputs.
- GET_ABSOLUTE_PATH - returns absolute path of a staged file using the stage name and path of file releative to its location in the stage as inputs.
- GET_PRESIGNED_URL - generates pre-signed URL to a staged file using the stage name and relative file path as inputs. Access files in an external stage using this function.
- BUILD_SCOPED_FILE_URL - generates a scoped SF hosted URL to a staged file using the stage name and relative file path as inputs.
- BUILD_STAGE_FILE_URL - generates a SF hosted URL to a staged file using stage name and relative path as inputs.


# Processing Unstructured Data
**EXTERNAL functions**
are user defined functions that you store and execute outside of Snowflake. With external functions, you can use libraries such as Amazon Textract, Document AI or Azure Computer Vision that cannot be accessed from internal user defined functions.

**UDF and SP**
Java or Pythin code to read a file so you can process unstructured data or use your own ML models in UDF/UDTF or SP.





## REST API for UNSTRUCTURED Data
GET /api/files/  
retrieves a data file from an internal or external stage.

Authentication  
using OAuth for custom clients.  
Create a SECURITY INTEGRATION to enable an HTTP client that suports OAuth to redirect users to an authorization page and generate access tokens for access to teh REST API endpoint.  

Usage Notes  
- send the scoped URL or file URL for a staged file in teh GET request.
>> generate a scoped URL  
>> generate a file URL  
- authenticate to Snowflake via Snowflake SQL API using OAuth or key pair authentication.  
- the authorization to access files differs depending on whether a scoped URL or file URL is sent in GET request.  
 Scoped URL - only user who generated URL can use the URL  
 File URL - any role with sufficient privileges can access (External Stage - USAGE / Internal Stage - READ)  
 An HTTP client that sends a URL to REST API must be configured to accept redirects.  
 If the downloaded files appear corrupted , check if ENCRYPTION (type='SNOWFLAKE_SSE')