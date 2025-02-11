-- Step 1: Create and Use Database
CREATE DATABASE mayank;  -- Creates a database named "mayank"
USE mayank;  -- Switches to using the "mayank" database

-- Step 2: Create SalesData Table
CREATE TABLE SalesData (
    Item_Fat_Content VARCHAR(50),
    Item_Identifier VARCHAR(50),
    Item_Type VARCHAR(100),
    Outlet_Establishment_Year INT,
    Outlet_Identifier VARCHAR(50),
    Outlet_Location_Type VARCHAR(100),
    Outlet_Size VARCHAR(50),
    Outlet_Type VARCHAR(100),
    Item_Visibility DOUBLE,
    Item_Weight DOUBLE DEFAULT NULL,
    Total_Sales DOUBLE,
    Rating INT
);

-- Step 3: Drop Table (Caution: This deletes the table)
DROP TABLE SalesData;

-- Step 4: Check the Data and Secure File Path
SELECT * FROM SalesData;  -- View all records from SalesData
SELECT @@secure_file_priv;  -- Check the directory allowed for file imports
SHOW VARIABLES LIKE 'secure_file_priv';  -- Alternative way to check secure file path

-- Step 5: Load Data from CSV File into Table
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/BlinkIT Grocery Data.csv'
INTO TABLE SalesData
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(Item_Fat_Content, Item_Identifier, Item_Type, Outlet_Establishment_Year, Outlet_Identifier, Outlet_Location_Type, Outlet_Size, Outlet_Type, Item_Visibility, @Item_Weight, Total_Sales, Rating)
SET Item_Weight = CASE 
    WHEN @Item_Weight REGEXP '^[0-9.]+$' THEN @Item_Weight
    ELSE NULL
END;

-- Step 6: Normalize Data (Fix Inconsistent Values)
UPDATE SalesData
SET Item_Fat_Content = 
CASE 
    WHEN Item_Fat_Content IN ('LF', 'low fat') THEN 'Low fat'
    WHEN Item_Fat_Content = 'reg' THEN 'Regular'
    ELSE Item_Fat_Content 
END;

-- Step 7: Disable Safe Update Mode (Allows Updating Without Primary Key)
SET SQL_SAFE_UPDATES = 0;

-- Step 8: Basic Queries
SELECT DISTINCT Item_Fat_Content FROM SalesData;  -- Get unique values in Item_Fat_Content
SELECT * FROM SalesData;  -- View all records

-- Step 9: Sales & Statistics Queries
SELECT CAST(SUM(Total_Sales)/1000000 AS DECIMAL(10,2)) AS total_sales_millions FROM SalesData;
SELECT CAST(AVG(Total_Sales) AS DECIMAL(10,0)) AS avg_sales FROM SalesData;
SELECT COUNT(*) AS no_of_Items FROM SalesData;

-- Step 10: Year-Specific Analysis (For Year 2022)
SELECT CAST(SUM(Total_Sales)/1000000 AS DECIMAL(10,2)) AS total_sales_millions FROM SalesData WHERE Outlet_Establishment_Year = 2022;
SELECT CAST(AVG(Total_Sales) AS DECIMAL(10,0)) AS avg_sales FROM SalesData WHERE Outlet_Establishment_Year = 2022;
SELECT COUNT(*) AS no_of_Items FROM SalesData WHERE Outlet_Establishment_Year = 2022;
SELECT CAST(AVG(Rating) AS DECIMAL(10,2)) AS Avg_rating FROM SalesData;

-- Step 11: Grouped Analysis by Item Fat Content
SELECT Item_Fat_Content, 
       CAST(SUM(Total_Sales) AS DECIMAL(10,2)) AS total_sales,
       CAST(AVG(Total_Sales) AS DECIMAL(10,0)) AS avg_sales,
       COUNT(*) AS no_of_Items,
       CAST(AVG(Rating) AS DECIMAL(10,2)) AS Avg_rating
FROM SalesData
WHERE Outlet_Establishment_Year = 2020
GROUP BY Item_Fat_Content
ORDER BY total_sales DESC;

-- Step 12: Grouped Analysis by Item Type
SELECT Item_Type, 
       CAST(SUM(Total_Sales) AS DECIMAL(10,2)) AS total_sales,
       CAST(AVG(Total_Sales) AS DECIMAL(10,0)) AS avg_sales,
       COUNT(*) AS no_of_Items,
       CAST(AVG(Rating) AS DECIMAL(10,2)) AS Avg_rating
FROM SalesData
WHERE Outlet_Establishment_Year = 2020
GROUP BY Item_Type
ORDER BY total_sales DESC;

-- Step 13: Sales and Rating by Outlet Location and Item Fat Content
SELECT Outlet_Location_Type, Item_Fat_Content, 
       CAST(SUM(Total_Sales) AS DECIMAL(10,2)) AS total_sales,
       CAST(AVG(Total_Sales) AS DECIMAL(10,1)) AS avg_sales,
       COUNT(*) AS no_of_Items,
       CAST(AVG(Rating) AS DECIMAL(10,2)) AS Avg_rating
FROM SalesData
GROUP BY Outlet_Location_Type, Item_Fat_Content
ORDER BY total_sales DESC;

-- Step 14: Pivoted Sales by Outlet Location Type
SELECT Outlet_Location_Type,
       CAST(SUM(CASE WHEN Item_Fat_Content = 'Low Fat' THEN Total_Sales ELSE 0 END) AS DECIMAL(10,2)) AS Low_Fat,
       CAST(SUM(CASE WHEN Item_Fat_Content = 'Regular' THEN Total_Sales ELSE 0 END) AS DECIMAL(10,2)) AS Regular
FROM SalesData
GROUP BY Outlet_Location_Type
ORDER BY Outlet_Location_Type;

-- Step 15: Yearly Sales Performance
SELECT Outlet_Establishment_Year, 
       CAST(SUM(Total_Sales) AS DECIMAL(10,2)) AS total_sales,
       CAST(AVG(Total_Sales) AS DECIMAL(10,1)) AS avg_sales,
       COUNT(*) AS no_of_Items,
       CAST(AVG(Rating) AS DECIMAL(10,2)) AS Avg_rating
FROM SalesData
GROUP BY Outlet_Establishment_Year
ORDER BY Outlet_Establishment_Year ASC;

-- Step 16: Sales Distribution by Outlet Size
SELECT Outlet_Size, 
       CAST(SUM(Total_Sales) AS DECIMAL(10,2)) AS Total_Sales,
       CAST((SUM(Total_Sales) * 100.0 / SUM(SUM(Total_Sales)) OVER()) AS DECIMAL(10,2)) AS Sales_Percentage
FROM SalesData
GROUP BY Outlet_Size
ORDER BY Total_Sales DESC;

-- Step 17: Sales and Rating by Outlet Location
SELECT Outlet_Location_Type, 
       CAST(SUM(Total_Sales) AS DECIMAL(10,2)) AS total_sales,
       CAST(AVG(Total_Sales) AS DECIMAL(10,1)) AS avg_sales,
       COUNT(*) AS no_of_Items,
       CAST(AVG(Rating) AS DECIMAL(10,2)) AS Avg_rating
FROM SalesData
GROUP BY Outlet_Location_Type
ORDER BY total_sales DESC;

-- Step 18: Sales and Rating by Outlet Type
SELECT Outlet_Type, 
       CAST(SUM(Total_Sales) AS DECIMAL(10,2)) AS total_sales,
       CAST(AVG(Total_Sales) AS DECIMAL(10,1)) AS avg_sales,
       COUNT(*) AS no_of_Items,
       CAST(AVG(Rating) AS DECIMAL(10,2)) AS Avg_rating
FROM SalesData
GROUP BY Outlet_Type
ORDER BY total_sales DESC;
