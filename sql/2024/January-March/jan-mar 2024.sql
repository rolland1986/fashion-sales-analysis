WITH monthly_sales AS (
  SELECT
    Full_product_name,
    MONTH(STR_TO_DATE(Date, '%m/%d/%Y')) AS month,
    SUM(Net_price) AS total_sales
  FROM sales_2024
  WHERE STR_TO_DATE(Date, '%m/%d/%Y') BETWEEN '2024-01-01' AND '2024-03-31'
  GROUP BY Full_product_name, MONTH(STR_TO_DATE(Date, '%m/%d/%Y'))
),

pivot_sales AS (
  SELECT
    Full_product_name,
    MAX(CASE WHEN month = 1 THEN total_sales END) AS january_sales,
    MAX(CASE WHEN month = 3 THEN total_sales END) AS march_sales
  FROM monthly_sales
  GROUP BY Full_product_name
)

SELECT
  Full_product_name,
  ROUND(january_sales, 2) AS january_sales,
  ROUND(march_sales, 2) AS march_sales,
  ROUND(march_sales - january_sales, 2) AS growth_value,
  ROUND((march_sales - january_sales) / NULLIF(january_sales, 0) * 100, 2) AS growth_pct
FROM pivot_sales
ORDER BY growth_pct DESC;

WITH monthly_qty AS (
  SELECT
    Full_product_name,
    CASE
      WHEN MONTH(STR_TO_DATE(Date, '%m/%d/%Y')) = 1 THEN 'January'
      WHEN MONTH(STR_TO_DATE(Date, '%m/%d/%Y')) = 3 THEN 'March'
    END AS month,
    SUM(Quantity) AS total_qty
  FROM sales_2024
  WHERE MONTH(STR_TO_DATE(Date, '%m/%d/%Y')) IN (1, 3)
    AND Full_product_name IS NOT NULL
    AND Quantity IS NOT NULL
  GROUP BY Full_product_name, 
           CASE
             WHEN MONTH(STR_TO_DATE(Date, '%m/%d/%Y')) = 1 THEN 'January'
             WHEN MONTH(STR_TO_DATE(Date, '%m/%d/%Y')) = 3 THEN 'March'
           END
)


, pivot_qty AS (
  SELECT
    Full_product_name,
    MAX(CASE WHEN month = 'January' THEN total_qty END) AS january_qty,
    MAX(CASE WHEN month = 'March' THEN total_qty END) AS march_qty
  FROM monthly_qty
  GROUP BY Full_product_name
)

SELECT
  Full_product_name,
  COALESCE(january_qty, 0) AS january_qty,
  COALESCE(march_qty, 0) AS march_qty,
  COALESCE(march_qty, 0) - COALESCE(january_qty, 0) AS qty_growth,
  ROUND(
    (COALESCE(march_qty, 0) - COALESCE(january_qty, 0)) / NULLIF(january_qty, 0) * 100,
    2
  ) AS qty_growth_pct
FROM pivot_qty
ORDER BY qty_growth DESC
LIMIT 10;

SELECT
  Supplier,
  ROUND(SUM(CASE WHEN MONTH(STR_TO_DATE(Date, '%m/%d/%Y')) = 1 THEN Net_price ELSE 0 END), 2) AS January_sales,
  ROUND(SUM(CASE WHEN MONTH(STR_TO_DATE(Date, '%m/%d/%Y')) = 3 THEN Net_price ELSE 0 END), 2) AS March_sales,
  ROUND(SUM(CASE WHEN MONTH(STR_TO_DATE(Date, '%m/%d/%Y')) IN (1, 3) THEN Net_price ELSE 0 END), 2) AS total_sales
FROM sales_2024
WHERE MONTH(STR_TO_DATE(Date, '%m/%d/%Y')) IN (1, 3)
  AND Supplier IS NOT NULL
GROUP BY Supplier
ORDER BY total_sales DESC;

WITH discount_pct AS (
    SELECT
        Full_product_name,
        ROUND(AVG(CASE 
            WHEN MONTH(STR_TO_DATE(Date, '%m/%d/%Y')) = 1 THEN `Discount (%)` 
            ELSE NULL END), 2) AS January_discount,
        
        ROUND(AVG(CASE 
            WHEN MONTH(STR_TO_DATE(Date, '%m/%d/%Y')) = 3 THEN `Discount (%)` 
            ELSE NULL END), 2) AS March_discount,
        
        ROUND(AVG(`Discount (%)`), 2) AS avg_discount_pct
    FROM sales_2024
    WHERE `Discount (%)` IS NOT NULL 
      AND Full_product_name IS NOT NULL
    GROUP BY Full_product_name
)

SELECT *
FROM discount_pct
ORDER BY avg_discount_pct DESC
LIMIT 10;

WITH supplier_discount AS (
    SELECT
        Supplier,
        
        ROUND(AVG(CASE 
            WHEN MONTH(STR_TO_DATE(Date, '%m/%d/%Y')) = 1 THEN `Discount (%)` 
        END), 2) AS January_discount_pct,
        
        ROUND(AVG(CASE 
            WHEN MONTH(STR_TO_DATE(Date, '%m/%d/%Y')) = 3 THEN `Discount (%)` 
        END), 2) AS March_discount_pct,
        
        ROUND(AVG(`Discount (%)`), 2) AS avg_discount_pct
    FROM sales_2024
    WHERE `Discount (%)` IS NOT NULL 
      AND Supplier IS NOT NULL
    GROUP BY Supplier
)

SELECT *
FROM supplier_discount
ORDER BY avg_discount_pct DESC
LIMIT 10;