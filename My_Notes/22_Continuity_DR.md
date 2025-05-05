# Continuity and DIsaster Recovery

- Database and share replication are available to all accounts.  
- Replication of other account objects, failover/fallback and client redirect require BUSINESS CRITICAL(or higher)  

## Replication and Failover/Failback
Replication uses two Snowflake objects, replication group and failover group, to replicate a group of objects with point-in-time consistency from a source account to one or more target accounts.  

Objects can include warehouses, users and roles, along with Database and shares. They can be grouped in one or more groups.  

**Client Redirect**  
provides a connection URL that can be used by SNowflake clients to connect to Snowflake. The connection URL can redirect clients to a different Snowflake accoutn as needed.  

