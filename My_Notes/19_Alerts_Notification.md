# Alerts and Notifications
- Snowflake Alert
is a schema level object that specifies
1. a condition that triggetrs the alert
2. action to perform
3. when and how condition needs to be evaluated.



## Email Notifixations

SYSTEM$**SEND_EMAIL()**

uses the notification integration object

a single account can define a max of 10 email integrations and enable one or more simultaneoulsy.

Notifications can only be sent to Snowflake users within same account and they must verify their email address through 
1. Snowsight
2. Classic COnsole

```sql
CREATE NOTIFICATION INTEGRATION my_email_int
    TYPE=EMAIL
    ENABLED=TRUE
    ALLOWED_RECIPIENTS=('first.last@example.com','first2.last2@example.com');
```
```sql
CALL SYSTEM$SEND_EMAIL(
    'my_email_int',
    'person1@example.com, person2@example.com',
    'Email Alert: Task A has finished.',
    'Task A has successfully finished.\nStart Time: 10:10:32\nEnd Time: 12:15:45\nTotal Records Processed: 115678'
);
```
