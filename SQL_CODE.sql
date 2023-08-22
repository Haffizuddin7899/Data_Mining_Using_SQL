--  Define meta data in mysql workbench or any other SQL too
CREATE DATABASE projectdb;
USE projectdb;
select *from online_retail;

-- 1. What is the distribution of order values across all customers in the dataset?
SELECT CustomerID, SUM(Quantity * UnitPrice) AS TotalOrderValue
FROM online_retail
GROUP BY CustomerID
ORDER BY TotalOrderValue DESC;

 -- How many unique products has each customer purchased?
SELECT CustomerID, COUNT(DISTINCT StockCode) AS UniqueProductsPurchased
FROM online_retail
GROUP BY CustomerID;

-- Which customers have only made a single purchase from the company?
SELECT CustomerID, COUNT(DISTINCT InvoiceNo) AS PurchaseCount
FROM online_retail
GROUP BY CustomerID
HAVING PurchaseCount = 1;

--   Which products are most commonly purchased together by customers in the dataset?
SELECT a.StockCode AS ProductA, b.StockCode AS ProductB, COUNT(*) AS PurchaseCount
FROM online_retail a
JOIN online_retail b ON a.InvoiceNo = b.InvoiceNo AND a.StockCode < b.StockCode
GROUP BY ProductA, ProductB
ORDER BY PurchaseCount DESC
LIMIT 10;

-- 1.      Customer Segmentation by Purchase Frequency
SELECT CustomerID, COUNT(DISTINCT InvoiceNo) AS PurchaseFrequency
FROM online_retail
GROUP BY CustomerID;

SELECT CustomerID,
       CASE
           WHEN PurchaseFrequency >= 10 THEN 'High'
           WHEN PurchaseFrequency >= 5 THEN 'Medium'
           ELSE 'Low'
       END AS FrequencySegment
FROM (
    SELECT CustomerID, COUNT(DISTINCT InvoiceNo) AS PurchaseFrequency
    FROM online_retail
    GROUP BY CustomerID
) AS PurchaseFrequencies;

-- 2. Average Order Value by Country
SELECT Country, AVG(Quantity * UnitPrice) AS AverageOrderValue
FROM online_retail
GROUP BY Country
ORDER BY AverageOrderValue DESC;

-- 3. Customer Churn Analysis
SELECT CustomerID
FROM online_retail
WHERE InvoiceDate <= DATE_SUB(NOW(), INTERVAL 6 MONTH)
GROUP BY CustomerID
HAVING MAX(InvoiceDate) < DATE_SUB(NOW(), INTERVAL 6 MONTH);

-- 4. Product Affinity Analysis
CREATE TEMPORARY TABLE ProductPairs AS
SELECT A.StockCode AS ProductA, B.StockCode AS ProductB
FROM online_retail A
JOIN online_retail B ON A.InvoiceNo = B.InvoiceNo AND A.StockCode < B.StockCode;

SELECT ProductA, ProductB, COUNT(*) AS Occurrences
FROM ProductPairs
GROUP BY ProductA, ProductB
ORDER BY Occurrences DESC;

SELECT
    pp.ProductA,
    pp.ProductB,
    COUNT(*) AS CommonOccurrences,
    COUNT(*) / (SELECT COUNT(*) FROM online_retail) AS JaccardSimilarity
FROM ProductPairs pp
GROUP BY pp.ProductA, pp.ProductB
ORDER BY CommonOccurrences DESC, JaccardSimilarity DESC;

-- 5. Time-based Analysis
SELECT
    YEAR(InvoiceDate) AS Year,
    MONTH(InvoiceDate) AS Month,
    SUM(Quantity) AS TotalQuantitySold
FROM online_retail
GROUP BY Year, Month
ORDER BY Year, Month;

SELECT
    YEAR(InvoiceDate) AS Year,
    QUARTER(InvoiceDate) AS Quarter,
    SUM(Quantity) AS TotalQuantitySold
FROM online_retail
GROUP BY Year, Quarter
ORDER BY Year, Quarter;

SELECT DISTINCT Country, UnitPrice
FROM online_retail;

SELECT *
FROM online_retail
WHERE online_retail.InvoiceNo and online_retail.StockCode and online_retail.Description and online_retail.Quantity 
and online_retail.InvoiceDate and online_retail.UnitPrice and online_retail.CustomerID and online_retail.Country IS NULL;

















