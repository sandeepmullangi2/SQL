--in bigquery
with orders as (
select 'a01' as order_id, cast('2021-08-18 7:23:59' as timestamp) as order_datetime, 'b27' as customer_id, 'c87' as item_id, 20 as amount, 2 as quantity
union all 
select 'a02' as order_id, '2020-01-02 8:13:27' as order_datetime, 'b28' as customer_id, 'c56' as item_id, 100 as amount, 3 as quantity
union all 
select 'a02' as order_id, '2020-01-02 8:13:27' as order_datetime, 'b33' as customer_id, 'c57' as item_id, 39 as amount, 1 as quantity
union all 
select 'a03' as order_id, '2020-01-02 13:26:39' as order_datetime, 'b42' as customer_id, 'c31' as item_id, 587 as amount, 10 as quantity
union all 
select 'a04' as order_id, '2020-01-02 13:26:39' as order_datetime, 'b29' as customer_id, 'c57' as item_id, 587 as amount, 10 as quantity
union all 
select 'a05' as order_id, '2020-01-02 13:26:39' as order_datetime, 'b27' as customer_id, 'c56' as item_id, 587 as amount, 10 as quantity
),
customer as (
select 'b27' as customer_id, 'sam' as name, 'm' as gender, 'singapore' as country, 20 as age
union all 
select 'b28' as customer_id, 'bob' as name, 'm' as gender, 'Indonesia' as country, 27 as age
union all 
select 'b29' as customer_id, 'julie' as name, 'f' as gender, 'Korea' as country, 43 as age
),
items as (
select 'c87' as item_id, 'sportswear' as category
union all 
select 'c56' as item_id, 'skincare' as category   
union all 
select 'c57' as item_id, 'food' as category
)
--query1
select sum(amount) as total_sales,Extract(month from order_datetime) as sales_month, Extract(year from order_datetime) as sales_year from orders a join customer b on a.customer_id=b.customer_id 
where age > 18
group by Extract(month from order_datetime) , Extract(year from order_datetime)

--query2
select country, gender, category, sales_quantity
from
(
select country, gender, category,sales_quantity, row_number() over (partition by gender, country order by sales_quantity desc ) as rn
from
(
select country, gender, category, sum(amount*quantity) as sales_quantity, Extract(year from order_datetime)
from orders o 
join customer c on o.customer_id=c.customer_id
join items i on i.item_id= o.item_id
where Extract(year from order_datetime) = 2020
group by country, gender, category, Extract(year from order_datetime)
)
)
where rn=1

--query3
select customer_id, order_id
from
(
select customer_id, order_id, row_number() over (partition by customer_id order by order_datetime ) rn
from  orders where customer_id in 
(
select customer_id
from orders
where cast(order_datetime as DATE) between DATE_SUB(current_date(), INTERVAL 7 DAY) and current_date()
group by customer_id 
having count(order_id) > 10
)
)
where rn=2

