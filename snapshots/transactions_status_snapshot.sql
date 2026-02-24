{% snapshot transactions_status_snapshot %}
{{
    config(
        unique_key = 'txn_id',
        strategy = 'check',
        check_cols=['txn_status']
        
    )
}}

select
txn_id,
account_number,
txn_date,
amount,
txn_type,
txn_status
from {{ref('bank_transactions')}}


{% endsnapshot %}