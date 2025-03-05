
{{config(
    database='STAGING',
    schema='STG'
)}}
with raw as (
    select * from {{source("Snowflake source stg","raw_customers")}}
),

final as ( 
    select ID as CUSTOMER_ID,
    FIRST_NAME,
    LAST_NAME
    from raw
)
select * from final