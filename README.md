# COVID_19-ANALYSIS
COVID-19 Data Analysis using SQL and Python Analyzed COVID-19 datasets to extract key insights such as vaccination trends, test positivity rates, and state-wise performance. Used SQL for data aggregation and Python (Pandas, Matplotlib) for data cleaning and visualization. 

# Tools & Technologies Used
MySQL – Data querying and aggregation
Python (Pandas, Matplotlib) – Data cleaning & visualization
Jupyter Notebook – Analysis and workflow
Excel (optional) – Data preview and validation


# Project Files
covid.sql → SQL queries for analysis
covid_19.ipynb → Python analysis notebook
DATA IMPORTING + CLEANING.ipynb → Data cleaning process

ALL QUESTIONS 
## DATA UNDERSTANDING
Retrieve all records from COVID datasets
Identify column names and data types
Explore dataset structure
## DATA CLEANING (SQL + PYTHON)
Remove special characters from state names
Convert columns to correct data types
Handle missing values using fillna() / COALESCE()
Replace null values with 0
Convert date columns to proper format
Remove duplicate records

---------------------------------------------------------------------------

# BASIC ANALYSIS (SQL)#
Find top 5 states with highest confirmed cases
Find bottom 5 states with lowest deaths
Calculate total confirmed, recovered, and deaths per state
Count number of records per state
# DATA QUALITY CHECK#
Identify states where recovered cases exceed confirmed cases
Detect inconsistent or incorrect data entries
# RATE CALCULATIONS#
Calculate death rate per state
Calculate recovery rate per state
Identify states with death rate greater than 2%
# ADVANCED SQL ANALYSIS
Identify states with high testing but low cases
Calculate daily growth rate using window functions (LAG)
Compute 7-day increase in cases
Analyze testing vs confirmed cases trend
Calculate Test Positivity Rate (TPR)
Evaluate vaccination efficiency across states
Identify states with high cases and high vaccination

-------------------------------------------------------------------------------------------
# DATA JOINING
Join testing and vaccination datasets
Combine multiple tables for analysis
Avoid duplicate records during joins

# PYTHON (PANDAS) 
Load dataset using pandas
Check null values
Fill missing values
Group data by state and aggregate metrics
Sort data by values
Filter rows based on conditions
Drop duplicate records
Merge datasets

# DATA VISUALIZATION (PYTHON)
Create bar chart for top states by cases
Plot testing vs cases comparison
Customize charts (labels, titles, rotation)
Compare multiple variables in a single chart
Identify trends using visualizations


## Author

Lavnya Kashyap
📧 lavanyakashyap58@gmail.com
🔗 GitHub: https://github.com/lavanyakashyap58-ops
