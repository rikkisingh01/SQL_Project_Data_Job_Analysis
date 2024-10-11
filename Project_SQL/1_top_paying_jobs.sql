/*
**Question: What are the top-paying data analyst jobs?**

- Identify the top 10 highest-paying Data Analyst roles that are available remotely.
- Focuses on job postings with specified salaries.
- Why? Aims to highlight the top-paying opportunities for Data Analysts, 
    offering insights into employment options and location flexibility.
*/

SELECT jf.job_id
,jf.job_title
,jf.job_location
,jf.job_schedule_type
,jf.salary_year_avg
,jf.job_posted_date
,cd.name as company_name

FROM job_postings_fact as jf

LEFT JOIN company_dim as cd
ON jf.company_id = cd.company_id

WHERE 1=1
AND jf.job_title_short = 'Data Analyst'
AND jf.job_location = 'Anywhere'
AND jf.salary_year_avg IS NOT NULL

ORDER BY jf.salary_year_avg DESC

LIMIT 10