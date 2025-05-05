1. SYSTEM$PIPE_STATUS(\<pipename>)
2. View the **COPY_HISTORY** for the table
3. Validate the data files. Query the VALIDATE_PIPE_LOAD (last 14 days)
```sql
select * from VALIDATE_PIPE_LOAD(
      PIPE_NAME => '<string>'
       , START_TIME => <constant_expr>
      [, END_TIME => <constant_expr> ] )
```


## Resume a Stale PIPE
When a pipe is paused, event messages received for the pipe enter a limited retention period (14 days). If a pipe is paused for > 14 days, it is considered stale.  
To resume a stale PIPE , a qualified role must call SYSTEM$PIPE_FORCE_RESUME with STALENESS_CHECK_OVERRIDE argument.  

```sql
SELECT SYSTEM$PIPE_FORCE_RESUME('mydb.myschema.stalepipe1','staleness_check_override');
```

When the pipe was stale and the ownership was treansfered to new role  
```sql
SELECT SYSTEM$PIPE_FORCE_RESUME('mydb.myschema.stalepipe1','staleness_check_override, ownership_transfer_check_override');
```