
{{config(
    database='GOLDEN_LAYER',
    schema='ANALYTICS'
)}}

with customers as (
    SELECT * FROM {{ ref('stg_customers') }}
),

orders as (
    SELECT * FROM {{ ref('stg_orders') }}  
),

payments as (
    SELECT * FROM {{ ref('stg_payments') }}
),

customer_level_details as (
    SELECT 
        c.CUSTOMER_ID,
        MIN(o.ORDER_DATE) as first_order,
        MAX(o.ORDER_DATE) as most_recent_order
    FROM customers c
    LEFT JOIN orders o
      ON c.CUSTOMER_ID = o.CUSTOMER_ID
    GROUP BY c.CUSTOMER_ID
),

payment_details as (
    SELECT 
        o.CUSTOMER_ID,
        SUM(p.SALES_AMOUNT) as AMOUNT
    FROM payments p
    LEFT JOIN orders o
      ON p.ORDER_ID = o.ORDER_ID
    GROUP BY o.CUSTOMER_ID
),

final as (
    SELECT pd.* FROM customer_level_details cl 
    LEFT JOIN payment_details pd
      ON cl.CUSTOMER_ID = pd.CUSTOMER_ID
)

SELECT * FROM final

