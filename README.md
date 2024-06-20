# Real-Estate-Analysis

#### Dashboard Link: [Real Estate Dashboard](https://app.powerbi.com/groups/me/reports/5b5a03f7-0eb4-4ca1-80e7-a260f093843f/feae22694568776deefd?experience=power-bi)

### Problem Statement
Inspired by the [Real Estate Sales Dataset](https://www.kaggle.com/datasets/muhammadrizqi25/real-estate-fix-with-address) by Muhammad Rizqi on Kaggle, I turned the dataset into the data source for an imaginative real estate business problem. Here, I am in the role of a data analyst analyzing the data to report the revenue and loss on real estate business, and suggest data-driven future investment advice to the business team. 

### Problem Situation
The company I'm, a data analyst, decided to enter the real estate investment in Connecticut and wanted to know which area should they invest in to gain the most profit. Additionally, the business manager just obtained a real estate dataset from a trusted realtor in the state. The business team thus asked the analytic team to analyze the dataset and help them with making data-driven decision on the investment. In particular, they want to know:                                                                      
- Amount of houses being listed from 2009 to 2019
- Top 5 most profit area
- Top 5 least profit area
- Overall comparison between average sale amount vs. assessed amount based on the area and the house type

### Data Analysis Process
1. Step 1: Load the dataset into MySQL to analyze and inspect the data using SQL
2. Step 2: Inspect the dataset for abnormal data, mismatched calculation, and invalid value in the dataset
3. Step 3: Clean the dataset for accuracy and appropriate meter for latter analysis. This include convert appropriate data type for date_recorded and recalculate sales_ratio for accuracy
4. Step 4: Evaluate the dataset for maxima, minima, mean, and count of appropriate field
5. Step 5: Link the dataset to PowerBI to visualizing data
6. Step 6: Transform data and add on measure field for data visualization
7. Step 7: Build dashboard
8. Step 8: Report and suggest data-driven recommendation

### Data Analysis Report
#### Data Inspection 
##### Data Field Explanation
1. RowNum: Enumerate each row
2. Serial Number: The serial number being assigned to each property
3. Listing Year: The year the property being posted
4. Date Recorded: The date the property being recorded and added to the dataset
5. Town: The town the property is located
6. Home Address: The address of the property
7. Assessed Value: The assessed value of the property
8. Sale Amount: The sale value of the property when saled
9. Sales Ratio: The ratio between the sale amount and the assessed value
10. Property Type: The type of the property, which is one of the 5 types: Single Family, Two Family, Three Family, Four Family, Condo, and Other
11. Years Until Sold: This remains ambiguous due the lack of information on the data source description. However, I assumed that it is the number of year between the recorded year and the listing year

#### Data Overview
At first glance, this data includes:
* 168 distinct towns in the dataset
  ```
  SELECT COUNT(DISTINCT town) FROM sales_listing;
  ```
  
* 5 property types: Single Family, Two Family, Three Family, Four Family, Condo, and Other
  ```
  SELECT COUNT(DISTINCT property_type) FROM sales_listing;
  ```
  For each property, we have the number of listings as followed:
    * Four Family property type has 173 listings
    * Three Family property type has 1160 listings
    * Two Family property type has 2096 listings
    * Single Family propoerty type has 26203 listings
    * Condo property type has 7699 listings
    * Other property type has 3945 listings
  ```
  SELECT COUNT(*) as typeNum, property_type FROM sales_listing GROUP BY property_type ORDER BY typeNum;
  ```
* The maximum sales ratio by town is 7.18% in Morris, CT
  The minimum sales ratio by town is 0.79%  in Woodbridge, CT
  ```
  SELECT (total_ratio/property_num) AS ratio, town 
  FROM (
       SELECT SUM(sales_ratio) AS total_ratio, COUNT(*) AS property_num, town 
       FROM sales_listing GROUP BY town) 
  AS ratio_table 
  GROUP BY town ORDER BY ratio DESC;
  ```
* The maximum sales ratio by property type is 2.31%% for Other, and 1.65% for Condo
  The minimum sales ratio by property type is 0.79% for Four Family
  ```
  SELECT (total_ratio/property_num) AS ratio, property_type 
  FROM (
       SELECT SUM(sales_ratio) AS total_ratio, COUNT(*) AS property_num, property_type 
       FROM sales_listing GROUP BY property_type) 
  AS ratio_table 
  GROUP BY property_type ORDER BY ratio DESC;
  ```
* There is no null or missing value in the dataset. This was verified by checking valid assessed amount and sale amount (non-negative value and non-null value) and assessing non-null value in every column
  ```
  # Proceed for all column name in the table
  SELECT [column_name] FROM sales_listing WHERE [column_name] IS NULL;

  SELECT * FROM sales_listing WHERE assessed_amount < 0;
  SELECT * FROM sales_listing WHERE sale_amount < 0;
  ```
Noticable problem within the dataset:
* The sales_ratio in the original dataset was miscalculated - the value was calculated by assessed_amount / sales_amount. The addressed this problem, I drop the column and add a new column for the sales_ratio where the value is sales_amount / assessed_amount
  ```
  ALTER TABLE sales_listing DROP COLUMN sales_ratio;
  ALTER TABLE sales_listing ADD sales_ratio NUMERIC(20, 4) GENERATED ALWAYS AS (sale_amount/assessed_value);
  ```
* There is an imbalanced number of report for house listing in 2009 and 2010 compared to other years (2011 - 2019). In particular, there are 35179 listings in 2009 and 5295 listings in 2010, while there are less than 200 listings in the remaining years (2011 - 2019)
  ```
  SELECT COUNT(*) AS total, list_year FROM sales_listing GROUP BY list_year;
  ```
  ![image](https://github.com/ThuyenP/Real-Estate-Analysis/assets/57400761/a73a2018-ec9f-447c-a1f0-a9695f8b83d3)
  
  This could lead to inaccurate analysis and report. My recommendation is discussing this with the business team and the realtor from whom the dataset was obtained. Meanwhile, I would proceed the analysis with only years from 2011 to 2019 to avoid skewed visualization and inaccuracy.
  
* There are areas that have less than 10 listings while some areas have more than 200 listings. This could also a potential reason that leads to skwed visualizationa dn inaccuracy in analysis.
  ```
  SELECT COUNT(property_type) AS total_prop, town FROM sales_listing GROUP BY town ORDER BY total_prop;
  ```

#### PowerBI Dashboard
1. Step 1: Create Listing Trend for Housing by Year sarting from 2011 to 2019
   ![image](https://github.com/ThuyenP/Real-Estate-Analysis/assets/57400761/cb763f6f-ae3d-4f99-9635-afb229bf2c24)
   

2. Step 2: Create line and clustered column chart to compare average assessed value with average sale value by property type and visualize the average sale ratio for each property type
   ![image](https://github.com/ThuyenP/Real-Estate-Analysis/assets/57400761/df17c3c8-55fb-4597-ad7d-61cd406fa95f)

3. Step 3: Create clustered bar chart to compare average assessed value with average sale value by town
   ![image](https://github.com/ThuyenP/Real-Estate-Analysis/assets/57400761/561a59f0-40da-4d89-b905-de6288177188)




