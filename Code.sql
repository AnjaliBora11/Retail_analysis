select * from products;
select * from orders;
select *  from order_items;
select * from customers;


--Q1.List all customers with their full name and email.
	select concat(first_name, ' ',last_name) as full_name , email
	from customers;

--Q2.Retrieve all orders placed on '2023-11-27'.
	select order_id
	from orders
	where order_date='2023-11-27';

--Q3.Find the total number of orders placed by each customer.
	select customer_id, count(*) as total_orders
	from orders
	group by customer_id;

--Q4.List product names and their prices sorted from highest to lowest.
	select product_name,price
	from products
	order by price desc;

--Q5.Find all orders that have a total price greater than 500.
	select order_id 
	from orders
	where total_price>500;

--Q6.Get the names of customers who have placed more than 1 order.
	select x.customer_id, concat( first_name, ' ', last_name) as customer_name 
	from 
		(select customer_id, count(*)
		from orders 
		group by customer_id
		having count(*)>1
		order by customer_id ) x
	join customers using (customer_id);

--Q7. List each customer's total spending based on order totals.
      select customer_id,sum(total_price) as total_spending
	  from orders
	  group by customer_id;

--Q8. Find the top 5 products by total quantity sold.
	  with cte as
	  (select product_id, sum(quantity) as tol_q, 
	  dense_rank() over(order by sum(quantity) desc) as rnk
	  from order_items
	  group by product_id)
	  select c.product_id, product_name, tol_q
	  from cte c
	  join products using(product_id)
	  where rnk<6;

--Q9.For each product, show the total quantity sold and the total revenue generated from sales.
	  select product_id, sum(quantity) as tot_q, sum(quantity*price_at_purchase) as total_revenue
	  from order_items
	  group by product_id;

--Q10.List all products that have never been ordered.
	  select p.product_id, product_name
	  from order_items o
	  left join products p on p.product_id=o.product_id
	  where o.product_id is null;

--Q11.Find customers who ordered products from more than 3 different categories.
	  with cte as
	  (select c.customer_id, concat(first_name,' ',last_name) as name,
	  count(category) as count
	  from customers c
	  join orders o using(customer_id)
	  join order_items oi using(order_id)
	  join products p using(product_id)
	  group by c.customer_id, concat(first_name,' ',last_name) )
	  select customer_id,name
	  from cte
	  where count>3;

--Q12.Identify the top 3 customers who spent the most in January 2024.
	  with cte as
	  (select extract(year from order_date) as year, extract(month from order_date) as month,
	  customer_id,sum(total_price) as total_spend
	  from orders
	  group by extract(year from order_date), extract(month from order_date),
	  customer_id),
	  rank as
	  (select customer_id, total_spend, dense_rank() over(order by total_spend desc) as rnk
	  from cte
	  where year=2024 and month=1)
	  select r.customer_id,concat(first_name,' ',last_name) as name, total_spend
	  from rank r
	  join customers using(customer_id)
	  where rnk<4;

	  
--Q13. Calculate the monthly revenue and number of orders for the past 6 months.(present date be last order date)
      select extract(month from order_date) as month, sum(total_price) as revenue, count(*) as no_of_orders
	  from orders
	  where order_date>= ( select (order_date-interval '6 months') as last_date
	  					from orders 
	  					order by order_date desc 
	  					limit 1)
	  group by extract(month from order_date) 
	  order by extract(month from order_date) ;

--Q14.Use a window function to rank customers by their total spending.
	  select customer_id, sum(total_price) as total_spending, dense_rank() over(order by sum(total_price) desc) as rnk
	  from orders
	  group by customer_id;

--Q15.Find the reorder rate: what percentage of customers placed more than one order.
	  with cte as
	  (select customer_id, row_number() over(partition by customer_id)
	  from orders),
	  reorder as
	  (select count(*) as count
	  from cte 
	  where row_number=2)
	  Select count *100/ (select count (*) from customers) as reorder_rate_per
	  from reorder;

--Q16.Identify the product with the highest revenue per category.
	  with cte as
	  (select category,product_id,product_name,sum(quantity*price_at_purchase) as revenue,
	  dense_rank() over(partition by category order by sum(quantity*price_at_purchase) desc) as rnk
	  from order_items
	  join products p using(product_id)
	  group by product_id,product_name,category)
	  select category,product_id,product_name,revenue
	  from cte
	  where rnk=1;

--Q17.Get each customer’s first and most recent order date.
	  select  distinct(customer_id),first_value(order_date) over( partition by customer_id order by order_date )
	  as first_date, first_value(order_date) over(partition by customer_id order by order_date desc) 
	  as recent_date
	  from orders
	  order by customer_id;
	  
--Q18.Determine the average number of days between a customer’s orders (for those with >1 order).
	  with cte as
	  (select customer_id,count(*) as reorder
	  from orders
	  group by customer_id
	  having count(*)>1),
	  dates as
	  (select  distinct(customer_id),first_value(order_date) over( partition by customer_id order by order_date )
	  as first_date, first_value(order_date) over(partition by customer_id order by order_date desc) 
	  as recent_date
	  from orders
	  order by customer_id)
	  select avg(recent_date-first_date) as avg_date 
	  from cte
	  join dates using(customer_id)
	 	   
--Q19.List suppliers_id whose products have a higher-than-average price in their category.
	  select distinct(p.supplier_id,product_id) as supid_prodid
	  ,product_name,price, x.avg_price as cat_avg
	  from products p
	  join 
	  (select supplier_id, avg(price) over (partition by category) as avg_price
	  from products)x on x.supplier_id=p.supplier_id
	  where price>avg_price; 	 

--Q20.Find the most frequently purchased product for each customer.
	  with cte as
	  (select customer_id, product_id,count(*) as frequency,
	  dense_rank() over( partition by customer_id order by count(*) desc) as rnk
	  from orders
	  join order_items using(order_id)
	  group by customer_id,product_id)
	  select customer_id,product_id,product_name, frequency
	  from cte
	  join products using(product_id)
	  where rnk<2
	  order by customer_id;	  
