# Snowpipe 
enables loading data from files as soon sa they become availablke in a stage.  
Mechanisms for new file detections  
1. Cloud Messaging
2. REST endpoints

||Snowpipe|Bulk Loading|
|---|---|---|
|Authentication|With REST - signed JWT tokens|Session Authentication|
|Load History| Stored in PIPE metadata for 14 days| Stored in metadata of table for 64 days|
|Transactions| Combined/Split into TXN based on number and size of rows.| Single transaction|
|Compute| SF supplied resources| User specified warehouse|
|Cost| Billed as per compute used in Snowpipe| Billed for time WH is active|

No guarantee on order but usually older files in queue are pulled in first.  

Snowpipe uses file loading metadata associated with each pipe object to prevent reloading same files. This metadata stores PATH and NAME of each loaded file.

```sql
create pipe </> auto_ingest=true as 
copy into </>
from @<stage/>
file_format = (type='JSON');
[ INTEGRATION = <STORAGE INTEGRATION> ]
[ ERROR_INTEGRATION = <Notification Integration> ]
```
The auto_ingest=true parameter specifies to read event notifications sent from S# bucket to an SQS queue when new data is ready to load.  

SYSTEM$PIPE_STATUS
```sql
{“executionState”:”<value>”,”oldestFileTimestamp”:<value>,”pendingFileCount”:<value>,”notificationChannelName”:”<value>”,”numOutstandingMessagesOnChannel”:<value>,”lastReceivedMessageTimestamp”:”<value>”,”lastForwardedMessageTimestamp”:”<value>”,”error”:<value>,”fault”:<value>}
```