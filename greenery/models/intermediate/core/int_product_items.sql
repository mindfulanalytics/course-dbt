with order_items as (

    select 
        order_id,
        product_id,
        quantity
    from {{ ref('stg_postgres__order_items') }}

),

products as (

    select 
        product_id,
        product_name,
        product_price,
        product_inventory
    from {{ ref('stg_postgres__products') }}

)

select 
    oi.product_id,
    count(distinct order_id) as total_product_orders_sold,
    sum(quantity) as total_product_items_sold,
    round(sum(quantity * product_price),2) as total_product_revenue
from order_items oi 
left join products p
    on oi.product_id = p.product_id
group by 1