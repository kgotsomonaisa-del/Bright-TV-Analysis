Bright TV Data Analysis Project
Overview
This project focuses on cleaning and analysing customer data for Bright TV to improve data quality and extract meaningful insights.
Data Cleaning
Data was cleaned using SQL in Databricks:
•	Removed duplicates using window functions
•	Handled missing values using COALESCE
•	Standardized categorical variables (Gender, Province)
•	Validated emails and age ranges
•	Trimmed whitespace and corrected inconsistencies
Data Processing
•	Retrieved various information using SQL Code
•	Created new columns for day name, month name, day of month, age category, day of recording, and duration buckets
•	Converted time from UTC (Global time) to SAST (South African time)
Data Architecture
•	Bronze Layer: Raw data
•	Silver Layer: Cleaned data
•	Gold Layer: Analysis-ready dataset
Key Insights
•	Majority of users fall within the 25–40 age group
•	Some provinces had inconsistent naming (fixed during cleaning)
•	Missing demographic data was significant and addressed
Tools Used
•	SQL (Databricks)
•	Excel (data cleaning and visualisation)
•	Miro (Flow chart)
•	Canva (Presentation)

