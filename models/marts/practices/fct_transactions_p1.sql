{{ config(
    materialized='incremental',
    incremental_strategy='append'
) }}

SELECT *
FROM {{ source('raw', 'raw_transactions_p1') }}

{% if is_incremental() %}
WHERE CREATED_AT > (SELECT MAX(CREATED_AT) FROM {{ this }})
{% endif %}