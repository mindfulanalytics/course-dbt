with order_items as (

    select 
        order_id,
        product_id,
        quantity
    from {{ ref('stg_postgres__order_items') }}

),

orders as (

    select * from {{ ref('stg_postgres__orders') }}

)

select 
    oi.product_id,
    min(created_at) as first_product_order_created_at,
    max(created_at) as last_product_order_created_at
from order_items oi 
left join orders o 
    on oi.order_id = o.order_id
group by 1