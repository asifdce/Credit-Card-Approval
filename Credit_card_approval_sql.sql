                                                -- Credit Card Approval Prediction
                                                
create database credit_card_approval;

use credit_card_approval;

SELECT * FROM credit_card_approval_cleaned;

-- (1) Group the customers based on their income type and find the average of their annual income.
SELECT Type_Income, AVG(Annual_income) AS average_annual_income
FROM credit_card_approval_cleaned
GROUP BY Type_Income;

-- (2) Find female owners of cars  and property.
SELECT Ind_ID
FROM credit_card_approval_cleaned
WHERE Car_Owner = 'Y' AND Propert_Owner = 'Y'
    AND GENDER = 'F';
    
-- (3) Find the male customers who are staying with their families.
SELECT *
FROM credit_card_approval_cleaned
WHERE GENDER = 'M' AND Housing_type = 'With parents';

-- (4) Find the top 5 people having the highest income.
SELECT *
FROM credit_card_approval_cleaned
ORDER BY Annual_income DESC
LIMIT 5;

-- OR
SELECT *
FROM (
    SELECT *,
           ROW_NUMBER() OVER (ORDER BY Annual_income DESC) AS row_num
    FROM credit_card_approval_cleaned
) AS ranked
WHERE row_num <= 5;

-- OR
WITH ranked AS (
    SELECT *,
           ROW_NUMBER() OVER (ORDER BY Annual_income DESC) AS row_num
    FROM credit_card_approval_cleaned
)
SELECT *
FROM ranked
WHERE row_num <= 5;

-- (5) What is the total count of highest education level ?
SELECT COUNT(*) as Total_Count
FROM credit_card_approval_cleaned
WHERE EDUCATION = 'Academic degree';

-- (6) Between married males and females, who is having more average income ?
SELECT GENDER, AVG(Annual_income) AS average_annual_income
FROM credit_card_approval_cleaned
WHERE Marital_status = 'Married'
GROUP BY GENDER;

-- (7) Find the count of approved and rejected applicants.
SELECT label, COUNT(*) AS count
FROM credit_card_approval_cleaned
GROUP BY label;

-- (8) Find the average age and average income of the approved and rejected credit card applicants.
SELECT
    label AS Approval_status,
    AVG(age) AS Average_age,
    AVG(Annual_income) AS Average_income
FROM
    credit_card_approval_cleaned
GROUP BY
    label;
-- (9) calculate the approval and rejection rates of the credit_card applicantions as a percentage.
SELECT label,
COUNT(*) * 100 / (SELECT COUNT(*) FROM credit_card_approval_cleaned) as rates
FROM credit_card_approval_cleaned
GROUP BY label;

-- (10) Percentage of the applications approved by Occupation type 
SELECT
    Type_Occupation,
    (SUM(CASE WHEN label = '0' THEN 1 ELSE 0 END) * 100 / COUNT(*)) AS approval_rates
FROM
    credit_card_approval_cleaned
GROUP BY
    Type_Occupation
ORDER BY 
    approval_rates;

-- (11) Percentage of the applications approved by income type 

SELECT
    Type_Income,
    (SUM(CASE WHEN label = '0' THEN 1 ELSE 0 END) * 100 / COUNT(*)) AS approval_rates
FROM
    credit_card_approval_cleaned
GROUP BY
    Type_Income
ORDER BY 
	approval_rates;
    
-- 12. Calculating approval rate by marital Status and income type
SELECT
    Marital_status,
    Type_Income,
    (SUM(CASE WHEN label = '0' THEN 1 ELSE 0 END) * 100 / COUNT(*)) AS approval_rates
FROM
    credit_card_approval_cleaned
GROUP BY
    Marital_status, Type_Income
ORDER BY 
    approval_rates;

-- 13. approval rates by education level and age group
SELECT
    EDUCATION,
    CASE
        WHEN age < 30 THEN 'Under 30'
        WHEN age >= 30 AND age < 40 THEN 'In Thirties'
        WHEN age >= 40 AND age < 50 THEN 'In Forties'
        ELSE '50 or Above'
    END AS age_group,
    (SUM(CASE WHEN label = '0' THEN 1 ELSE 0 END) * 100 / COUNT(*)) AS approval_rates
FROM
    credit_card_approval_cleaned
GROUP BY
    EDUCATION, age_group
ORDER BY 
    EDUCATION, age_group;
-- 14. Average number of children by marital status
SELECT
    Marital_status,
    AVG(CHILDREN) AS avg_children
FROM
    credit_card_approval_cleaned
GROUP BY
    Marital_status;
    
-- (15) Get the average income by age group
SELECT
    CASE
        WHEN age < 30 THEN 'Under 30'
        WHEN age >= 30 AND age < 40 THEN 'In Thirties'
        WHEN age >= 40 AND age < 50 THEN 'In Forties'
        ELSE '50 or Above'
    END AS age_group,
    AVG(Annual_income) AS avg_income
FROM
    credit_card_approval_cleaned
GROUP BY
    age_group
ORDER BY
    avg_income;

