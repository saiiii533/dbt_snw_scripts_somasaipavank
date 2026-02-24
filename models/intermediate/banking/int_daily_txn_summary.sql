{{
    config(
        materialized='ephemeral'
    )
}}

with cte as (
select
    account_number,
    txn_date,
    sum(case when (txn_type) = 'deposit' then (amount) else 0 end )as credit_amount,
    sum(case when (txn_type) = 'withdraw' then (amount) else 0 end)as debit_amount
from {{ ref('bank_transactions') }}
group by account_number, txn_date
) 

select * from cte
