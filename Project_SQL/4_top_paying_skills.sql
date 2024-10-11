/*
**Answer: What are the top skills based on salary?** 

- Look at the average salary associated with each skill for Data Analyst positions.
- Focuses on roles with specified salaries, regardless of location.
- Why? It reveals how different skills impact salary levels for Data Analysts and 
    helps identify the most financially rewarding skills to acquire or improve.
*/

SELECT sd.skills
--,COUNT(sj.job_id) AS demand_count
,ROUND(AVG(jf.salary_year_avg), 0) AS average_salary

FROM job_postings_fact as jf

INNER JOIN skills_job_dim as sj 
ON jf.job_id = sj.job_id

INNER JOIN skills_dim as sd 
ON sj.skill_id = sd.skill_id

WHERE 1=1
AND jf.job_title_short = 'Data Analyst'
AND jf.salary_year_avg IS NOT NULL
AND jf.job_work_from_home = TRUE

GROUP BY sd.skills

ORDER BY average_salary DESC

LIMIT 25;

/*
PySpark is associated with the highest average salary, at $208,172.
Bitbucket, a Git repository management tool, offers an average salary of $189,155.
Couchbase and Watson (IBM's AI tool) both have salaries around $160,515, indicating high demand for these skills.
DataRobot, a machine learning automation tool, offers an average salary of $155,486.
These insights show that specialized tools like PySpark, Bitbucket, and advanced AI/ML tools 
    are associated with high-paying data analyst roles. ​
*/