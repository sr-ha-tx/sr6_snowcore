-- create a virtual warehouse
use role sysadmin;
create or replace warehouse snowpark_etl_wh 
    with 
    warehouse_size = 'x-small' 
    warehouse_type = 'standard' 
    auto_suspend = 60 
    auto_resume = true 
    min_cluster_count = 1
    max_cluster_count = 1 
    scaling_policy = 'standard';

-- create a role for snowpark
use role useradmin;
CREATE OR REPLACE ROLE snowpark_role;


grant role snowpark_role to role sysadmin;
use role sysadmin;
GRANT USAGE ON WAREHOUSE snowpark_etl_wh to role snowpark_role;

-- create a snowpark user (it can only be created using accountadmin role)
create or replace user snowpark_user 
  password = 'ZZ!2023yy' 
  comment = 'this is a s snowpark user' 
  default_role = snowpark_role
  default_secondary_roles = ('ALL')
  must_change_password = false;
use role securityadmin;
grant role snowpark_role to user snowpark_user;

use role accountadmin;
show users;
show databases;
show warehouses;
show users;
show roles;
