# Sharing

Options for Sharing  
Listings let you share data with people in any Snowflake region, across clouds, without performing manual replication tasks. If you use listings you can provide additional metadata for the data that you share, view customer data usage and gauge interest.  
If you don't want to use listing, you can use direct share.  

|Data Sharing Mechanism| Share with Whom? | AutoFulfil across clouds | Chargeable? | Public Access | Get Usage Metrics|
|---|---|---|---|---|---|
|Listing| 1-N Accounts in any region| Y | Y | Y | Y |
|Direct Share| 1 Acct in Region | N | N | N | N |

If you want to manage a group of accounts, and control who can publish and consume listings in that group, consider using a Data Exchange.  

Secure Data Sharing
- Tables
- External Tables
- Secure Views
- Secure Materialized Views
- Secure UDFs
SF enables sharing of databases through "shares" that are created by providers and imported by consumers.  

## Share
Shares are named snowflake objects that encapsulate all of the information required to share a database.  
Data providers add SF objects to a share using either or both 
1. Grant privileges on objects to a share via a database role.
2. Grant privileges on objects directly to a share.


