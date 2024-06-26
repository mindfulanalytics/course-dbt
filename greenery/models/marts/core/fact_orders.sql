with orders as (

    select * from {{ ref('stg_postgres__orders') }}

),

addresses as (

    select * from {{ ref('stg_postgres__addresses') }}

),

products_in_orders as (

    select 
        order_id,
        count(product_id) as products_in_order
    from {{ ref('stg_postgres__order_items') }}
    group by 1

),

promos as (

    select * from {{ ref('stg_postgres__promos') }}
)

select
    o.order_id,
    o.user_id,
    o.promo_id,
    o.address_id,
    o.tracking_id,
    o.order_status,
    a.country,
    a.state,
    o.shipping_service,
    o.order_cost,
    p.discount,
    o.shipping_cost,
    o.order_total,
    pio.products_in_order,
    o.created_at,
    o.estimated_delivery_at,
    o.delivered_at
from orders o 
left join addresses a
    on o.address_id = a.address_id 
left join products_in_orders pio
    on o.order_id = pio.order_id 
left join promos p 
    on o.promo_id = p.promo_id