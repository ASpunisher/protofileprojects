--1- total revenue

--select * from pizza_sales


select cast(sum(total_price)as decimal(10,2) ) as total_revenue from pizza_sales

--2- average order value

select  cast(sum(total_price) /count(distinct(order_id)) as decimal(10,2))  as "Average Order Value"from pizza_sales


-- 3 total pizza sold 


select sum(quantity) as "total pizza sold " from pizza_sales


--4 total orders 
select count(distinct(order_id)) as 'total orders' from pizza_sales

--5 average pizzas per order 
select cast(cast(sum(quantity) as decimal(10,2)) / cast(count(distinct(order_id))as decimal(10,2)) as decimal(10,2)) from pizza_sales


-- 6 daily trend for total orders 
select Datename(DW,order_date) as week_day  ,count(distinct(order_id)) as total_orders from pizza_sales
group by Datename(DW,order_date)



--7 Houly trend for total orders 
select Datepart(Hour,order_time) as day_hour , count(distinct(order_id))  as total_orders from pizza_sales
group by Datepart(Hour,order_time)
order by DATEPART(Hour,order_time)

-- 8 percentage of sales by pizza category 
select pizza_category , cast(sum(total_price) as decimal(10,2)) as total_revenue ,
cast(cast(sum(total_price) as decimal(10,2))*100/(select sum(total_price) from pizza_sales ) as decimal(10,2)) as percentage_of_pizza_category   
from pizza_sales
group by pizza_category
order by cast(sum(total_price) as decimal(10,2)) desc

--9 percentage of sales by pizza size 
select pizza_size , cast(sum(total_price) as decimal(10,2)) as total_revenue ,
cast(cast(sum(total_price) as decimal(10,2))*100/(select sum(total_price) from pizza_sales ) as decimal(10,2)) as percentage_of_pizza_size  
from pizza_sales
group by pizza_size
order by cast(sum(total_price) as decimal(10,2)) desc


--10 total pizzas sold by pizza category 
select pizza_category , sum(quantity) as "sum of pizza sold " from pizza_sales
group by pizza_category
order by sum(quantity) desc


--11 top 5 best sellers by total pizza sold 


select top 5 pizza_name , sum(quantity) as num_of_pizza_sold  from pizza_sales
group by pizza_name
order by sum(quantity) desc


-- 12 bottom 5 worst seller by total pizza sold 

select top 5 pizza_name , sum(quantity) as num_of_pizza_sold  from pizza_sales
group by pizza_name
order by sum(quantity) asc