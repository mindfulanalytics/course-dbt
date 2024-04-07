with promos as (

    select * from {{ ref('stg_postgres__promos') }}
),

int_promo_orders as (

select 
    o.promo_id,
    count(*) as total_orders,
    sum(discount) as total_discounts
from DEV_DB.DBT_DIEGOMINDFULANALYTICSGMAILCOM.STG_POSTGRES__ORDERS o 
left join DEV_DB.DBT_DIEGOMINDFULANALYTICSGMAILCOM.STG_POSTGRES__PROMOS p 
    on o.promo_id = p.promo_id
group by 1

)

select 
    p.promo_id,
    status,
    discount,
    total_orders,
    total_discounts
from promos p 
left join int_promo_orders ipo 
    on p.promo_id = ipo.promo_id
