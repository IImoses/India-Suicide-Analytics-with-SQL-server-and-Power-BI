--explore the data
SELECT *
FROM suicide


--Check for nulls in each column
SELECT * 
FROM suicide
WHERE state IS NULL

--noticed that there are rows containing totals within the data so we need to delete those rows
DELETE 
FROM suicide
WHERE state like 'Total%'

--states with the most suicides
SELECT state,  SUM(total)AS TotalSuicides
FROM suicide
GROUP BY state 
ORDER BY 2   DESC

--the years with the most suicides
SELECT year,  SUM(total)AS TotalSuicides
FROM suicide
GROUP BY year
ORDER BY 2   DESC

--yearly trend
SELECT year,  SUM(total)AS TotalSuicides
FROM suicide
GROUP BY year
ORDER BY 1

--what gender commits more suicides
SELECT gender,  SUM(total)AS TotalSuicides
FROM suicide
GROUP BY gender 
ORDER BY 2   DESC

--the age group column has totals of age group from 0-100 so lets check it out and then delete them
SELECT *
FROM suicide 
WHERE age_group LIKE '%100+'

DELETE 
FROM SUICIDE
WHERE age_group LIKE '%100+'

--what age group commits the most suicides
SELECT age_group,  SUM(total)AS TotalSuicides
FROM suicide
GROUP BY age_group 
ORDER BY 2   DESC

--suicide rates by gender in each state
SELECT state, gender, SUM(total)
FROM suicide
GROUP BY state, gender
ORDER BY 1 ASC,3 DESC

--finding a state that has more female suicides than male
SELECT state,  SUM(total)
FROM suicide
GROUP BY state 
HAVING SUM(CASE WHEN gender = 'female' THEN total ELSE 0 END)> SUM(CASE WHEN gender = 'male' THEN total ELSE 0 END)


--suicide rates by age group and gender  
SELECT age_group, gender, SUM(total)
FROM suicide
GROUP BY age_group, gender
ORDER BY 1,3



--noticed that the type column contains both methods and causes of suicide based on the type code column. so now I will 
--create two new columns to sparate them
 ALTER TABLE suicide
 ADD cause varchar(50), method varchar(50)

 UPDATE suicide
 SET cause = CASE
				WHEN type_code = 'causes' THEN type ELSE 'not specified'
			END;
	
UPDATE suicide
SET method = CASE
				WHEN type_code = 'means_adopted' THEN type ELSE 'not specified'
			END  
	

 -- 0-14 is the only age range where girsls commit more suicides what are the major causes of suicide in 0-14 boys and girls
SELECT gender, cause, SUM(total) AS TotalSuicides
FROM suicide
WHERE Age_group LIKE '0-14' 
AND cause  NOT IN ( 'not specified', 'Other causes (Please Specity)','causes not known')
GROUP BY gender, cause
ORDER BY 1 ASC, 3 DESC


--generally what are the major causes
SELECT  cause, SUM(total) AS TotalSuicides
FROM suicide
WHERE cause  NOT IN ( 'not specified', 'Other causes (Please Specity)','causes not known')
GROUP BY  cause
ORDER BY 2 DESC

--what are the most common methods used
SELECT method, SUM(total) AS TotalSuicides
FROM suicide
WHERE method  <> 'not specified'
GROUP BY method
ORDER BY 2 DESC


--what is the most common method used for men and women
WITH MethodRank AS (
SELECT gender, method, SUM(total) AS total, ROW_NUMBER()
OVER (PARTITION BY gender ORDER BY SUM(total) DESC) AS methodrank
FROM suicide
WHERE method  <> 'not specified'
GROUP BY gender, method)

SELECT gender, method, total
FROM MethodRank
WHERE methodrank = 1

SELECT *
FROM suicide
WHERE cause = 
 
 SELECT state, year, gender, age_group, cause, method, total
FROM suicide

CREATE VIEW IndiaSuicides AS
SELECT state, year, gender, age_group, cause, method, total
FROM suicide





