SELECT '2023-02-19'
; 

-- Cast as a date
SELECT '2023-02-19'::DATE
;

SELECT jf.job_title_short as title 
,jf.job_location as location 
,jf.job_posted_date::DATE

FROM job_postings_fact as jf

LIMIT 100
;

SELECT jf.job_title_short as title 
,jf.job_location as location 
,jf.job_posted_date as date_time

FROM job_postings_fact as jf

LIMIT 100
;

-- Converting the timezone
SELECT jf.job_title_short as title 
,jf.job_location as location 
,jf.job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST' AS date_time

FROM job_postings_fact as jf

LIMIT 5;

-- Using the EXTRACT function
SELECT jf.job_title_short as title 
,jf.job_location as location 
,jf.job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST' AS date_time
,EXTRACT(MONTH FROM jf.job_posted_date) as date_month

FROM job_postings_fact as jf

LIMIT 5;

-- Look at job postings by month for Data Analyst

SELECT COUNT(jf.job_id) as job_posted_count
,EXTRACT(MONTH FROM jf.job_posted_date) as date_month

FROM job_postings_fact as jf

WHERE 1=1
AND jf.job_title_short = 'Data Analyst'

GROUP BY date_month

ORDER BY job_posted_count DESC;

-- Problem 1

/*
Find the average salary both yearly (salary_year_avg) and hourly (salary_hour_avg) for job postings 
using the job_postings_fact table that were posted after June 1, 2023. Group the results by job schedule type. 
Order by the job_schedule_type in ascending order.
*/

SELECT *
FROM job_postings_fact as jf
LIMIT 3
;

SELECT jf.job_schedule_type
,AVG(jf.salary_year_avg) as salary_avg 
,AVG(jf.salary_hour_avg) as hourly_avg 

FROM job_postings_fact as jf

WHERE 1=1
AND jf.job_posted_date::DATE > '2023-06-01'

GROUP BY jf.job_schedule_type

ORDER BY jf.job_schedule_type
;

-- Problem 2
/*
Count the number of job postings for each month in 2023, adjusting the job_posted_date to be in 'America/New_York' 
time zone before extracting the month. Assume the job_posted_date is stored in UTC. Group by and order by the month.
*/

-- Using the EXTRACT function
SELECT EXTRACT(MONTH FROM jf.job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST') as date_month
--,EXTRACT(MONTH FROM jf.job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'America/New_York') as date_month
,COUNT(jf.job_id) as job_postings

FROM job_postings_fact as jf

WHERE 1=1

GROUP BY date_month

ORDER BY date_month 
;

-- Problem 3

/*
Find companies (include company name) that have posted jobs offering health insurance, where these postings 
were made in the second quarter of 2023. Use date extraction to filter by quarter. 
And order by the job postings count from highest to lowest.
*/

SELECT EXTRACT(QUARTER FROM jf.job_posted_date) as quarter 
,cd.name as company_name
,COUNT(jf.job_id) as job_postings

FROM job_postings_fact as jf

JOIN company_dim as cd 
ON jf.company_id = cd.company_id

WHERE 1=1
AND jf.job_health_insurance = TRUE
AND EXTRACT(QUARTER FROM jf.job_posted_date) = 2
--AND quarter = 2

GROUP BY quarter, company_name

HAVING COUNT(jf.job_id) > 0

ORDER BY job_postings DESC

;

-- Problem 6 from the course lecture for creating needed tables:

-- For January
CREATE TABLE january_jobs AS 
	SELECT * 
	FROM job_postings_fact
	WHERE EXTRACT(MONTH FROM job_posted_date) = 1;

-- For February
CREATE TABLE february_jobs AS 
	SELECT * 
	FROM job_postings_fact
	WHERE EXTRACT(MONTH FROM job_posted_date) = 2;

-- For March
CREATE TABLE march_jobs AS 
	SELECT * 
	FROM job_postings_fact
	WHERE EXTRACT(MONTH FROM job_posted_date) = 3;

SELECT count(*)
FROM january_jobs