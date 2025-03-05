{{config(
    database='STAGING',
    schema='STG'
)}}

with raw as (
    select * from {{source("Snowflake source stg","raw_payments")}}
),

final as ( 
    select ID as PAYMENT_ID,
    ORDER_ID,
    PAYMENT_METHOD AS PAYMENT_MODE,
    AMOUNT/100 AS SALES_AMOUNT
    from raw
)
select * from final