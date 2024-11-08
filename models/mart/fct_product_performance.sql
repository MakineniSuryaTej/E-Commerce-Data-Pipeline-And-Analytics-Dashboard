with order_items_products as (
    select * from {{ ref('int_order_items_products') }}
),

product_performance as (
    select
        product_id,
        product_category_name,
        count(distinct order_id) as number_of_orders,
        sum(price) as total_revenue,
        avg(price) as average_price,
        sum(freight_value) as total_freight_value,
        count(case when order_status = 'delivered' then 1 end) as delivered_orders,
        avg(datediff('day', order_purchase_timestamp, shipping_limit_date)) as avg_shipping_time
    from order_items_products
    group by 1, 2
)

select * from product_performance 