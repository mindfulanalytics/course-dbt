# Week 4 Project

## Part 1: dbt Snapshots

### Which products hand their inventory change from week 3 to week 4?

6 products had inventory changes from week 2 to week 3 captured in the products_snapshot model:
- Bamboo: From 44 to 23
- Monstera: From 50 to 31
- Philodendron: From 15 to 30
- Photos: From 0 to 20
- String of pearls: From 0 to 10
- ZZ Plant: From 53 to 41

```sql

with cte as (

    select 
        product_id
    from dev_db.dbt_diegomindfulanalyticsgmailcom.products_snapshot 
    where 1=1 
        and dbt_updated_at >= cast('2024-04-09' as date) 

)

select 
    ps.product_id,
    name,
    inventory,
    dbt_updated_at,
    dbt_valid_from,
    dbt_valid_to
from dev_db.dbt_diegomindfulanalyticsgmailcom.products_snapshot ps
inner join cte 
    on ps.product_id = cte.product_id
order by 2 asc, 4 desc

```

### Which products had the most fluctuations in inventory? Did we have any items go out of stock in the last 3 weeks?

The product with the most week to week inventory fluctations as measured by average inventory difference week to week is **ZZ Plant** 

| PRODUCT_NAME     | AVG_INVENTORY_FLUCTUATION |
|------------------|---------------------------|
| ZZ Plant         | 24                        |
| Bamboo           | 17                        |
| String of pearls | 16                        |
| Monstera         | 15                        |
| Philodendron     | 7                         |
| Pothos           | 7                         |


```sql

with cte as (

select 
    *,
    lag(inventory, 1) over (partition by product_id order by dbt_updated_at asc) as inventory_lag,
    (lag(inventory, 1) over (partition by product_id order by dbt_updated_at asc) - inventory) as inventory_difference
from dev_db.dbt_diegomindfulanalyticsgmailcom.products_snapshot ps
order by 2 asc, 6 desc

)

select 
    name as product_name,
    round(avg(inventory_difference),0) as avg_inventory_fluctuation
from cte 
where inventory_difference is not null
group by 1
order by 2 desc

```

### Did we have any items go out of stock in the last 3 weeks?

Both **Photos** and **String of pearls** went out of stock in week 3 of the course

## Part 2: Modeling challenge

### How are our users moving through the product funnel? Which steps in the funnel have largest drop off points?

Users are moving/converting:
- From product page views to add to carts **52.7%**
- From Add to Cars to Checkouts **87.4%**
- From Checkouts to Packages Shipped at **92.1%**

The step in the checkout funnel with the largest drop is from product page view to add to carts. This makes me think about how we might be able to incentivice more people to add the product they view to their carts. Maybe with a promo? This line of thought makes me want to add promos to order_id and promos to this wide table so we can report on the ability of promos to improve add to cart conversion.

### Bonus

Here's the link to the published sigma dashboard:

https://app.sigmacomputing.com/corise-dbt/workbook/workbook-4kUJmtu9k3ct3oUmHkyiH4?:link_source=share 

## Part 3: Reflection questions

### 3A. dbt next steps for you

#### If your organization is thinking about using dbt, how would you pitch the value of dbt/analytics engineering to a decision maker at your organization?

dbt is a transformation tool that leverages SQL and jinja, a pythonic templating language, to enable data analysts to implement data engineering best practices to our data project. It enables us to build version controlled and modular data models with documentation, testing, alerting, and performance reporting. With it, we can better model our business, and improve our ability to service various BI and operatioal use cases. We can build high quality data pipleines that inpsire trust to both our upstream and our downstream stakeholders.

#### If you are thinking about moving to analytics engineering, what skills have you picked that give you the most confidence in pursuing this next step?

The ability to use dbt core instead of dbt cloud. Selling an entreprise on dbt cloud is no mean feat. Being able to show value with dbt core as a POC is my next career challenge.

### 3B. Setting up for production / scheduled dbt run of your project

#### After learning about the various options for dbt deployment and seeing your final dbt project, how would you go about setting up a production/scheduled dbt run of your project in an ideal state?

In an ideal state, considering the various deployment options, I would personally pick dbt cloud to setup my production dbt run. dbt cloud is dbt's paid offering, and I would pick it because I believe the best thing an AE can do to drive adoption of their dbt project by downstream users is to reduce the barrier of entry. dbt cloud makes is super easy for analysts to setup their dbt project environment so they are empowered to explore, gain trust, and eventually contribute to the project themselves. Also, it has it's own orchestrator which simplifies the scheduling of new pipelines into production. Finally, it serves performance data and makes it readily available for auditing purposes, so we can all look for ways to refactor and reduce project costs.