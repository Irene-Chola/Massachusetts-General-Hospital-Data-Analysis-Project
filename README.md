# Massachusetts General Hospital Data Analysis Project
## Project Overview
This comprehensive data analysis project examines Electronic Health Records (EHR) data from Massachusetts General Hospital to uncover critical insights about healthcare utilization patterns, demographic disparities, and revenue optimization opportunities across Massachusetts healthcare facilities.


----

## Table of Contents

[Project Hypotheses](#project-hypotheses)

[Dataset Overview](dataset-overview)

[Tools](#tools)

[Data Cleaning and Preparation](#data-cleaning-and-preparation)

[Data Analysis](#data-analysis)

[Interactive Dashboards](interactive-dashboards)

[Critical Findings](#critical-findings)

[Recommendations](#recommendations)

[Key Achievements](#key-achievements)

[References](#references)
  

----

## Project Hypotheses

-H1: Revenue differences between affluent vs. low-income areas

-H2: Utilization rates: Urban vs. rural healthcare facilities

-H3: Healthcare coverage correlation with race

-H4: Gender-based healthcare coverage disparities

  ------

## Dataset Overview
#### Core Tables

| Table | Records | Description |
|-------|---------|-------------|
| Patients | 117,804 | Patient demographics and medical history |
| Encounters | 1,293,329 | Hospital visits and treatment details |
| Providers | 8,491 | Healthcare provider information |
| Payers | 23 | Insurance provider details |
| Organizations | 87 | Healthcare facility information |
| Payer Transitions | 145,321 | Insurance coverage changes |



You can find full dataset used here - [Dataset](https://github.com/Irene-Chola/Massachusetts-General-Hospital-Data-Analysis-Project/blob/main/MGHExcel.Dashboard.jpeg) 
   
-----
## Tools
-Data Cleaning: Alteryx Designer, Python, Excel

-Database: MySQL Workbench

-Analytics: MySQL Workbench

-Visualization: Tableau, Excel Dashboards


-----
## Data Cleaning and Preparation
A comprehensive multi-stage data cleaning pipeline was implemented to ensure data quality and analytical reliability across all datasets. The process involved systematic validation, transformation, and standardization of healthcare records.

-Missing Values: 12.3% across all datasets

-Duplicate Records: 847 duplicate patient entries identified

-Data Type Inconsistencies: 23 fields requiring type conversion

-Format Standardization: Names, dates, and categorical variables needed normalization 

**Alteryx Designer**

**Key Transformations:**

-Data Type Optimization: Converted 23 fields to appropriate data types (dates, integers, strings)

-String Cleaning: Removed special characters and standardized patient names using regex patterns


**Python**

**Age Calculation**
```
python# Age Calculation Logic
def calculate_age(birth_date, encounter_date):
    """Calculate patient age at time of encounter"""
    if pd.isna(birth_date) or pd.isna(encounter_date):
        return None
    
    age = (encounter_date - birth_date).days // 365.25
    return int(age) if age >= 0 else None

# Applied to 117,804 patient records
df['patient_age'] = df.apply(lambda row: calculate_age(
    row['birth_date'], row['encounter_date']), axis=1)

```


**Excel Power Query**

**Data Integration and Enrichment**

Master Workbook Structure:

├── Patients (Primary)      → 117,804 records

├── Encounters (Fact)       → 1,293,329 records  

├── Providers (Dimension)   → 8,491 records

├── Payers (Dimension)      → 23 records

├── Organizations (Dim)     → 87 records

├── Payer_Transitions       → 145,321 records


## Data Analysis 
----
### Key SQL Queries

**1. Age Group Classification**
```S\select concat(FIRST_NAME, ' ', LAST_NAME) Full_Name, AGE,
CASE
    WHEN AGE >= 0 AND AGE <= 3 THEN 'Baby'
    WHEN AGE > 3 AND AGE <= 8 THEN 'Todler'
    WHEN AGE > 8 AND AGE <= 18 THEN 'Minor'
    WHEN AGE > 18 AND AGE <= 35 THEN 'Young Adult'
    WHEN AGE > 35 AND AGE <= 55 THEN 'Senior Adult'
    WHEN AGE > 55 AND AGE <= 70 THEN 'Upper Middle Age'
    WHEN AGE > 70 THEN 'Senior Citizen'
END AS AGE_GROUP
FROM mghmedicaldata.patients
ORDER BY Full_Name;
```

**2. Patient's Data Retrieaval using a Stored Procedure**

```
delimiter $$

CREATE PROCEDURE mghmedicaldata.Insurance_Provider(IN Insurer_Name TEXT)
BEGIN
  SELECT  PD.NAME Name_of_Insurer, P.FIRST_NAME, P.LAST_NAME, PT.START_YEAR, PT.END_YEAR, PT.YEARS_COVERED, PT.OWNERSHIP, PD.AMOUNT_COVERED, PD.AMOUNT_UNCOVERED
  FROM patients P
  JOIN mghmedicaldata.payer_transitions PT
  ON P.Id = PT.PATIENT
  JOIN payers PD
  ON PT.PAYER = PD.Id
        
WHERE PD.NAME = Insurer_Name;
END $$ 
```
**3. Revenue Analysis by Encounter Class**
```
SELECT ENCOUNTER_CLASS, count(Id) TOTAL_ENCOUNTERS, round(sum(BASE_ENCOUNTER_COST),2) TOTAL_ENCOUNTER_COST
FROM mghmedicaldata.encounters
GROUP BY ENCOUNTER_CLASS;
````
Here is a list a comprehensive list of queries that was used for data analysis

[SQL Queries and stored Procedures](https://github.com/Irene-Chola/Massachusetts-General-Hospital-Data-Analysis-Project/blob/main/Consolidatedqueries.sql)

----
## Interactive Dashboards
**Tableau Public Visualization**

•	Geographic heat maps of healthcare utilization

•	Time series analysis of encounter trends

•	Demographic disparity visualizations

[Tableau Dashboard](https://public.tableau.com/app/profile/irene.chola/viz/MGHmedicalDataDashboard/Dashboard1?publish=yes)


**Revenue Analytics Excel Dashboard featuring:**

•	Real-time financial performance metrics

•	Geographic revenue distribution

•	Patient demographic breakdowns

•	Utilization rate comparisons

[Excel Dashboard](https://github.com/Irene-Chola/Massachusetts-General-Hospital-Data-Analysis-Project/blob/main/MGHExcel.Dashboard.jpeg)


## Critical Findings

| Finding | Impact | 
|---------|--------|
| 68% of patients lack adequate coverage | $41B in uncovered expenses |
| Urban vs Rural revenue gap: 3:1 | Underserved rural populations | 
| Male coverage advantage: 23% | Gender-based healthcare inequality | 
| White patients: 74% of covered | Racial healthcare disparities | 
| COVID-19 encounter spike: 156% | Healthcare system strain | 
---

## Recommendations
### Strategic Initiatives

**1. Healthcare Equity Program**

  -Implement targeted outreach for underserved communities
  -Expand Medicaid eligibility and coverage options
  -Develop culturally competent care programs


**2. Rural Healthcare Expansion**

  -Deploy mobile health clinics in underserved areas
  -Establish telemedicine infrastructure
  -Create partnerships with rural community centers


**3. Revenue Optimization**

  -Develop value-based care contracts
  -Implement predictive analytics for resource allocation
  -Create specialized programs for high-revenue demographics
  
----
## Key Achievements

-Analyzed 1.3M+ patient encounters across Massachusetts healthcare facilities

-Identified $41B in uncovered healthcare expenses requiring strategic intervention

-Discovered significant demographic disparities in healthcare access and coverage



-----
## References
[Massachusetts General Hospital](http://massgeneral.org/about/)   

