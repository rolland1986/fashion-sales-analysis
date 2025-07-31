WITH monthly_sales AS (
  SELECT
    Full_name,
    MONTH(Date) AS month,
    SUM(Net_price) AS total_sales
  FROM sales_2023
  WHERE MONTH(Date) IN (1, 3)
    AND YEAR(Date) = 2023
  GROUP BY Full_name, MONTH(Date)
),
pivot_sales AS (
  SELECT
    Full_name,
    MAX(CASE WHEN month = 1 THEN total_sales END) AS January_sales,
    MAX(CASE WHEN month = 3 THEN total_sales END) AS March_sales
  FROM monthly_sales
  GROUP BY Full_name
)
SELECT
  Full_name,
  ROUND(january_sales, 2) AS january_sales,
  ROUND(march_sales, 2) AS march_sales,
  ROUND(march_sales - january_sales, 2) AS growth_value,
  ROUND((march_sales - january_sales) / NULLIF(january_sales, 0) * 100, 2) AS growth_pct
FROM pivot_sales
ORDER BY growth_pct DESC;

SELECT
    MONTHNAME(Date) AS month_name,
    Full_name,
    SUM(Net_price) AS total_sales
FROM sales_2023
WHERE MONTH(Date) IN (1, 3) AND YEAR(Date) = 2023
GROUP BY MONTHNAME(Date), Full_name
ORDER BY month_name, total_sales DESC;

SELECT
    MONTHNAME(Date) AS month_name,
    Full_name,
    SUM(Quantity) AS total_quantity
FROM sales_2023
WHERE MONTH(Date) IN (1, 3) AND YEAR(Date) = 2023
GROUP BY MONTHNAME(Date), Full_name
ORDER BY month_name, Full_name;

SELECT
    DATE_FORMAT(Date, '%M') AS month_name,
    Full_name AS product_group,
    ROUND(SUM(Discount_value_ron), 2) AS total_discount_value,
    ROUND(SUM(Discount_value_ron) / NULLIF(SUM(Full_price), 0) * 100, 2) AS average_discount_pct,
    ROUND(SUM(Net_price), 2) AS total_net_sales
FROM sales_2023
WHERE Month(Date) IN (1, 3)
AND YEAR(Date) = 2023
GROUP BY month_name, product_group
ORDER BY month_name, total_discount_value DESC;

SELECT
	Supplier,
	ROUND(SUM(CASE WHEN Month(Date) = 1 THEN Net_price ELSE 0 END), 2) AS January_sales,
    ROUND(SUM(CASE WHEN Month(Date) = 3 THEN Net_price ELSE 0 END), 2) AS March_sales,
    ROUND(SUM(Net_price), 2) AS total_sales
    FROM sales_2023
    WHERE Month(Date) IN (1, 3)
    AND Year(Date) = 2023
    GROUP BY Supplier
    ORDER BY total_sales DESC;
    
    WITH ranked_sales AS (
  SELECT 
    MONTHNAME(Date) AS month_name,
    Full_name,
    SUM(Net_price) AS total_sales,
    RANK() OVER (PARTITION BY MONTHNAME(Date) ORDER BY SUM(Net_price) DESC) AS rnk
  FROM sales_2023
  WHERE MONTH(Date) IN (1, 3)
    AND YEAR(Date) = 2023
  GROUP BY MONTHNAME(Date), Full_name
)

SELECT *
FROM ranked_sales
WHERE rnk <= 10;
