/*
**Answer: What are the most optimal skills to learn (aka it’s in high demand and a high-paying skill) for a data analyst?** 

- Identify skills in high demand and associated with high average salaries for Data Analyst roles
- Concentrates on remote positions with specified salaries
- Why? Targets skills that offer job security (high demand) and financial benefits (high salaries), offering 
    strategic insights for career development in data analysis
*/

WITH skills_demand AS(
    SELECT sd.skill_id 
    ,sd.skills
    ,COUNT(sj.job_id) AS demand_count

    FROM job_postings_fact as jf

    INNER JOIN skills_job_dim as sj 
    ON jf.job_id = sj.job_id

    INNER JOIN skills_dim as sd 
    ON sj.skill_id = sd.skill_id

    WHERE 1=1
    AND jf.job_title_short = 'Data Analyst'
    AND jf.job_work_from_home = TRUE
    AND jf.salary_year_avg IS NOT NULL

    GROUP BY sd.skill_id, sd.skills

    --ORDER BY demand_count DESC

    --LIMIT 5
)
,
 average_salary AS (
    SELECT sd.skill_id
    --,sd.skills
    ,ROUND(AVG(jf.salary_year_avg), 0) AS average_salary

    FROM job_postings_fact as jf

    INNER JOIN skills_job_dim as sj 
    ON jf.job_id = sj.job_id

    INNER JOIN skills_dim as sd 
    ON sj.skill_id = sd.skill_id

    WHERE 1=1
    AND jf.job_title_short = 'Data Analyst'
    AND jf.job_work_from_home = TRUE
    AND jf.salary_year_avg IS NOT NULL

    GROUP BY sd.skill_id

    --ORDER BY average_salary DESC

    --LIMIT 25
)

SELECT sd.skill_id
,sd.skills
,demand_count
,average_salary

FROM skills_demand as sd

JOIN average_salary as avs
ON sd.skill_id = avs.skill_id

WHERE 1=1
AND demand_count > 10

ORDER BY average_salary DESC, demand_count DESC 