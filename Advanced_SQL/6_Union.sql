-- Problem 1

/*
Create a unified query that categorizes job postings into two groups: those with salary information 
(salary_year_avg or salary_hour_avg is not null) and those without it. 
Each job posting should be listed with its job_id, job_title, and an indicator of whether salary information is provided.
*/

SELECT jf.job_id
,jf.job_title
,TRUE as salary_info

FROM job_postings_fact as jf

WHERE 1=1
AND jf.salary_year_avg IS NOT NULL OR jf.salary_hour_avg IS NOT NULL

--LIMIT 10
UNION ALL

SELECT jf.job_id
,jf.job_title
,FALSE as salary_info

FROM job_postings_fact as jf

WHERE 1=1
AND jf.salary_year_avg IS NULL AND jf.salary_hour_avg IS NULL

ORDER BY job_id

--LIMIT 10
;

-- Problem 2

/*
Retrieve the job id, job title short, job location, job via, skill and skill type for each job posting from 
the first quarter (January to March). Using a subquery to combine job postings from the first quarter 
(these tables were created in the Advanced Section - Practice Problem 6 [include timestamp of Youtube video]) 
Only include postings with an average yearly salary greater than $70,000.
*/

SELECT ua.job_id
,ua.job_title_short
,ua.job_location
,ua.job_via
,ua.salary_year_avg
,sj.skill_id
,sd.skills
,sd.type

FROM

(
    SELECT *
    
    FROM january_jobs

    UNION ALL

    SELECT *

    FROM february_jobs

    UNION ALL

    SELECT *
    
    FROM march_jobs

) as ua

LEFT JOIN skills_job_dim as sj
ON ua.job_id = sj.job_id

LEFT JOIN skills_dim as sd
ON sj.skill_id = sd.skill_id

WHERE 1=1
AND ua.salary_year_avg > 70000

ORDER BY ua.job_id
;

-- Problem 3

/*
Analyze the monthly demand for skills by counting the number of job postings for each skill in the first quarter 
(January to March), utilizing data from separate tables for each month. Ensure to include skills from 
all job postings across these months. The tables for the first quarter job postings were created in the 
Advanced Section - Practice Problem 6 [include timestamp of Youtube video].
*/

SELECT sd.skills
,EXTRACT(MONTH FROM ua.job_posted_date) as job_posted_month
,EXTRACT(YEAR FROM ua.job_posted_date) as job_posted_year
,COUNT(ua.job_id) as job_postings

FROM

(
    SELECT *
    FROM january_jobs

    UNION ALL

    SELECT *
    FROM february_jobs

    UNION ALL

    SELECT *
    FROM march_jobs

) as ua

JOIN skills_job_dim as sj
ON ua.job_id = sj.job_id

JOIN skills_dim as sd
ON sj.skill_id = sd.skill_id

GROUP BY skills, job_posted_year, job_posted_month

ORDER BY skills, job_posted_year, job_posted_month

;

-- CTE for combining job postings from January, February, and March
WITH combined_job_postings AS (
  SELECT job_id, job_posted_date
  FROM january_jobs
  UNION ALL
  SELECT job_id, job_posted_date
  FROM february_jobs
  UNION ALL
  SELECT job_id, job_posted_date
  FROM march_jobs
),
-- CTE for calculating monthly skill demand based on the combined postings
monthly_skill_demand AS (
  SELECT
    skills_dim.skills,  
    EXTRACT(YEAR FROM combined_job_postings.job_posted_date) AS year,  
    EXTRACT(MONTH FROM combined_job_postings.job_posted_date) AS month,  
    COUNT(combined_job_postings.job_id) AS postings_count 
  FROM
    combined_job_postings
	  INNER JOIN skills_job_dim ON combined_job_postings.job_id = skills_job_dim.job_id  
	  INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id  
  GROUP BY
    skills_dim.skills, year, month
)
-- Main query to display the demand for each skill during the first quarter
SELECT
  skills,  
  year,  
  month,  
  postings_count 
FROM
  monthly_skill_demand
ORDER BY
  skills, year, month;  