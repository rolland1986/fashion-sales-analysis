WITH sales_summary AS (
  SELECT
    Full_name,
    SUM(CASE WHEN MONTH(Date) = 5 THEN Net_price ELSE 0 END) AS may_sales,
    SUM(CASE WHEN MONTH(Date) = 6 THEN Net_price ELSE 0 END) AS jun_sales
  FROM sales_2023
  WHERE MONTH(Date) IN (5, 6)
    AND YEAR(Date) = 2023
  GROUP BY Full_name
)

SELECT
  Full_name,
  ROUND(may_sales, 2) AS May_sales,
  ROUND(jun_sales, 2) AS June_sales,
  ROUND(may_sales - jun_sales, 2) AS growth_value,
  ROUND((may_sales - jun_sales) / NULLIF(jun_sales, 0) * 100, 2) AS growth_pct
FROM sales_summary
ORDER BY growth_pct DESC
LIMIT 10;

WITH ranked_sales AS (
  SELECT 
    MONTHNAME(Date) AS month_name,
    Full_name,
    SUM(Net_price) AS total_sales,
    RANK() OVER (PARTITION BY MONTHNAME(Date) ORDER BY SUM(Net_price) DESC) AS rnk
  FROM sales_2023
  WHERE MONTH(Date) IN (5, 6)
    AND YEAR(Date) = 2023
  GROUP BY MONTHNAME(Date), Full_name
)

SELECT *
FROM ranked_sales
WHERE rnk <= 10;

SELECT
	Supplier,
	ROUND(SUM(CASE WHEN Month(Date) = 5 THEN Net_price ELSE 0 END), 2) AS May_sales,
    ROUND(SUM(CASE WHEN Month(Date) = 6 THEN Net_price ELSE 0 END), 2) AS June_sales,
    ROUND(SUM(Net_price), 2) AS total_sales
    FROM sales_2023
    WHERE Month(Date) IN (5, 6)
    AND Year(Date) = 2023
    GROUP BY Supplier
    ORDER BY total_sales DESC;
    
    SELECT
    DATE_FORMAT(Date, '%M') AS month_name,
    Full_name AS product_group,
    ROUND(SUM(Discount_value_ron), 2) AS total_discount_value,
    ROUND(SUM(Discount_value_ron) / NULLIF(SUM(Full_price), 0) * 100, 2) AS average_discount_pct,
    ROUND(SUM(Net_price), 2) AS total_net_sales
FROM sales_2023
WHERE Date BETWEEN '2023-05-01' AND '2023-06-30'
GROUP BY month_name, product_group
ORDER BY month_name, total_discount_value DESC;

SELECT
    MONTHNAME(Date) AS month_name,
    Full_name,
    SUM(Quantity) AS total_quantity
FROM sales_2023
WHERE MONTH(Date) IN (5, 6) AND YEAR(Date) = 2023
GROUP BY MONTHNAME(Date), Full_name
ORDER BY month_name, Full_name;
