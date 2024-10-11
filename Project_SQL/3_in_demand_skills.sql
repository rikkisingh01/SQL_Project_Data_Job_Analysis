/*
**Question: What are the most in-demand skills for data analysts?**

- Identify the top 5 in-demand skills for a data analyst.
- Focus on all job postings.
- Why? Retrieves the top 5 skills with the highest demand in the job market, providing insights into the 
    most valuable skills for job seekers.
*/

-- Identifies the top 5 most demanded skills for Data Analyst job postings
SELECT sd.skills
,COUNT(sj.job_id) AS demand_count

FROM job_postings_fact as jf

INNER JOIN skills_job_dim as sj 
ON jf.job_id = sj.job_id

INNER JOIN skills_dim as sd 
ON sj.skill_id = sd.skill_id

WHERE 1=1
AND jf.job_title_short = 'Data Analyst'
AND jf.job_work_from_home = TRUE

GROUP BY sd.skills

ORDER BY demand_count DESC

LIMIT 5;