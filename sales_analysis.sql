-- Describe the overall dataset
DESC sales_listing;
SELECT * FROM sales_listing;

-- Check for null value in the dataset
SELECT list_year FROM sales_listing WHERE list_year IS NULL;
SELECT date_recorded FROM sales_listing WHERE date_recorded IS NULL;
SELECT town FROM sales_listing WHERE town IS NULL;
SELECT address FROM sales_listing WHERE address IS NULL;
SELECT assessed_value FROM sales_listing WHERE assessed_value IS NULL;
SELECT sale_amount FROM sales_listing WHERE sale_amount IS NULL;
SELECT property_type FROM sales_listing WHERE property_type IS NULL;
SELECT years_until_sold FROM sales_listing WHERE years_until_sold IS NULL;
SELECT sales_ratio FROM sales_listing WHERE sales_ratio IS NULL;

-- Check for invalid assessed amount and sale amount 
SELECT * FROM sales_listing WHERE assessed_amount < 0;
SELECT * FROM sales_listing WHERE sale_amount < 0;

-- Drop unnecessary columns and the miscalculated column (sales_ratio)
ALTER TABLE sales_listing DROP COLUMN MyUnknownColumn;
ALTER TABLE sales_listing DROP COLUMN serial_number;
ALTER TABLE sales_listing DROP COLUMN sales_ratio;

-- Add in the new correct sales_ratio column
ALTER TABLE sales_listing ADD sales_ratio NUMERIC(20, 4) generated always AS (sale_amount/assessed_value);

-- Convert the data type of recorded_date from text to date
ALTER TABLE sales_listing ADD recorded_date DATE GENERATED ALWAYS AS (STR_TO_DATE(date_recorded, '%d/%m/%Y'));

-- Inspect and evaluate data
SELECT COUNT(DISTINCT town) FROM sales_listing;
SELECT COUNT(*), list_year FROM sales_listing GROUP BY list_year;
SELECT COUNT(*) AS total_listings, town FROM sales_listing GROUP BY town ORDER BY town;
SELECT COUNT(DISTINCT property_type) FROM sales_listing;
SELECT COUNT(*) AS typeNum, property_type FROM sales_listing GROUP BY property_type ORDER BY typeNum;
SELECT COUNT(*) as total, list_year FROM sales_listing GROUP BY list_year;
SELECT COUNT(property_type) as total_prop, town FROM sales_listing GROUP BY town ORDER BY total_prop;

SELECT (total_ratio/property_num) AS ratio, town 
FROM (
    SELECT SUM(sales_ratio) AS total_ratio, COUNT(*) AS property_num, town 
    FROM sales_listing GROUP BY town) 
AS ratio_table 
GROUP BY town ORDER BY ratio DESC;

SELECT (total_ratio/property_num) AS ratio, property_type 
FROM (
    SELECT SUM(sales_ratio) AS total_ratio, COUNT(*) AS property_num, property_type 
    FROM sales_listing GROUP BY property_type) 
AS ratio_table 
GROUP BY property_type ORDER BY ratio DESC;