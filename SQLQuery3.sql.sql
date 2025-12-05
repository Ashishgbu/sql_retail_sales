USE sql_project_1;

SELECT
*
FROM retail_sales;


SELECT
COUNT(*)
FROM retail_sales;

SELECT CAST(sale_time AS TIME) AS time_only
FROM retail_sales
WHERE sale_time = '19:10:00';

-- check is there any null present in the table
SELECT 
*
FROM retail_sales
WHERE sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR gender IS NULL
	  OR quantiy IS NULL OR price_per_unit IS NULL OR
	  cogs IS NULL OR total_sale IS NULL ;

--tra   sale_date     sale_time         cus_id    genger     age      category quat   price   cogs    total_sale
--679	  2022-08-26	08:59:00.0000000	64		Female		18		Beauty	  NULL	 NULL	NULL	NULL
--746	  2022-07-05	11:33:00.0000000	42		Female		33		Clothing  NULL	 NULL	NULL	NULL
--1225  2022-02-02	09:51:00.0000000	137		Female		57		Beauty	  NULL	 NULL	NULL	NULL


--Data cleaning
DELETE FROM retail_sales
WHERE sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR gender IS NULL
	  OR quantiy IS NULL OR price_per_unit IS NULL OR
	  cogs IS NULL OR total_sale IS NULL ;



-- Data Exploration

-- how many sales we have
SELECT COUNT(*) FROM retail_sales;

-- how many customer we have
SELECT COUNT(transactions_id) FROM retail_sales;

-- how many category we have
SELECT DISTINCT category FROM retail_sales;


-- Data Analysis and Business key problem

-- 1. Write a SQL query to retrieve all columns for sales made on '2022 - 11 - 05';
SELECT 
*
FROM retail_sales
WHERE sale_date = '2022-11-05';

-- 2. Write a sql query to retrieve all the transcations where the category is 'clothing' and the quantity sold is more than 10
-- in the month of Nov - 2022;
SELECT
*
FROM retail_sales
WHERE category = 'Clothing' AND  YEAR(sale_date) = 2022 AND MONTH(sale_date) = 11
AND quantiy >= 4;

-- 3. Write a SQL query to calculate the total sales(total_sales) for each category.
SELECT
category,SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY category;



-- 4. write a sql query to find the average age of customers who purchased items from the 'Beauty' category.
SELECT
AVG(age) AS avg_age
FROM retail_sales
WHERE category = 'Beauty';


-- 5.Write a sql query to find all transactions where the total_sale is greater than 1000.
SELECT
* 
FROM retail_sales
WHERE total_sale > 1000;

-- 6. Write a sql query to find the total number of transactions(transaction_id) made by each gender in each category
SELECT
category,gender,COUNT(*) AS total_transaction
FROM retail_sales
GROUP BY category,gender;

-- 7. Write a sql query to calculate the average sale for each month.find out best selling month in each year.
WITH MonthlyAvg AS 
(
SELECT 
YEAR(sale_date) AS year,MONTH(sale_date) AS month,AVG(total_sale) AS avg_sales
FROM retail_sales
GROUP BY YEAR(sale_date), MONTH(sale_date)
),

best_month AS(
SELECT 
year, month, avg_sales,ROW_NUMBER() OVER (PARTITION BY year ORDER BY avg_sales DESC) as month_rank
FROM MonthlyAvg
)

SELECT
Year,month,ROUND((avg_sales),2) AS avg_sales 
FROM best_month
WHERE month_rank = 1;

-- 8.Write a sql query to find the top 5 customers based on the highest total sales.
WITH high_sales AS (
SELECT
customer_id,SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY customer_id
),
highest_total AS (
SELECT
customer_id,total_sales,ROW_NUMBER() OVER (ORDER BY total_sales DESC) AS rnk
FROM high_sales
)
SELECT
customer_id,total_sales 
FROM highest_total
WHERE rnk <= 5;

-- 9. Write a sql query to find the number of unique customer's who purchased items from each category.
SELECT
category,COUNT(DISTINCT customer_id) AS unique_customers
FROM retail_sales
GROUP BY category;

-- 10. Write a SQL query to create each shift and number of order(Example Morning <= 12, Afternoon Between 12 & 17, Evening > 17)
WITH day_sales AS (
    SELECT *,
        CASE 
            WHEN DATEPART(HOUR, sale_time) < 12 THEN 'Morning'
            WHEN DATEPART(HOUR, sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
            ELSE 'Evening'
        END AS shift 
    FROM retail_sales
)
SELECT 
    shift,
    COUNT(*) AS number_of_orders  -- Use COUNT(*) instead of COUNT(transactions_id)
FROM day_sales 
GROUP BY shift;




























