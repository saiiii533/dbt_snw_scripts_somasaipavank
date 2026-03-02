--- Write a SQL test that fails if any transaction amount is < 0 and txn_type = 'deposit'.

select * from
{{ ref('bank_transactions') }}
where amount <0  and txn_type = 'deposit'