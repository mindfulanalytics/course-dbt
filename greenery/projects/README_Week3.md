# Week 3 Project

## Part 1: Create new models to answer the first two questions

### What is our overall conversion rate?

62.5% is overall session conversion

```sql

SELECT 
    COUNT(DISTINCT CASE WHEN CHECKOUTS = 1 THEN SESSION_ID ELSE NULL END ) as total_unique_sessions_with_purchase,
    COUNT(DISTINCT SESSION_ID) as total_unique_sessions,
    ROUND(
        (COUNT(DISTINCT CASE WHEN CHECKOUTS = 1 THEN SESSION_ID ELSE NULL END ) 
            / COUNT(DISTINCT SESSION_ID) 
        ), 3
    ) as overall_conversion_rate
FROM DEV_DB.DBT_DIEGOMINDFULANALYTICSGMAILCOM.FACT_PAGE_VIEWS

```

### What is our conversion rate by product?

Here are the top 5 products by conversion rate

| PRODUCT_NAME     | TOTAL_UNIQUE_SESSIONS_WITH_PURCHASE | TOTAL_UNIQUE_SESSIONS | OVERALL_CONVERSION_RATE |
|------------------|-------------------------------------|-----------------------|-------------------------|
| String of pearls | 39                                  | 64                    | 0.609                   |
| Arrow Head       | 35                                  | 63                    | 0.556                   |
| Cactus           | 30                                  | 55                    | 0.545                   |
| ZZ Plant         | 34                                  | 63                    | 0.54                    |
| Bamboo           | 36                                  | 67                    | 0.537                   |


```sql

SELECT 
    dp.product_name,
    COUNT(DISTINCT CASE WHEN CHECKOUTS = 1 THEN SESSION_ID ELSE NULL END ) as total_unique_sessions_with_purchase,
    COUNT(DISTINCT SESSION_ID) as total_unique_sessions,
    ROUND((COUNT(DISTINCT CASE WHEN CHECKOUTS = 1 THEN SESSION_ID ELSE NULL END ) / COUNT(DISTINCT SESSION_ID) ), 3) as overall_conversion_rate
FROM DEV_DB.DBT_DIEGOMINDFULANALYTICSGMAILCOM.FACT_PAGE_VIEWS fpv
LEFT JOIN DEV_DB.DBT_DIEGOMINDFULANALYTICSGMAILCOM.DIM_PRODUCTS dp 
    ON fpv.PRODUCT_ID = dp.PRODUCT_ID
GROUP BY 1
order by 4 desc
limit 5

```

### Additional question to think about. Why are some products converting better than others?

Three reasons why certain products might convert better than others:
1. Price: Product is priced competitively, or there is an active promotion.
2. Popularity: Certain products might be more popular than others based on their visual appeal.
3. Seasonality: Certain products might be more popular at certain times of the year. For example poinsettia's during the winter.


## Part 2: Create a macros to improve your dbt project

Created the sum_of.sql macro in the /macros folder. Implemented the sm_of macro in the fact_page_views model, and created a sum_of.yml file to document it.

## Part 3: Grant reporting permissions to our dbt models with a post hook.


Created the gran.sql macro in the /macros folder. Implemented a grant reporting permissions post hook in the dbt_proyect.yml file. This macro will grant reporting permissions to all dbt model in the greenery proyect after a dbt run.

## Part 4: Insall a dbt package and apply one or more macros to proyect.

Installed the dbt-labs/dbt_utils, dbt-labs/codegen, and calogica/dbt_expectations packages in the packages.yml file.

Applied generate_model_yaml operation from the dbt-labs/codegen package to generate the yml documentation for various stg and final models.

Applied the dbt_utils.get_column_values() macro from dbt/utils in the fact_page_views.sql model. Also applied the dbt_utils.accepted_range macro as a test on the order_total field of the stg_postgres__orders model.


## Part 5: Show off your work

See attached screenshot of dag and the updated packages.yml file.

## Part 6: Run products snapshot model, what has changed?

6 products had inventory changes from week 2 to week 3 captured in the products_snapshot model:
- Bamboo: From 56 to 44
- Monstera: From 64 to 50
- Philodendron: From 25 to 15
- Photos: From 20 to 0
- Philodendron: From 10 to 0
- ZZ Plant: From 53 to 58