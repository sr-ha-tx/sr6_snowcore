Uses key based authentication as there is no session.  
Create a separate user and role to use for ingesting files using a pipe.  
![](Images\spipe_rest.png)

InsertFiles EndPoint  
![](Images\insertfiles.png)

Error Notifications  
Notification Integration - SF object that provides an interface between Snowflake and a third party cloud message queuing service.  
Snowflake guarantees at-least-once message delivery of error notifications.  

```sql
CREATE NOTIFICATION INTEGRATION <integration_name>
  ENABLED = true
  TYPE = QUEUE
  NOTIFICATION_PROVIDER = AWS_SNS
  DIRECTION = OUTBOUND
  AWS_SNS_TOPIC_ARN = '<topic_arn>'
  AWS_SNS_ROLE_ARN = '<iam_role_arn>'
```

