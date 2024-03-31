with product as (

    select 
        *
    from {{ ref('stg_postgres__products') }}

),

int_product_orders as (

    select 
        *
    from {{ ref('int_product_orders') }}

),

int_product_items as (

    select 
        *
    from {{ ref('int_product_items') }}

)

select 
    p.product_id,
    product_name,
    product_price,
    product_inventory,
    total_product_orders_sold,
    total_product_items_sold,
    total_product_revenue,
    first_product_order_created_at,
    last_product_order_created_at
from product p
left join int_product_orders ipo 
    on p.product_id = ipo.product_id
left join int_product_items ipi 
    on p.product_id = ipi.product_id
