A stream places an offset in the version timeline.  
When queried it spits out all changes that happened on the version line after the offset to the most current version.  

**Multiple** queries can independently consume the same change data from a stream without changing the OFFSET. A stream only advances the offset when it is used in a DML transaction.  
Querying a stream alone does not advance offset, even with an explicit transaction, the stream contents must be consumed in a DML statement.  

METADATA **$ACTION**  
METADATA **$ISUPDATE**  
METADATA **$ROW_ID**  

### Types of Streams
- Standard
- Append-only
- Insert-only (Suportted for streams on external tables only)

## Data Retention Period and Staleness
A stream becomes stale when its offset is outside the data retention period for its source table.  
(Snowflake temporarily extends data retention period to 14 days)  
