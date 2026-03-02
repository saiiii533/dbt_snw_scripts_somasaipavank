{{
    config(
        materialized='incremental',
        unique_key='txn_id',
        incremental_strategy='merge'
    )
}}

with src as (

    select
        txn_id,
        account_number,
        txn_type,
        txn_status
    from {{ ref('stg_transactions') }}

),

dim_join as (

    select
        md5(src.txn_id) as txn_sk,
        src.txn_id,
        dim.account_sk,
        src.txn_type,
        src.txn_status
    from src
    left join {{ ref('dim_account') }} dim
        on src.account_number = dim.account_number
)

select
    s.txn_sk,
    s.txn_id,
    s.account_sk,
    s.txn_type,
    s.txn_status,

    {% if is_incremental() %}
        coalesce(t.created_at, current_timestamp()) as created_at,
    {% else %}
        current_timestamp() as created_at,
    {% endif %}

    current_timestamp() as updated_at

from dim_join s

{% if is_incremental() %}
left join {{ this }} t
    on s.txn_id = t.txn_id
{% endif %}