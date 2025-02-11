# Sales Data Analysis using SQL

This project contains SQL queries and scripts to analyze grocery sales data from the **BlinkIT Grocery Dataset**. The analysis includes total sales, average sales, item counts, ratings, and various aggregations based on different criteria.

## 📌 Features
- **Data Cleaning**: Standardizing item fat content values.
- **Data Import**: Using `LOAD DATA INFILE` to import CSV data into MySQL.
- **Aggregations & Analysis**:
  - Total sales and average sales
  - Sales by item type and fat content
  - Sales by outlet location, size, and type
  - Sales trends by year
  - Percentage sales contribution by outlet size
  
## 🛠️ Setup Instructions

### Prerequisites
- MySQL Server 8.0+
- A dataset (`BlinkIT Grocery Data.csv`) placed in MySQL's secure file path

### Steps
1. **Create Database & Table**
```sql
CREATE DATABASE mayank;
USE mayank;

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
```

2. **Import Data**
```sql
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/BlinkIT Grocery Data.csv' 
INTO TABLE SalesData 
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n' 
IGNORE 1 LINES;
```

3. **Run Queries**
Use the provided SQL scripts to analyze the data:
```sql
SELECT item_fat_content, CAST(SUM(total_sales) AS DECIMAL(10,2)) AS total_sales FROM SalesData GROUP BY item_fat_content ORDER BY total_sales DESC;
```

## 📊 Key Insights
- Identifies best-selling products and categories.
- Helps understand store performance over different locations.
- Provides insights into customer preferences.

## 🏆 Contribution
Feel free to contribute to this project by optimizing queries or adding new analyses.

## 📄 License
This project is open-source under the MIT License.
