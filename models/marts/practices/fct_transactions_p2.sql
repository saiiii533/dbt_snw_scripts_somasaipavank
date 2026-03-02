{{ config(
    materialized='incremental',
    unique_key='TXN_ID',
    incremental_strategy='merge'
) }}

with 

source as (

    select * from {{ source('raw', 'raw_transactions_p2') }}

),

renamed as (

    select
        txn_id,
        customer_id,
        amount,
        txn_status,
        created_at,
        updated_at

    from source

)

select * from renamed