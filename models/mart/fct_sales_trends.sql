with order_items as (
    select * from {{ ref('int_order_items_products') }}
),

daily_sales as (
    select
        date_trunc('day', order_purchase_timestamp)::date as date,
        sum(price) as daily_total_sales,
        count(distinct order_id) as daily_order_count,
        sum(price) / nullif(count(distinct order_id), 0) as average_order_value
    from order_items
    group by 1
),

weekly_sales as (
    select
        date_trunc('week', order_purchase_timestamp)::date as date,
        sum(price) as weekly_total_sales,
        count(distinct order_id) as weekly_order_count,
        sum(price) / nullif(count(distinct order_id), 0) as average_order_value
    from order_items
    group by 1
),

monthly_sales as (
    select
        date_trunc('month', order_purchase_timestamp)::date as date,
        sum(price) as monthly_total_sales,
        count(distinct order_id) as monthly_order_count,
        sum(price) / nullif(count(distinct order_id), 0) as average_order_value
    from order_items
    group by 1
),

combined_sales as (
    select date, daily_total_sales as total_sales, daily_order_count as order_count, average_order_value, 'daily' as granularity
    from daily_sales
    union all
    select date, weekly_total_sales, weekly_order_count, average_order_value, 'weekly' as granularity
    from weekly_sales
    union all
    select date, monthly_total_sales, monthly_order_count, average_order_value, 'monthly' as granularity
    from monthly_sales
)

select * from combined_sales 