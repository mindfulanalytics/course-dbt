with users as (

    select * from {{ ref('stg_postgres__users') }}

),

int_user_orders as (

    select * from {{ ref('int_user_orders') }}

)

select 
    u.user_id,
    address_id,
    first_name,
    last_name,
    email,
    phone_number,
    total_spend,
    total_orders,
    created_at,
    updated_at,
    first_order_created_at,
    last_order_created_at
from users u 
left join int_user_orders iuo 
    on u.user_id = iuo.user_id