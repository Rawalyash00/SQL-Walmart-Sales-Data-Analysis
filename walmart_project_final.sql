CREATE TABLE IF NOT EXISTS sales(
	invoice_id VARCHAR(50) NOT NULL PRIMARY KEY,
    branch VARCHAR(50) NOT NULL,
    city VARCHAR(50) NOT NULL,
    customer_type VARCHAR(50) NOT NULL,
    gender VARCHAR(50) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(20,2) NOT NULL,
    quantity INT NOT NULL,
    tax_pct decimal (60, 4) NOT NULL,
    total DECIMAL(22, 4) NOT NULL,
    date DATE NOT NULL,
    time TIME NOT NULL,
    payment VARCHAR(55) NOT NULL,
    cogs DECIMAL(20,2) NOT NULL,
    gross_margin_pct decimal (21, 9),
    gross_income DECIMAL(22, 4),
    rating decimal(22, 1)
);

select * from sales;


--DATA CLEANING: as there are are no null value because NOT Null data type was alrady used while creating table--
-------------------------------------FEATURE ENGINEERING-------------------------------------------------------

-- time_of_day 

SELECT
	time,
	(CASE
		WHEN `time` BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
        WHEN `time` BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
        ELSE 'Evening'
    END) AS time_of_day
FROM sales;

ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(20);

update sales

set time_of_day = ( CASE
		WHEN `time` BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
        WHEN `time` BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
        ELSE 'Evening'
    END
	     );

-- day_name 
SELECT 
    date,
    CASE 
        WHEN EXTRACT(DOW FROM date) = 0 THEN 'Sunday'
        WHEN EXTRACT(DOW FROM date) = 1 THEN 'Monday'
        WHEN EXTRACT(DOW FROM date) = 2 THEN 'Tuesday'
        WHEN EXTRACT(DOW FROM date) = 3 THEN 'Wednesday'
        WHEN EXTRACT(DOW FROM date) = 4 THEN 'Thursday'
        WHEN EXTRACT(DOW FROM date) = 5 THEN 'Friday'
        WHEN EXTRACT(DOW FROM date) = 6 THEN 'Saturday'
    END AS day_of_week
FROM 
    sales;

alter table sales add column day_name varchar(10); 

update sales 
     set day_name =
    ( CASE 
        WHEN EXTRACT(DOW FROM date) = 0 THEN 'Sunday'
        WHEN EXTRACT(DOW FROM date) = 1 THEN 'Monday'
        WHEN EXTRACT(DOW FROM date) = 2 THEN 'Tuesday'
        WHEN EXTRACT(DOW FROM date) = 3 THEN 'Wednesday'
        WHEN EXTRACT(DOW FROM date) = 4 THEN 'Thursday'
        WHEN EXTRACT(DOW FROM date) = 5 THEN 'Friday'
        WHEN EXTRACT(DOW FROM date) = 6 THEN 'Saturday'
    END 
	); 

-- month_name 
SELECT 
    date,
    CASE 
        WHEN EXTRACT(MONTH FROM date) = 1 THEN 'January'
        WHEN EXTRACT(MONTH FROM date) = 2 THEN 'February'
        WHEN EXTRACT(MONTH FROM date) = 3 THEN 'March'
        WHEN EXTRACT(MONTH FROM date) = 4 THEN 'April'
        WHEN EXTRACT(MONTH FROM date) = 5 THEN 'May'
        WHEN EXTRACT(MONTH FROM date) = 6 THEN 'June'
        WHEN EXTRACT(MONTH FROM date) = 7 THEN 'July'
        WHEN EXTRACT(MONTH FROM date) = 8 THEN 'August'
        WHEN EXTRACT(MONTH FROM date) = 9 THEN 'September'
        WHEN EXTRACT(MONTH FROM date) = 10 THEN 'October'
        WHEN EXTRACT(MONTH FROM date) = 11 THEN 'November'
        WHEN EXTRACT(MONTH FROM date) = 12 THEN 'December'
    END AS month_name
FROM 
    sales;

alter table sales add column month_name varchar(10); 

update sales 
       set month_name = (CASE 
        WHEN EXTRACT(MONTH FROM date) = 1 THEN 'January'
        WHEN EXTRACT(MONTH FROM date) = 2 THEN 'February'
        WHEN EXTRACT(MONTH FROM date) = 3 THEN 'March'
        WHEN EXTRACT(MONTH FROM date) = 4 THEN 'April'
        WHEN EXTRACT(MONTH FROM date) = 5 THEN 'May'
        WHEN EXTRACT(MONTH FROM date) = 6 THEN 'June'
        WHEN EXTRACT(MONTH FROM date) = 7 THEN 'July'
        WHEN EXTRACT(MONTH FROM date) = 8 THEN 'August'
        WHEN EXTRACT(MONTH FROM date) = 9 THEN 'September'
        WHEN EXTRACT(MONTH FROM date) = 10 THEN 'October'
        WHEN EXTRACT(MONTH FROM date) = 11 THEN 'November'
        WHEN EXTRACT(MONTH FROM date) = 12 THEN 'December'
    END ); 
	
--------------------------------------------------------------------------------------------------------------
-------------------------------------Generic------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------
	
--- How many unique cities does the data have?----------------------------------------------------------------  
	
	select 
	distinct city 
	from sales; 
	
---- In which city is each branch?------------------------------------------------------------------------------
select 
   distinct city, branch 
   from sales; 
---------------------------------------------------------------------------------------------------------------   
----------------------------------------Product----------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------

--- How many unique product lines does the data have? 
    select 
	     distinct  product_line
		 from sales; 

--- What is the most common payment method?

    select 
	payment, 
	    count(payment) as cnt
		from sales 
		group by payment 
		order by cnt desc;  
		
-- What is the most selling product line
    
 select 
	product_line, 
	    count(product_line) as cnt
		from sales 
		group by product_line 
		order by cnt desc;  

 -- What is total revenue by month? 
 
 select 
        month_name as month, 
		sum(total) as total_revenue 
 from sales 
   group by month_name 
   order by total_revenue desc; 
   
-- What month had the largest COGS?
select 
 month_name as month, 
 sum(cogs) as cogs 
 from sales 
  group by month_name 
  order by cogs desc; 
  

-- What product line had the largest revenue? \

  select 
    product_line, 
	sum(total) as total_revenue
	from sales
	group by product_line
	order by total_revenue desc; 
	
-- What is the city with the largets revenue? 

 select branch, 
 city, 
 SUM(total) as total_revenue
 from sales
 group by branch, city 
 order by total_revenue desc; 
 
 -- what product line had largest VAT?
 
 select product_line, 
 avg(tax_pct) as avg_tax
 from sales 
 group by product_line 
 order by avg_tax desc; 
 select * from sales; 
 
 -- Fetch each product line and add a column to those product 
-- line showing "Good", "Bad". Good if its greater than average sales

SELECT 
	AVG(quantity) AS avg_qnty
FROM sales;

SELECT
	product_line,
	CASE
		WHEN AVG(quantity) > 6 THEN "Good"
        ELSE "Bad"
    END AS remark
FROM sales
GROUP BY product_line;


-- Which branch sold more products than average product sold?
SELECT 
	branch, 
    SUM(quantity) AS qnty
FROM sales
GROUP BY branch
HAVING SUM(quantity) > (SELECT AVG(quantity) FROM sales);


-- What is the most common product line by gender
SELECT
	gender,
    product_line,
    COUNT(gender) AS total_cnt
FROM sales
GROUP BY gender, product_line
ORDER BY total_cnt DESC;

-- What is the average rating of each product line
SELECT
	ROUND(AVG(rating), 2) as avg_rating,
    product_line
FROM sales
GROUP BY product_line
ORDER BY avg_rating DESC;

-- --------------------------------------------------------------------
-- --------------------------------------------------------------------

-- --------------------------------------------------------------------
-- -------------------------- Customers -------------------------------
-- --------------------------------------------------------------------

-- How many unique customer types does the data have?
SELECT
	DISTINCT customer_type
FROM sales;

-- How many unique payment methods does the data have?
SELECT
	DISTINCT payment
FROM sales;


-- What is the most common customer type?
SELECT
	customer_type,
	count(*) as count
FROM sales
GROUP BY customer_type
ORDER BY count DESC;

-- Which customer type buys the most?
SELECT
	customer_type,
    COUNT(*)
FROM sales
GROUP BY customer_type;


-- What is the gender of most of the customers?
SELECT
	gender,
	COUNT(*) as gender_cnt
FROM sales
GROUP BY gender
ORDER BY gender_cnt DESC;

-- What is the gender distribution per branch?
SELECT
	gender,
	COUNT(*) as gender_cnt
FROM sales
WHERE branch = "C"
GROUP BY gender
ORDER BY gender_cnt DESC;
-- Gender per branch is more or less the same hence, I don't think has
-- an effect of the sales per branch and other factors.

-- Which time of the day do customers give most ratings?
SELECT
	time_of_day,
	AVG(rating) AS avg_rating
FROM sales
GROUP BY time_of_day
ORDER BY avg_rating DESC;
-- Looks like time of the day does not really affect the rating, its
-- more or less the same rating each time of the day.alter


-- Which time of the day do customers give most ratings per branch?
SELECT
	time_of_day,
	AVG(rating) AS avg_rating
FROM sales
WHERE branch = "A"
GROUP BY time_of_day
ORDER BY avg_rating DESC;
-- Branch A and C are doing well in ratings, branch B needs to do a 
-- little more to get better ratings.


-- Which day fo the week has the best avg ratings?
SELECT
	day_name,
	AVG(rating) AS avg_rating
FROM sales
GROUP BY day_name 
ORDER BY avg_rating DESC;
-- Mon, Tue and Friday are the top best days for good ratings
-- why is that the case, how many sales are made on these days?



-- Which day of the week has the best average ratings per branch?
SELECT 
	day_name,
	COUNT(day_name) total_sales
FROM sales
WHERE branch = "C"
GROUP BY day_name
ORDER BY total_sales DESC;


-- --------------------------------------------------------------------
-- --------------------------------------------------------------------

-- --------------------------------------------------------------------
-- ---------------------------- Sales ---------------------------------
-- --------------------------------------------------------------------

-- Number of sales made in each time of the day per weekday 
SELECT
	time_of_day,
	COUNT(*) AS total_sales
FROM sales
WHERE day_name = "Sunday"
GROUP BY time_of_day 
ORDER BY total_sales DESC;
-- Evenings experience most sales, the stores are 
-- filled during the evening hours

-- Which of the customer types brings the most revenue?
SELECT
	customer_type,
	SUM(total) AS total_revenue
FROM sales
GROUP BY customer_type
ORDER BY total_revenue;

-- Which city has the largest tax/VAT percent?
SELECT
	city,
    ROUND(AVG(tax_pct), 2) AS avg_tax_pct
FROM sales
GROUP BY city 
ORDER BY avg_tax_pct DESC;

-- Which customer type pays the most in VAT?
SELECT
	customer_type,
	AVG(tax_pct) AS total_tax
FROM sales
GROUP BY customer_type
ORDER BY total_tax;

-- --------------------------------------------------------------------
-- --------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------------


