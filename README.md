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
  SELECT (total_ratio/property_num) as ratio, town 
  FROM (
       SELECT SUM(sales_ratio) as total_ratio, COUNT(*) as property_num, town 
       FROM sales_listing GROUP BY town) 
  as ratio_table 
  GROUP BY town ORDER BY ratio DESC;
  ```
* The maximum sales ratio by property type is 2.31%% for Other, and 1.65% for Condo
  The minimum sales ratio by property type is 0.79% for Four Family
  ```
  SELECT (total_ratio/property_num) as ratio, property_type 
  FROM (
       SELECT SUM(sales_ratio) as total_ratio, COUNT(*) as property_num, property_type 
       FROM sales_listing GROUP BY property_type) 
  as ratio_table 
  GROUP BY property_type ORDER BY ratio DESC;
  ```
