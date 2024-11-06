with customers as (
    select * from {{ ref('stg_customers') }}
),

orders as (
    select * from {{ ref('stg_orders') }}
),

customer_orders as (
    select
        customers.customer_id,
        customers.unique_id,
        customers.city,
        customers.state,
        orders.order_id,
        orders.order_status,
        orders.order_purchase_timestamp,
        orders.order_delivered_customer_date
    from customers
    left join orders on customers.customer_id = orders.customer_id
)

select * from customer_orders 