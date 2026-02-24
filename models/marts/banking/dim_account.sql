{{
    config(
        materialized='incremental',
        unique_key='account_number',
    )
}}

{% if is_incremental() %}

with new_recs as (
    select 
        md5(account_number) as account_sk,
        account_number,
        customer_id,
        account_type,
        open_date,
        balance,
        created_at,
        null as updated_at
    from 
        {{ref('stg_accounts')}} 
    where
        account_number not in (select account_number from {{this}})
)

,update_recs as (
    select 
        md5(src.account_number) as account_sk,
        src.account_number,
        src.customer_id,
        src.account_type,
        src.open_date,
        src.balance,
        src.created_at,
        current_timestamp() as updated_at 
    from 
        {{ref('stg_accounts')}} src left join {{this}} tgt
    on
        src.account_number = tgt.account_number
    where
        src.account_type <> tgt.account_type 
)

select * from update_recs
union
select * from new_recs


{% else %}

select
    md5(account_number) as account_sk,
    *,
    null as updated_at
from 
    {{ref('stg_accounts')}}

{% endif %}