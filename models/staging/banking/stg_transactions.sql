{{
    config(
        materialized='view'
    )
}}

WITH cte as (select  
upper(txn_id) as txn_id,
account_number,
cast(txn_date as date) as txn_date,
round(amount,2) as amount ,
{{clean_string('txn_type')}} as txn_type,
{{clean_string('txn_status')}} as txn_status
from {{ref('bank_transactions')}})

select * from cte