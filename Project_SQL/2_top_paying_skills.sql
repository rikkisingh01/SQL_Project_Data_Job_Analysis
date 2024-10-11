/*
**Question: What are the top-paying data analyst jobs, and what skills are required?** 

- Identify the top 10 highest-paying Data Analyst jobs and the specific skills required for these roles.
- Filters for roles with specified salaries that are remote
- Why? It provides a detailed look at which high-paying jobs demand certain skills, 
    helping job seekers understand which skills to develop that align with top salaries
*/

WITH top_paying_jobs AS (
    SELECT jf.job_id
    ,jf.job_title
    ,jf.salary_year_avg
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
)

SELECT tp.*
,sd.skills

FROM top_paying_jobs as tp

JOIN skills_job_dim as sj
ON tp.job_id = sj.job_id

JOIN skills_dim as sd 
ON sj.skill_id = sd.skill_id

ORDER BY salary_year_avg DESC

/*
Here are the key insights from the analysis of the "skills" column:

SQL is the most frequently listed skill, appearing in 8 job postings.
Python is also highly valued, appearing in 7 job postings.
Tableau is emphasized in 6 job postings, indicating a demand for data visualization skills.
R is mentioned in 4 job postings, suggesting its relevance for statistical analysis.
Snowflake, a cloud data platform, appears in 3 job postings, reflecting its growing importance in data management.
*/