# Retail_analysis SQL Analytics Project
  
📌 Overview
This project demonstrates the use of advanced SQL to analyze a relational retail database containing four main tables: customers, orders, order_items, and products. The goal is to extract actionable business insights such as top-selling products, customer behavior, reorder patterns, revenue trends, and more.

🗂️ Dataset Structure
	• customers: Customer ID, name, and contact information
	• orders: Order ID, customer ID, date, and total price
	• order_items: Order ID, product ID, quantity, and price at purchase
	• products: Product ID, name, price, category, supplier ID

🎯 Key Insights & Queries
	• Customer Insights
		○ Top spenders by month
		○ Reorder rate
		○ Average time between orders
		○ Most frequently purchased product per customer
	• Order Analysis
		○ Total orders per customer
		○ Orders by date and revenue
		○ Monthly order trends (last 6 months)
	• Product Performance
		○ Top 5 products by quantity sold
		○ Revenue and quantity sold by product
		○ Products never ordered
		○ Top product by revenue in each category
	• Advanced Queries
		○ Customers buying from 3+ categories
		○ Revenue per customer using window functions
		○ High-value suppliers with above-average pricing

🔧 Tools Used
	• SQL (PostgreSQL dialect)
	• Window Functions (e.g., DENSE_RANK(), FIRST_VALUE())
	• CTEs and Subqueries
	• Aggregate Functions (SUM, COUNT, AVG)
	• Conditional Logic with CASE

🏆 Sample Business Findings
	• Customers with the highest January 2024 spending identified for targeted retention.
	• Reorder rate shows strong customer engagement.
	• The paper sub-category saw the highest YoY profit growth.
	• Top products and categories by sales help in inventory planning.

📈 Purpose
This project showcases my ability to:
	• Write complex, optimized SQL queries
	• Translate business needs into data questions
	• Extract actionable insights from relational datasets
	• Use advanced SQL features like ranking, partitioning, and date manipulation
