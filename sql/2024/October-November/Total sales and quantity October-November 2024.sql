SELECT
  MONTHNAME(STR_TO_DATE(Date, '%m/%d/%Y')) AS month_name,
  ROUND(SUM(Net_price), 2) AS total_sales
FROM sales_2024
WHERE STR_TO_DATE(Date, '%m/%d/%Y') BETWEEN '2024-10-01' AND '2024-11-30'
  AND MONTH(STR_TO_DATE(Date, '%m/%d/%Y')) IN (10, 11)
GROUP BY MONTHNAME(STR_TO_DATE(Date, '%m/%d/%Y'))
ORDER BY MIN(STR_TO_DATE(Date, '%m/%d/%Y'));

SELECT
  MONTHNAME(STR_TO_DATE(Date, '%m/%d/%Y')) AS month_name,
  ROUND(SUM(Quantity), 2) AS total_quantity
FROM sales_2024
WHERE STR_TO_DATE(Date, '%m/%d/%Y') BETWEEN '2024-10-01' AND '2024-11-30'
  AND MONTH(STR_TO_DATE(Date, '%m/%d/%Y')) IN (10, 11)
GROUP BY MONTHNAME(STR_TO_DATE(Date, '%m/%d/%Y'))
ORDER BY MIN(STR_TO_DATE(Date, '%m/%d/%Y'));

select distinct date
from sales_2024 limit 10;

SELECT COUNT(*) AS total_rows,
       SUM(Net_price) AS total_sales
FROM sales_2024
WHERE MONTH(STR_TO_DATE(Date, '%m/%d/%Y')) = 10
  AND YEAR(STR_TO_DATE(Date, '%m/%d/%Y')) = 2024;
  
SELECT Date, Net_price
FROM sales_2024
WHERE MONTH(STR_TO_DATE(Date, '%m/%d/%Y')) = 10
  AND YEAR(STR_TO_DATE(Date, '%m/%d/%Y')) = 2024
ORDER BY STR_TO_DATE(Date, '%m/%d/%Y');

SELECT COUNT(*) AS negative_count,
       SUM(Net_price) AS total_negative
FROM sales_2024
WHERE MONTH(STR_TO_DATE(Date, '%m/%d/%Y')) = 10
  AND YEAR(STR_TO_DATE(Date, '%m/%d/%Y')) = 2024
  AND Net_price < 0;
  
  SELECT SUM(Net_price) AS total_sales_no_negative
FROM sales_2024
WHERE MONTH(STR_TO_DATE(Date, '%m/%d/%Y')) = 10
  AND YEAR(STR_TO_DATE(Date, '%m/%d/%Y')) = 2024
  AND Net_price > 0;