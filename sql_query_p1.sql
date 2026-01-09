SELECT COUNT(*) FROM retail_sales;
SELECT * FROM retail_sales;

-- Data Cleaning --
SELECT * FROM retail_sales
WHERE 
	transaction_id IS NULL
	OR
	sale_date iS NULL
	OR
	sale_time IS NULL
	OR
	gender IS NULL
	OR 
	category IS NULL
	OR
	quantiy IS NULL 
	OR
	cogss IS NULL
	OR
	total_sale IS NULL

-- DELETE NULL COLUMN --
DELETE FROM retail_sales
WHERE 
	transaction_id IS NULL
	OR
	sale_date iS NULL
	OR
	sale_time IS NULL
	OR
	gender IS NULL
	OR 
	category IS NULL
	OR
	quantiy IS NULL 
	OR
	cogss IS NULL
	OR
	total_sale IS NULL

-- Data Exploration --

-- How many sales we have? --
SELECT COUNT(*) AS total_sale FROM retail_sales
-- How many customers we have? --
SELECT COUNT(DISTINCT customer_id) AS total_customer FROM retail_sales 
-- How many categories we have? --
SELECT COUNT(DISTINCT category) AS total_category FROM retail_sales
SELECT DISTINCT category FROM retail_sales;

-- Data Analysis & Business Key Problem --
-- Write SQL query to retrieve all columns for sales made on '2022-11-05'
SELECT * FROM retail_sales
WHERE sale_date = '2022-11-05'

-- Write SQL value to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of November 2022
SELECT *
FROM retail_sales
WHERE category = 'Clothing'
  AND quantiy >= 4
  AND TO_CHAR(sale_date, 'YYYY-MM') = '2022-11';

-- Write SQL query to calculate the total sales (total_sale) for each category
SELECT category, SUM(total_sale), COUNT(*) AS total_orders FROM retail_sales
GROUP BY category;

-- Write SQL query to find the average age of customers who purchased items from the 'Beauty' category
SELECT ROUND(AVG(age), 2) AS avg_age, category FROM retail_sales
WHERE category = 'Beauty'
GROUP BY category;

-- Write SQL query to find all transactions where the total_sale is greater than 1000;
SELECT * FROM retail_sales
WHERE total_sale > 1000;

-- Write SQL query to find total number of transaction_id made by each gender in each category
SELECT category, gender, COUNT(transaction_id) AS total_transaction FROM retail_sales
GROUP BY category, gender
ORDER BY 1;

-- Write SQL query to calculate the average sale for each month. Find out best selling month in each year
SELECT  
	EXTRACT(YEAR FROM sale_date) AS year,
	EXTRACT(MONTH FROM sale_date) AS month,
	AVG(total_sale) AS totalsale,
	RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC)
FROM retail_sales
GROUP BY year, month
-- ORDER BY year, totalsale DESC

SELECT 
year, month, totalsale 
FROM
(SELECT  
	EXTRACT(YEAR FROM sale_date) AS year,
	EXTRACT(MONTH FROM sale_date) AS month,
	AVG(total_sale) AS totalsale,
	RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC)
FROM retail_sales
GROUP BY year, month) AS t1
WHERE rank = 1

-- Write SQL query to find top 5 customers based on the highest total sales
SELECT customer_id, SUM(total_sale) AS total_sales FROM retail_sales
GROUP BY customer_id
ORDER BY SUM(total_sale) DESC
LIMIT 5;

-- WRITE SQL query to find number of unique customers who purchase items from each category
SELECT category, COUNT(DISTINCT customer_id) AS total_customers FROM retail_sales
GROUP BY category;

-- Write SQL query to create each shift and number of orders
WITH hourly_sales AS
(
SELECT *,
	CASE
		WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
		WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
	END AS shift
FROM retail_sales
)
SELECT
	shift,
	COUNT(*) AS total_orders
FROM hourly_sales
GROUP BY shift