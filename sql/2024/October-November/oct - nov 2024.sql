WITH monthly_sales AS (
  SELECT
    Full_product_name,
    SUM(CASE WHEN MONTH(STR_TO_DATE(Date, '%m/%d/%Y')) = 10 THEN Net_price ELSE 0 END) AS october_sales,
    SUM(CASE WHEN MONTH(STR_TO_DATE(Date, '%m/%d/%Y')) = 11 THEN Net_price ELSE 0 END) AS november_sales
  FROM sales_2024
  WHERE MONTH(STR_TO_DATE(Date, '%m/%d/%Y')) IN (10, 11)
  GROUP BY Full_product_name
)

SELECT
  Full_product_name,
  ROUND(october_sales, 2) AS october_sales,
  ROUND(november_sales, 2) AS november_sales,
  ROUND(november_sales - october_sales, 2) AS growth_value,
  ROUND((november_sales - october_sales) / NULLIF(october_sales, 0) * 100, 2) AS growth_pct
FROM monthly_sales
ORDER BY growth_pct DESC
LIMIT 10;

WITH monthly_qty AS (
  SELECT
    Full_product_name,
    SUM(CASE WHEN MONTH(STR_TO_DATE(Date, '%m/%d/%Y')) = 10 THEN Quantity ELSE 0 END) AS october_qty,
    SUM(CASE WHEN MONTH(STR_TO_DATE(Date, '%m/%d/%Y')) = 11 THEN Quantity ELSE 0 END) AS november_qty
  FROM sales_2024
  WHERE MONTH(STR_TO_DATE(Date, '%m/%d/%Y')) IN (10, 11)
  GROUP BY Full_product_name
)

SELECT
  Full_product_name,
  COALESCE(october_qty, 0) AS october_qty,
  COALESCE(november_qty, 0) AS november_qty,
  COALESCE(november_qty, 0) - COALESCE(october_qty, 0) AS qty_growth,
  ROUND((COALESCE(november_qty, 0) - COALESCE(october_qty, 0)) / NULLIF(october_qty, 0) * 100, 2) AS qty_growth_pct
FROM monthly_qty
ORDER BY qty_growth_pct DESC
LIMIT 10;

SELECT 
  Supplier,
  ROUND(SUM(CASE WHEN MONTH(STR_TO_DATE(Date, '%m/%d/%Y')) = 10 THEN Net_price ELSE 0 END), 2) AS october_sales,
  ROUND(SUM(CASE WHEN MONTH(STR_TO_DATE(Date, '%m/%d/%Y')) = 11 THEN Net_price ELSE 0 END), 2) AS november_sales,
  ROUND(SUM(Net_price), 2) AS total_sales
FROM sales_2024
WHERE MONTH(STR_TO_DATE(Date, '%m/%d/%Y')) IN (10, 11)
  AND Supplier IS NOT NULL
GROUP BY Supplier
ORDER BY total_sales DESC
LIMIT 10;

WITH supplier_discount AS (
  SELECT 
    Supplier,
    ROUND(AVG(CASE WHEN MONTH(STR_TO_DATE(Date, '%m/%d/%Y')) = 10 THEN `Discount (%)`END), 2) AS October_discount_pct,
    ROUND(AVG(CASE WHEN MONTH(STR_TO_DATE(Date, '%m/%d/%Y')) = 11 THEN `Discount (%)` END), 2) AS November_discount_pct,
    ROUND(AVG(`Discount (%)`), 2) AS avg_discount_pct
  FROM sales_2024
  WHERE MONTH(STR_TO_DATE(Date, '%m/%d/%Y')) IN (10, 11)
    AND Supplier IS NOT NULL
    AND `Discount (%)` IS NOT NULL
  GROUP BY Supplier
)

SELECT *
FROM supplier_discount
ORDER BY avg_discount_pct DESC
LIMIT 10;

SELECT 
  Full_product_name,
  ROUND(AVG(`Discount (%)`), 2) AS avg_discount_pct
FROM sales_2024
WHERE MONTH(STR_TO_DATE(Date, '%m/%d/%Y')) IN (10, 11)
  AND `Discount (%)` IS NOT NULL
  AND Full_product_name IS NOT NULL
GROUP BY Full_product_name
ORDER BY avg_discount_pct DESC
LIMIT 10;