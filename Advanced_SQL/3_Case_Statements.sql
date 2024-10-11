-- Problem 1

/*

From the job_postings_fact table, categorize the salaries from job postings that are data analyst jobs and who have a yearly salary information. Put salary into 3 different categories:

If the salary_year_avg is greater than $100,000 then return ‘high salary’.
If the salary_year_avg is between $60,000 and $99,999 return ‘Standard salary’.
If the salary_year_avg is below $60,000 return ‘Low salary’.
Also order from the highest to lowest salaries.

*/

SELECT jf.job_id
,jf.job_title
,jf.salary_year_avg
,CASE
    WHEN jf.salary_year_avg > 100000 THEN 'High Salary'
    WHEN jf.salary_year_avg BETWEEN 60000 AND 99999 THEN 'Standard Salary'
    ELSE 'Low Salary'
END AS salary_category

FROM job_postings_fact as jf 

WHERE 1=1
AND jf.salary_year_avg IS NOT NULL
AND jf.job_title_short = 'Data Analyst'

ORDER BY jf.salary_year_avg DESC
;

-- Problem 2

/*
Count the number of unique companies that offer work from home (WFH) versus those requiring work to be on-site. 
Use the job_postings_fact table to count and compare the distinct companies based on their WFH policy (job_work_from_home).
*/

SELECT COUNT(DISTINCT jf.company_id) as unique_companies
,CASE
    WHEN jf.job_work_from_home = TRUE THEN 'WFH'
    ELSE 'on-site'
END AS work_from_home_policy

FROM job_postings_fact as jf 

WHERE 1=1

GROUP BY work_from_home_policy
;

-- Alterntive solution:
SELECT 
    COUNT(DISTINCT CASE WHEN job_work_from_home = TRUE THEN company_id END) AS wfh_companies,
    COUNT(DISTINCT CASE WHEN job_work_from_home = FALSE THEN company_id END) AS non_wfh_companies
FROM job_postings_fact
;

-- Problem 3

/*
Write a query that lists all job postings with their job_id, salary_year_avg, 
and two additional columns using CASE WHEN statements called: experience_level and remote_option. 
Use the job_postings_fact table.
*/

SELECT jf.job_id
,jf.salary_year_avg
,CASE
    WHEN jf.job_title ILIKE '%Senior%' THEN 'Senior'
    WHEN job_title ILIKE '%Manager%' OR job_title ILIKE '%Lead%' THEN 'Lead/Manager'
    WHEN job_title ILIKE '%Junior%' OR job_title ILIKE '%Entry%' THEN 'Junior/Entry'
    --WHEN jf.job_title ILIKE '%Manager%' THEN 'Lead/Manager'
    --WHEN jf.job_title ILIKE '%Lead%' THEN 'Lead/Manager'
    --WHEN jf.job_title ILIKE '%Junior%' THEN 'Junior/Entry'
    --WHEN jf.job_title ILIKE '%Entry%' THEN 'Junior/Entry'
    ELSE 'Not Specified'
END AS experience_level
,CASE
    WHEN jf.job_work_from_home = TRUE THEN 'Yes'
    ELSE 'No'
END AS remote_option

FROM job_postings_fact as jf 

WHERE 1=1
AND salary_year_avg IS NOT NULL

ORDER BY jf.job_id

LIMIT 100
;
