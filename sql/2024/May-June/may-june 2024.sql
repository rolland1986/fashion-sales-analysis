WITH monthly_sales AS (
  SELECT 
    Full_product_name,
    CASE WHEN MONTH(STR_TO_DATE(Date, '%m/%d/%Y')) = 5 THEN SUM(Net_price) END AS may_sales,
    CASE WHEN MONTH(STR_TO_DATE(Date, '%m/%d/%Y')) = 6 THEN SUM(Net_price) END AS june_sales
  FROM sales_2024
  WHERE MONTH(STR_TO_DATE(Date, '%m/%d/%Y')) IN (5, 6)
  GROUP BY Full_product_name, MONTH(STR_TO_DATE(Date, '%m/%d/%Y'))
),
pivot_sales AS (
  SELECT 
    Full_product_name,
    MAX(CASE WHEN MONTH(STR_TO_DATE(Date, '%m/%d/%Y')) = 5 THEN Net_price END) AS may_sales,
    MAX(CASE WHEN MONTH(STR_TO_DATE(Date, '%m/%d/%Y')) = 6 THEN Net_price END) AS june_sales
  FROM sales_2024
  WHERE MONTH(STR_TO_DATE(Date, '%m/%d/%Y')) IN (5, 6)
  GROUP BY Full_product_name
)
SELECT 
  Full_product_name,
  ROUND(may_sales, 2) AS may_sales,
  ROUND(june_sales, 2) AS june_sales,
  ROUND(COALESCE(june_sales, 0) - COALESCE(may_sales, 0), 2) AS sales_growth,
  ROUND((COALESCE(june_sales, 0) - COALESCE(may_sales, 0)) / NULLIF(may_sales, 0) * 100, 2) AS sales_growth_pct
FROM pivot_sales
ORDER BY sales_growth_pct DESC
LIMIT 10;

WITH pivot_qty AS (
  SELECT
    Full_product_name,
    SUM(CASE WHEN MONTH(STR_TO_DATE(Date, '%m/%d/%Y')) = 5 THEN Quantity ELSE 0 END) AS may_qty,
    SUM(CASE WHEN MONTH(STR_TO_DATE(Date, '%m/%d/%Y')) = 6 THEN Quantity ELSE 0 END) AS june_qty
  FROM sales_2024
  WHERE MONTH(STR_TO_DATE(Date, '%m/%d/%Y')) IN (5, 6)
  GROUP BY Full_product_name
)
SELECT 
  Full_product_name,
  COALESCE(may_qty, 0) AS may_qty,
  COALESCE(june_qty, 0) AS june_qty,
  june_qty - may_qty AS qty_growth,
  ROUND((june_qty - may_qty) / NULLIF(may_qty, 0) * 100, 2) AS qty_growth_pct
FROM pivot_qty
ORDER BY qty_growth_pct DESC
LIMIT 10;

SELECT 
  Full_product_name,
  ROUND(AVG(`Discount (%)`), 2) AS avg_discount_pct
FROM sales_2024
WHERE `Discount (%)` IS NOT NULL
  AND MONTH(STR_TO_DATE(Date, '%m/%d/%Y')) IN (5, 6)
GROUP BY Full_product_name
ORDER BY avg_discount_pct DESC
LIMIT 10;

SELECT 
  Supplier,
  ROUND(SUM(CASE WHEN MONTH(STR_TO_DATE(Date, '%m/%d/%Y')) = 5 THEN Net_price ELSE 0 END), 2) AS May_sales,
  ROUND(SUM(CASE WHEN MONTH(STR_TO_DATE(Date, '%m/%d/%Y')) = 6 THEN Net_price ELSE 0 END), 2) AS June_sales,
  ROUND(SUM(Net_price), 2) AS total_sales
FROM sales_2024
WHERE MONTH(STR_TO_DATE(Date, '%m/%d/%Y')) IN (5, 6)
  AND Supplier IS NOT NULL
GROUP BY Supplier
ORDER BY total_sales DESC
LIMIT 10;

SELECT 
  Supplier,
  ROUND(AVG(CASE 
    WHEN MONTH(STR_TO_DATE(Date, '%m/%d/%Y')) = 5 THEN `Discount (%)` 
  END), 2) AS May_discount_pct,
  
  ROUND(AVG(CASE 
    WHEN MONTH(STR_TO_DATE(Date, '%m/%d/%Y')) = 6 THEN `Discount (%)` 
  END), 2) AS June_discount_pct,
  
  ROUND(AVG(`Discount (%)`), 2) AS avg_discount_pct
FROM sales_2024
WHERE MONTH(STR_TO_DATE(Date, '%m/%d/%Y')) IN (5, 6)
  AND Supplier IS NOT NULL
  AND `Discount (%)` IS NOT NULL
GROUP BY Supplier
ORDER BY avg_discount_pct DESC
LIMIT 10;