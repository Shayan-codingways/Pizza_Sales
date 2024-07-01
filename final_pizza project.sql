create database pizzahut;

/* for large tables we can't export it easily*/

-- creating orders table manually bcz we can't directly import easily and want to clean it
create table orders(
order_id int Primary key,
order_date date not null,
order_time time not null orders
);

-- creating order-details table manually bcz we can't directly import easily and want to clean it
create table orders_details(
order_details_id int not null,
order_id int not null,
pizza_id text not null,
quantity int not null,
primary key(order_details_id)
)


-- Question 1 -> Retrieve the total number of orders placed.
Select count(order_id) as total_pizzaorders
from orders;

-- Question 2 -> Calculate the total revenue generated from pizza sales.
Select round(sum(pizzas.price*orders_details.quantity),2) as Total_Sales
From pizzas 
left join orders_details 
on pizzas.pizza_id=orders_details.pizza_id;

-- Question 3 -> Identify the highest-priced pizza by size and name
Select pt.name, p.size, max(p.price) as max_price
From pizzas as p
left join pizza_types as pt
on p.pizza_type_id=pt.pizza_type_id
group by p.size, pt.name
order by max_price desc
limit 4;

-- Pizzas max just by size
Select p.size, max(p.price) as max_price
From pizzas as p
left join pizza_types as pt
on p.pizza_type_id=pt.pizza_type_id
group by p.size
order by max_price desc;


-- question 4 -> Identify the most common pizza size ordered  +  number of pizzas oddered by size
Select pizzas.size, count(orders_details.quantity) as order_count
From pizzas 
left join orders_details 
on pizzas.pizza_id=orders_details.pizza_id
group by size
order by order_count desc;

-- question 5 -> List the top 5 most ordered pizza types along with their quantities.
Select pizza_types.name, pizzas.pizza_type_id, sum(orders_details.quantity) as order_count
From pizzas 
left join orders_details 
on pizzas.pizza_id=orders_details.pizza_id

left join pizza_types
on pizzas.pizza_type_id=pizza_types.pizza_type_id

group by pizza_type_id, pizza_types.name
order by order_count desc
limit 5;


-- Question 6 -> Join the necessary tables to find the total quantity of each pizza category ordered.
Select pt.category, sum(o1.quantity) as category_count
From orders as o2

left join orders_details as o1
on o2.order_id = o1.order_id

left join pizzas as p
on o1.pizza_id=p.pizza_id

left join pizza_types as pt
on p.pizza_type_id=pt.pizza_type_id

group by pt.category
order by category_count desc;

-- Question 7 -> Determine the distribution of orders by hour of the day.
select extract(hour from order_time) as hour, count(order_id) as hour_order  -- hour(order_time) can also be used
from orders
group by hour
order by hour;

-- busiest hour
select extract(hour from order_time) as hour, count(order_id) as hour_order  -- hour(order_time) can also be used
from orders
group by hour
order by hour_order desc
limit 1;

-- question 7 -> Join relevant tables to find the category-wise distribution of pizzas.
select category, count(name)
from pizza_types
group by category;


-- question 7 -> Group the orders by date 
select orders.order_date, sum(orders_details.quantity)
from orders
left join orders_details
on orders.order_id=orders_details.order_id
group by orders.order_date;

-- Group the orders by date and calculate the average number of pizzas ordered per day.
with orders_per_day as (
       select orders.order_date, sum(orders_details.quantity) as orders_on_a_day
       from orders
       left join orders_details
       on orders.order_id=orders_details.order_id
       group by orders.order_date
) -- cte with total orders on each day

-- query for average order for a  day. 
select round(avg(orders_on_a_Day))
from orders_per_day;

-- orders every month?
select case when extract(month from order_date) =1 then 'Jan'
			when extract(month from order_date) =2 then 'Feb'
            when extract(month from order_date) =3 then 'Mar'
            when extract(month from order_date) =4 then 'Apr'
            when extract(month from order_date) =5 then 'May'
			when extract(month from order_date) =6 then 'Jun'
            when extract(month from order_date) =7 then 'Jul'
			when extract(month from order_date) =8 then 'Aug'
			when extract(month from order_date) =9 then 'Sep'
			when extract(month from order_date) =10 then 'Oct'
			when extract(month from order_date) =11 then 'Nov'
			when extract(month from order_date) =12 then 'Dec'
            end as month,
	count(order_id)
from orders
group by month; 

-- avg orders per month
with orders_by_month as(
select case when extract(month from o.order_date) =1 then 'Jan'
			when extract(month from o.order_date) =2 then 'Feb'
            when extract(month from o.order_date) =3 then 'Mar'
            when extract(month from o.order_date) =4 then 'Apr'
            when extract(month from o.order_date) =5 then 'May'
			when extract(month from o.order_date) =6 then 'Jun'
            when extract(month from o.order_date) =7 then 'Jul'
			when extract(month from o.order_date) =8 then 'Aug'
			when extract(month from o.order_date) =9 then 'Sep'
			when extract(month from o.order_date) =10 then 'Oct'
			when extract(month from o.order_date) =11 then 'Nov'
			when extract(month from o.order_date) =12 then 'Dec'
            end as month,
	        sum(od.quantity) as total_pizzasamonth
from orders as o
left join orders_details as od
on o.order_id=od.order_id
group by month
)

select avg(total_pizzasamonth)
from orders_by_month;

-- avg orders per day per month
with orders_day_by_month as(
select case when extract(month from o.order_date) =1 then 'Jan'
			when extract(month from o.order_date) =2 then 'Feb'
            when extract(month from o.order_date) =3 then 'Mar'
            when extract(month from o.order_date) =4 then 'Apr'
            when extract(month from o.order_date) =5 then 'May'
			when extract(month from o.order_date) =6 then 'Jun'
            when extract(month from o.order_date) =7 then 'Jul'
			when extract(month from o.order_date) =8 then 'Aug'
			when extract(month from o.order_date) =9 then 'Sep'
			when extract(month from o.order_date) =10 then 'Oct'
			when extract(month from o.order_date) =11 then 'Nov'
			when extract(month from o.order_date) =12 then 'Dec'
            end as month,
            extract(day from o.order_date) as date, 
	        sum(od.quantity) as total_pizzas_everydayamonth
from orders as o
left join orders_details as od
on o.order_id=od.order_id
group by month, date
)

/*
select *
from orders_day_by_month;
*/

select month, avg(total_pizzas_everydayamonth)
from orders_day_by_month
group by month;


-- time between each sale
select order_date,order_time,  
	   CASE WHEN TIMESTAMPDIFF(MINUTE, LAG(order_time) OVER (ORDER BY order_time), order_time) = 0 THEN 
            CONCAT(TIMESTAMPDIFF(SECOND, LAG(order_time) OVER (ORDER BY order_time), order_time), ' seconds')
	   ELSE CONCAT(TIMESTAMPDIFF(MINUTE, LAG(order_time) OVER (ORDER BY order_time), order_time), ' minutes')
	   END AS time_gap
from orders
where order_date = '2015-01-01';


SELECT DATEDIFF(current_date, MIN(order_date)) AS days_difference_1storder,
       DATEDIFF(current_date, Max(order_date)) AS days_difference_2ndorder
FROM orders;

-- hour for most sales
select extract(hour from order_time) as hour, count(*) as count
from orders
group by hour
order by count desc
limit 1;

-- question -> Determine the top 3 most ordered pizza types based on revenue.

	   Select pizza_types.pizza_type_id, round(sum(pizzas.price*orders_details.quantity),2) as Total_Sales
       From pizzas 
       
       left join orders_details 
       on pizzas.pizza_id=orders_details.pizza_id
       
       left join pizza_types
       on pizzas.pizza_type_id=pizza_types.pizza_type_id
       
       group by pizza_type_id
       order by total_sales desc
       limit 3;
       
	
   
   
-- question -> Calculate the percentage contribution of each pizza type to total revenue.
with pizza_type_revenue as(
       Select pizza_types.category as name, 
              round(sum(pizzas.price*orders_details.quantity),2) as Total_Sales_cat
       From pizzas 
       
       left join orders_details 
       on pizzas.pizza_id=orders_details.pizza_id
       
       left join pizza_types
       on pizzas.pizza_type_id=pizza_types.pizza_type_id
       
       group by pizza_types.category
),

total_revenue as(
    Select round(sum(pizzas.price*orders_details.quantity),2) as Total_Sales
    
	From pizzas 
    left join orders_details 
    on pizzas.pizza_id=orders_details.pizza_id
)

select name, 
      concat(round((Total_Sales_cat / (select Total_sales from total_revenue))* 100,2) ,'%' )as Percent_revenue
from pizza_type_revenue
group by name 
order by Percent_revenue desc;



-- question -> Analyze the cumulative revenue generated over time.
with daily_revenue as(
  select o.order_date as date, sum(od.quantity*p.price) as revenue
  from orders_details as od
  left join pizzas as p
  on od.pizza_id=p.pizza_id
  
  left join orders as o
  on o.order_id=od.order_id
  group by o.order_date
)

select date, round(revenue,2), round(SUM(revenue) OVER (ORDER BY date),2) AS cumulative_revenue
from daily_revenue;

-- question -> Determine the top 3 most ordered pizza types based on revenue for each pizza category.

select name, category,round(category_type__revenue,2), rn
-- this outer query for filtering rank as rank can't be filtered within its own query

from( -- generates rank using results of inner query
select name, category, category_type__revenue, rank() over(partition by category order by category_type__revenue desc) as rn

from ( -- this query generate ccategory wise, name wise revenue
Select pt.name, pt.category, sum(o1.quantity * p.price) as category_type__revenue
From orders as o2

left join orders_details as o1
on o2.order_id = o1.order_id

left join pizzas as p
on o1.pizza_id=p.pizza_id

left join pizza_types as pt
on p.pizza_type_id=pt.pizza_type_id

group by pt.category,pt.name) as subquery

) as othersubquery

where rn<4;

-- had to create subqueries, as window functions work on predefined results. and we can't filter rn directly within its own subquery



      
	
