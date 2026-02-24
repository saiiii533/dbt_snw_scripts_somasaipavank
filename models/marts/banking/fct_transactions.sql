{{
    config(
        materialized='incremental',
        unique_key='txn_id',
        incremental_strategy = 'merge'

    )
}}

{% if is_incremental() %}

with new_recs as (
    select 
        md5(account_number) as account_sk,
        account_number,
        txn_id,
        txn_type,
        txn_status,
        current_date as created_at,
        null as updated_at
    from 
        {{ref('stg_transactions')}} 
    where
        account_number not in (select account_number from {{this}})
)

,update_recs as (
    select 
        md5(account_number) as account_sk,
        src.account_number,
        src.txn_id,
        src.txn_type,
        src.txn_status,
        src.created_at,
        current_timestamp() as updated_at 
    from 
        {{ref('stg_transactions')}} src left join {{this}} tgt
    on
        src.account_number = tgt.account_number
    where
        src.txn_status <> tgt.txn_status 
)

select * from update_recs
union
select * from new_recs


{% else %}

select 
        md5(src.account_number) as account_sk,
        src.account_number,
        src.txn_id,
        src.txn_type,
        src.txn_status,
        current_date as created_at,
    null as updated_at
from 
    {{ref('stg_transactions')}} src
    join {{ ref('dim_account') }} dim
    on src.account_number = dim.account_number

{% endif %}