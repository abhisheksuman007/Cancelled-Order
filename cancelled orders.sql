select `Cancellation Mode` ,`Reason of Rejection`,count(*) As Observations from cancelled_orders group by `Cancellation Mode`,`Reason of Rejection` order by Observations desc;

desc cancelled_orders;

SELECT  STR_TO_DATE(`Order Date`, '%Y-%m-%d') from cancelled_orders;

SELECT
 	c.`Restaurant ID`,
 	p.`Product ID`,
	p.`Product Name`,
     COUNT(*) AS cancellation_count
FROM cancelled_orders c
JOIN product_details p ON c.`Order ID` = p.`Order ID`
GROUP BY c.`Restaurant ID`,p.`Product ID`,p.`Product Name`
ORDER BY cancellation_count DESC
LIMIT 10;

SELECT
    c.`Restaurant ID`,
    p.`Product Name`,
    COUNT(*) AS cancellation_count
FROM cancelled_orders c
JOIN product_details p ON c.`Order ID` = p.`Order ID`
WHERE `Cancellation Mode` = 'Cancelled by Restaurant'
GROUP BY c.`Restaurant ID`, p.`Product Name`
ORDER BY cancellation_count DESC;

SELECT
    c.`Restaurant ID`,
    p.`Product Name`,
    COUNT(*) AS cancellation_count
FROM cancelled_orders c
JOIN product_details p ON c.`Order ID` = p.`Order ID`
WHERE `Cancellation Mode` = 'Order cancelled through app'
GROUP BY c.`Restaurant ID`, p.`Product Name`
ORDER BY cancellation_count DESC;

SELECT
    c.`Restaurant ID`,
    COUNT(*) AS total_cancellations,
    (COUNT() * 100.0 / (SELECT COUNT() FROM cancelled_orders WHERE `Cancellation Mode` = 'Order cancelled through app')) AS cancellation_percentage
FROM cancelled_orders
WHERE `Cancellation Mode` = 'Order cancelled through app'
GROUP BY `Restaurant ID`
ORDER BY cancellation_percentage DESC
limit 10;

SELECT
    p.`Is Packaged Item?`, p.`Is Buffet Item?`,
    COUNT(*) AS cancellation_count
FROM cancelled_orders c
JOIN product_details p ON c.`Order ID` = p.`Order ID`
-- GROUP BY p.`Is Packaged Item?`, p.`Is Buffet Item?`;

SELECT
    HOUR(`Updated Order Time`) AS order_hour,
    COUNT(*) AS cancellation_count
FROM cancelled_orders
GROUP BY order_hour
ORDER BY cancellation_count DESC
limit 10;

SELECT
	`Restaurant ID`,
    `Product Name`,
    `Reason of Rejection`,
    COUNT(*) AS cancellation_count
FROM cancelled_orders c
JOIN product_details p ON c.`Order ID` = p.`Order ID`
WHERE p.`Product ID` in (select distinct `Product ID` from product_details) and `Reason of Rejection`!="Customer Refusal"
GROUP BY `Restaurant ID`,`Product Name`,`Reason of Rejection`
ORDER BY cancellation_count DESC;

SELECT
    c.`Restaurant ID`,
    SUM(`Total Value` * `Quantities Ordered`) AS selling_potential
FROM cancelled_orders c
JOIN product_details p ON c.`Order ID` = p.`Order ID`
GROUP BY c.`Restaurant ID`
order by selling_potential desc
limit 10;

SELECT 
	AVG(CASE WHEN pd.`Is Buffet Item?` = 'Yes' THEN 1 ELSE 0 END) AS Avg_Buffet_Cancellation_Rate,
	AVG(CASE WHEN pd.`Is Packaged Item?` = 'Yes' THEN 1 ELSE 0 END) AS Avg_Packaged_Cancellation_Rate,
    AVG(CASE WHEN pd.`Is Packaged Item?` = 'Yes' and pd.`Is Buffet Item?` = 'Yes' THEN 1 ELSE 0 END) AS Avg_BothCancellation_Rate
FROM cancelled_orders co
JOIN product_details pd ON co.`Order ID` = pd.`Order ID`;