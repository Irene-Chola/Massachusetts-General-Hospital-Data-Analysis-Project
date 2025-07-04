
-- Use wild card to get all the emergency encounters 
SELECT P.FIRST_NAME, P.LAST_NAME, E.`ENCOUNTER_DURATION(MINS)`, E.ENCOUNTER_CLASS, E.TOTAL_CLAIM_COST, E.PAYER_COVERAGE 
FROM  mghmedicaldata.encounters E
JOIN patients p
ON P.Id = E.PATIENT
WHERE  DESCRIPTION
LIKE '%emergency%';

-- Count of encounters by enounter class and their total cost of enounters for each enounter class

select ENCOUNTER_CLASS, count(Id) TOTAL_ENCOUNTERS, round(sum(BASE_ENCOUNTER_COST),2) TOTAL_ENCOUNTER_COST
from mghmedicaldata.encounters
group by ENCOUNTER_CLASS;

#Calculate average Payer Coverage 
SELECT AVG(YEARS_COVERED) avg_Payer_coverage
FROM mghmedicaldata.payer_transitions;


#Identify Most Common Encounter Codes
SELECT CODE, DESCRIPTION, COUNT(*) AS code_count
FROM mghmedicaldata.encounters
GROUP BY CODE, DESCRIPTION
ORDER BY code_count DESC
LIMIT 5;  # Minimum of 5




#Identify Most Common Encounter Codes
SELECT CODE, DESCRIPTION, COUNT(*) AS code_count
FROM mghmedicaldata.encounters
GROUP BY CODE, DESCRIPTION
ORDER BY code_count DESC
LIMIT 5; -- Limiting to top 5 most common codes

#Calculate averag payer Coverage 
SELECT AVG(PAYER_COVERAGE) AS average_payer_coverage
FROM mghmedicaldata.encounters;

 #Find Encounters with High encounter duration
SELECT *
FROM mghmedicaldata.encounters
WHERE `ENCOUNTER_DURATION(MINS)` > 1000;

#Count Encounters by Encounter Class
SELECT ENCOUNTER_CLASS, COUNT(*) AS encounter_count
FROM mghmedicaldata.encounters
GROUP BY ENCOUNTER_CLASS
ORDER BY ENCOUNTER_COUNT DESC;

#Calculate Average Encounter Duration
SELECT round(AVG(`ENCOUNTER_DURATION(MINS)`)) AS average_duration
FROM mghmedicaldata.encounters;


 #Calculate Total Revenue and Percentage of Amount Covered
SELECT NAME,REVENUE,AMOUNT_COVERED,AMOUNT_UNCOVERED,
(AMOUNT_COVERED / (AMOUNT_COVERED + AMOUNT_UNCOVERED)) * 100 AS percentage_covered
FROM mghmedicaldata.payers;

#Identify Insurance companies with High Revenue
SELECT NAME,REVENUE
FROM mghmedicaldata.payers
WHERE REVENUE > 1000000
ORDER BY REVENUE DESC;


 #List Organizations with Most Covered Encounters
SELECT NAME, COVERED_ENCOUNTERS
FROM mghmedicaldata.payers
ORDER BY COVERED_ENCOUNTERS DESC;

#Calculate Average Member Months by City
SELECT CITY, round(AVG(MEMBER_MONTHS)) AS average_member_months
FROM mghmedicaldata.payers
GROUP BY CITY;

#Identify Insurance companies  with High Percentage of Covered Procedures
SELECT NAME, round((COVERED_PROCEDURES / (COVERED_PROCEDURES + UNCOVERED_PROCEDURES)) * 100) AS percentage_covered_procedures
FROM mghmedicaldata.payers
ORDER BY percentage_covered_procedures DESC;

#Count Providers by Gender and Speciality
SELECT GENDER, SPECIALITY, COUNT(*) AS provider_count
FROM mghmedicaldata.providers
GROUP BY GENDER, SPECIALITY
ORDER BY provider_count DESC;


#Find Providers in a Specific city
SELECT *
FROM mghmedicaldata.providers
WHERE CITY = 'Boston';  # you can use any city of interest


#Identify Providers with High Utilization
SELECT NAME,UTILIZATION
FROM mghmedicaldata.providers
WHERE UTILIZATION > 1000
ORDER BY UTILIZATION DESC;

#List Top Utilizing Providers
SELECT NAME,UTILIZATION
FROM mghmedicaldata.providers
ORDER BY UTILIZATION DESC;

#Calculate sum of Utilization by Speciality
SELECT SPECIALITY, sum(UTILIZATION) AS average_utilization
FROM mghmedicaldata.providers
GROUP BY SPECIALITY
ORDER BY average_utilization DESC;


#Find Providers in a Specific City and Speciality # STORED PROCEDURE
SELECT *
FROM mghmedicaldata.providers
WHERE CITY = 'Boston'     # Replace with any City
  AND SPECIALITY = 'General Practice';  #Replace with any Speciality

#List Providers Ordered by Name
SELECT *
FROM mghmedicaldata.providers
ORDER BY NAME;

-- The number of providers we have for each speciality

SELECT SPECIALITY, count(*) NUMBER
FROM mghmedicaldata.providers
GROUP BY SPECIALITY 
ORDER BY NUMBER desc;

-- Extract details of each provider and their speciality

SELECT p.NAME, p.GENDER, p.SPECIALITY, o.HOSPITAL_NAME
FROM mghmedicaldata.providers p
JOIN mghmedicaldata.organizations O
ON O.Id = P.ORGANIZATION
ORDER BY name asc;

-- Total utilization of providers by their speciality

select count(*) Count, SPECIALITY, sum(UTILIZATION) TOTAL_UTILIZATION
from mghmedicaldata.providers
group by SPECIALITY;

-- Number of providers by gender

select gender, count(*) total 
from mghmedicaldata.providers
group by GENDER;


-- Query to group patients into different age categories 
select concat(FIRST_NAME, ' ', LAST_NAME) Full_Name, AGE,
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

#Search for Individuals by Name 
SELECT *
FROM mghmedicaldata.patients
WHERE FIRST_NAME = 'Jimmie'  # Replace with any other first name and last name
AND LAST_NAME = 'Harris';
   

#Count patients by Gender
SELECT GENDER PATIENT_GENDER, COUNT(*) AS count
FROM mghmedicaldata.patients
GROUP BY GENDER;

#patients with health coverage
SELECT *
FROM mghmedicaldata.patients
WHERE HEALTHCARE_COVERAGE > 0;

#patients without health coverage
SELECT *
FROM mghmedicaldata.patients
WHERE HEALTHCARE_COVERAGE <= 0;


#Calculate Average Age of patients
SELECT round(AVG(AGE)) AS average_age
FROM mghmedicaldata.patients ;


-- Patients count by race and their total health care expenses and health care coverage

select RACE, count(*) TOTAL, round(sum(HEALTHCARE_EXPENSES)) HEALTH_CARE_EXPENSE, round(sum(HEALTHCARE_COVERAGE)) HEALTH_CARE_COVERAGE
from mghmedicaldata.patients
group by RACE;





