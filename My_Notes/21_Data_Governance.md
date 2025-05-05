# Object Tagging (Ent Edition +)
Tags enable data stewards to monitor sensitive data for compliance, discovery, protection and resource usage. Tag is a schema level object.  
256 characters and can have allowed values for atag.  

Snowflake allows a maximum number of 50 unique tags that can be set on a single object  
In a CREATE <object> or ALTER <object> statement, 100 is the maximum number of tags that can be specified in a single statement.  

For a table or view and its columns, the maximum number of unique tags that can be specified in a single CREATE <object> or ALTER <object> statement is 100. This total value has the following limits:

A single table or view object: 50 unique tags.

All columns combined in a single table or view: 50 unique tags.  



# Data Classification (Ent Ed+)
multi step process that associates Snowflake=defined tags to columns by analysing the cells and metadata for personal data.  
Process  
- Analyze
EXTRACT_SEMANTIC_CATEGORIES function  
- Review
Review and revise the output if needed  
- Apply
ASSOCIATE_SEMANTIC_CATEGORY_TAGS stored procedure.  

Snowflake maintained tags  
SNOWFLAKE.CORE.SEMANTIC_CATEGORY  
SNOWFLAKE.CORE.PRIVACY_CATEGORY  

GEOGRAPHY, BINARY and VARIANT data type columns are not classified.  


## Column Level Security
1. Dynamic Data Masking
2. Extrnal Tokenization

