--STEP 1 — Understand columns 
--Date Columns: instance_date
--Location Columns: area_name_en (already Majan filtered),Property details,property_type_en,
--------------------property_sub_type_en,rooms_en,procedure_area (size sqm), has_parking
--Money columns: actual_worth → total property price --MAIN COLUMN, meter_sale_price → price per sqm
--Demand / transaction: transaction_id, procedure_name_en 

--STEP 2 — First filter ONLY sales
SELECT DISTINCT procedure_name_en
FROM majan_transactions

CREATE VIEW sales_data AS
SELECT *
FROM majan_transactions
WHERE procedure_name_en = 'Sell'
AND actual_worth > 0

--STEP 3 — TOTAL MARKET OVERVIEW (KPI)
--1️.Total transactions in Majan (2 yrs)
SELECT COUNT(*) AS total_transactions
FROM sales_data

--2.Total sales value in Majan
SELECT SUM(CAST(actual_worth AS DECIMAL(18,2))) AS total_sales_value
FROM sales_data;

--3.Average property price
WITH OrderedPrices AS (
    SELECT 
        actual_worth,
        ROW_NUMBER() OVER (ORDER BY actual_worth) AS rn,
        COUNT(*) OVER () AS total_rows
    FROM sales_data
)
SELECT 
    AVG(actual_worth) AS avg_price,
    AVG(actual_worth) AS median_price
FROM OrderedPrices
WHERE rn IN (
    (total_rows + 1) / 2,
    (total_rows + 2) / 2
)

--STEP 4 — PRICE TREND
--4. Monthly price trend
SELECT 
    DATEFROMPARTS(YEAR(instance_date), MONTH(instance_date), 1) AS month,
    COUNT(*) AS transactions,
    AVG(actual_worth) AS avg_price,
    AVG(meter_sale_price) AS avg_price_per_sqm
FROM sales_data
GROUP BY DATEFROMPARTS(YEAR(instance_date), MONTH(instance_date), 1)
ORDER BY month

--STEP 5 — PROPERTY TYPE ANALYSIS
--5. Which property type sells most?
SELECT 
    property_type_en,
    COUNT(*) AS transactions,
    AVG(CAST(actual_worth AS DECIMAL(18,2))) AS avg_price,
    AVG(meter_sale_price) AS price_per_sqm
FROM sales_data
GROUP BY property_type_en
ORDER BY transactions DESC

--6.Sub-type analysis (Studio / 1BR / 2BR)
SELECT 
    property_sub_type_en,
    COUNT(*) AS transactions,
    AVG(CAST(actual_worth AS DECIMAL(18,2))) AS avg_price
FROM sales_data
GROUP BY property_sub_type_en
ORDER BY transactions DESC

--STEP 6 — ROOM ANALYSIS
SELECT 
    rooms_en,
    COUNT(*) AS transactions,
    AVG(CAST(actual_worth AS DECIMAL(18,2))) AS avg_price
FROM sales_data
GROUP BY rooms_en
ORDER BY transactions DESC

--STEP 8 — PARKING IMPACT
SELECT 
    has_parking,
    COUNT(*) AS transactions,
    AVG(CAST(actual_worth AS DECIMAL(18,2))) AS avg_price
FROM sales_data
GROUP BY has_parking


--STEP 9 — PROJECT ANALYSIS (TOP BUILDINGS)
SELECT TOP 10
    project_name_en,
    COUNT(*) AS transactions,
    AVG(CAST(actual_worth AS DECIMAL(18,2))) AS avg_price
FROM sales_data
GROUP BY project_name_en
ORDER BY transactions DESC 

--STEP 10 — FINAL DATASET FOR POWER BI DASHBOARD
SELECT 
    DATEFROMPARTS(YEAR(instance_date), MONTH(instance_date), 1) AS month,
    property_type_en,
    rooms_en,
    has_parking,
    COUNT(*) AS transactions,
    AVG(CAST(actual_worth AS DECIMAL(18,2))) AS avg_price,
    AVG(CAST(meter_sale_price AS DECIMAL(18,2))) AS price_per_sqm
FROM sales_data
GROUP BY 
    DATEFROMPARTS(YEAR(instance_date), MONTH(instance_date), 1),
    property_type_en,
    rooms_en,
    has_parking
ORDER BY month