{{
    config(
        materialized='view'
    )
}}

{% set valid_types = var('accepted_txn_types') %}
{% set include_pending = var('include_pending', false) | as_bool %}

select * 
from {{ ref('bank_transactions') }}
where txn_type in (
    {%- for txn_type in valid_types -%}
        '{{ txn_type }}'{% if not loop.last %}, {% endif %}
    {%- endfor -%}
)
{% if not var('include_pending', false) %}
    and txn_status != 'pending'
{% endif %}