SELECT
  MONTHNAME(STR_TO_DATE(Date, '%m/%d/%Y')) AS month_name,
  ROUND(SUM(Net_price), 2) AS total_sales
FROM sales_2024
WHERE STR_TO_DATE(Date, '%m/%d/%Y') BETWEEN '2024-05-01' AND '2024-06-30'
  AND MONTH(STR_TO_DATE(Date, '%m/%d/%Y')) IN (5, 6)
GROUP BY MONTHNAME(STR_TO_DATE(Date, '%m/%d/%Y'))
ORDER BY MIN(STR_TO_DATE(Date, '%m/%d/%Y'));

SELECT
  MONTHNAME(STR_TO_DATE(Date, '%m/%d/%Y')) AS month_name,
  ROUND(SUM(Quantity), 2) AS total_quantity
FROM sales_2024
WHERE STR_TO_DATE(Date, '%m/%d/%Y') BETWEEN '2024-05-01' AND '2024-06-30'
  AND MONTH(STR_TO_DATE(Date, '%m/%d/%Y')) IN (5, 6)
GROUP BY MONTHNAME(STR_TO_DATE(Date, '%m/%d/%Y'))
ORDER BY MIN(STR_TO_DATE(Date, '%m/%d/%Y'));