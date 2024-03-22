# Week 1 Project

##How many users do we have?

# Week 1 Project

## How many users do we have?

130 users

```sql

select 
    count(distinct user_id) as total_unique_users
from dev_db.dbt_diegomindfulanalyticsgmailcom.stg_postgres__users

```

## On average, how many orders do we receive per hour?

7.5 avg orders per hour. But this number is off without the use of a datespine, hours without order are null instead of 0.

```sql

with cte as (

select
    date_trunc('HOUR', created_at) as created_date_hour,
    count(*) as total_orders_per_hour,
from dev_db.dbt_diegomindfulanalyticsgmailcom.stg_postgres__orders
group by 1

)

select avg(total_orders_per_hour) as avg_total_order_per_hour from cte

```

## On average, how long does an order take from being placed to being delivered?

93.4 hours, aka 3.9 days

```sql

select 
    round(avg(timediff(hour, created_at, delivered_at)), 1) as hours_from_delivered_to_placed,
    round(avg(timediff(hour, created_at, delivered_at)/24), 1) as days_from_delivered_to_placed
from dev_db.dbt_diegomindfulanalyticsgmailcom.stg_postgres__orders

```

## How many users have only made one purchase? Two purchases? Three+ purchases?

25 users have made 1 purchase, 28 users have made two puchases, and 71 users have made three+ purchases

```sql

select 
    case 
        when total_purchases = 1 then '1 purchase'
        when total_purchases = 2 then '2 purchases'
        else '3+ purchases'
    end as total_purchases_categories,
    count(user_id) as total_users
from cte 
group by 1
order by 1 asc

```


## On average, how many unique sessions do we have per hour?

16.3 unique session per hour. But this number is likely off without the use of a datespine. Currently, hours without events are null instead of 0.

```sql

with cte as (

select 
    date_trunc('HOUR', created_at) as created_date_hour,
    count(distinct session_id) as total_unique_sessions
from dev_db.dbt_diegomindfulanalyticsgmailcom.stg_postgres__events
group by 1

)

select round(avg(total_unique_sessions),1) as avg_total_unique_sessions from cte

```