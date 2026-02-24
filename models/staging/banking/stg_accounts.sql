{{
    config(
        materialized='view'
    )
}}

select 
    upper(account_number) as account_number ,
    customer_id,
    {{clean_string('account_type')}} as account_type ,
    to_date(open_date , 'dd-mm-yyyy') as open_date ,
    balance,
    current_timestamp as created_at
from {{ref('bank_accounts')}}
