-- CTE = Common Table Expressions

-- Problem 1

/*
Identify companies with the most diverse (unique) job titles. Use a CTE to 
count the number of unique job titles per company, 
then select companies with the highest diversity in job titles.

*/

WITH company_job_titles AS (
    SELECT jf.company_id
    ,COUNT(DISTINCT jf.job_title) as unique_job_titles
    
    FROM job_postings_fact as jf

    WHERE 1=1

    GROUP BY 1

)

SELECT ct.company_id
,cd.name as company_name
,ct.unique_job_titles

FROM company_job_titles as ct

JOIN company_dim as cd
ON ct.company_id = cd.company_id

WHERE 1=1

ORDER BY ct.unique_job_titles DESC

LIMIT 10

;

-- Problem 2

/*
Explore job postings by listing job id, job titles, company names, and their average salary rates, 
while categorizing these salaries relative to the average in their respective countries. 
Include the month of the job posted date. 
Use CTEs, conditional logic, and date functions, to compare individual salaries with national averages.
*/

-- 787634
-- 787634

WITH country_averge AS (
    SELECT jf.job_country
    ,AVG(salary_year_avg) as country_salary_average

    FROM job_postings_fact as jf

    WHERE 1=1
    --AND salary_year_avg IS NOT NULL

    GROUP BY jf.job_country
)

SELECT 
--,jf.job_country
jf.job_id
,jf.job_title
,cd.name as company_name
,jf.salary_year_avg
--,ca.country_salary_average
,CASE
    WHEN jf.salary_year_avg > ca.country_salary_average THEN 'Above Average'
    ELSE 'Below Average'
END AS salary_category
,EXTRACT(MONTH FROM jf.job_posted_date) as posting_month

FROM job_postings_fact as jf

JOIN company_dim as cd
ON jf.company_id = cd.company_id

JOIN country_averge as ca
ON jf.job_country = ca.job_country

WHERE 1=1
--AND jf.salary_year_avg IS NOT NULL

ORDER BY posting_month DESC

;

-- gets average job salary for each country
WITH avg_salaries AS (
  SELECT 
    job_country, 
    AVG(salary_year_avg) AS avg_salary
  FROM job_postings_fact
  GROUP BY job_country
)

SELECT
  -- Gets basic job info
	job_postings.job_id,
  job_postings.job_title,
  companies.name AS company_name,
  job_postings.salary_year_avg AS salary_rate,
-- categorizes the salary as above or below average the average salary for the country
  CASE
    WHEN job_postings.salary_year_avg > avg_salaries.avg_salary
    THEN 'Above Average'
    ELSE 'Below Average'
  END AS salary_category,
  -- gets the month and year of the job posting date
  EXTRACT(MONTH FROM job_postings.job_posted_date) AS posting_month
FROM
  job_postings_fact as job_postings
INNER JOIN
  company_dim as companies ON job_postings.company_id = companies.company_id
INNER JOIN
  avg_salaries ON job_postings.job_country = avg_salaries.job_country
ORDER BY
    -- Sorts it by the most recent job postings
    posting_month desc

;

-- Problem 3

/*
Calculate the number of unique skills required by each company. Aim to quantify the 
unique skills required per company and identify which of these companies offer the 
highest average salary for positions necessitating at least one skill. For entities without 
skill-related job postings, list it as a zero skill requirement and a null salary. 
Use CTEs to separately assess the unique skill count and the maximum average salary offered by these companies.
*/

WITH company_unique_skills AS (
    SELECT jf.company_id
    ,COUNT(DISTINCT sj.skill_id) as company_unique_skills
    
    FROM job_postings_fact as jf

    LEFT JOIN skills_job_dim as sj
    ON jf.job_id = sj.job_id

    WHERE 1=1

    GROUP BY 1
    )
,
    company_max_salary AS (
    SELECT jf.company_id
    ,MAX(salary_year_avg) as company_max_salary

    FROM job_postings_fact as jf

    WHERE 1=1

    GROUP BY 1
)

SELECT DISTINCT jf.company_id
,cd.name as company_name
,cu.company_unique_skills
,cm.company_max_salary

FROM job_postings_fact as jf

JOIN company_dim as cd
ON jf.company_id = cd.company_id

LEFT JOIN company_unique_skills as cu
ON jf.company_id = cu.company_id

LEFT JOIN company_max_salary as cm
ON jf.company_id = cm.company_id

ORDER BY company_name

;
-- 140033

SELECT DISTINCT company_id 
FROM job_postings_fact

;


-- Luke solution:

-- Counts the distinct skills required for each company's job posting
WITH required_skills AS (
  SELECT
    companies.company_id,
    COUNT(DISTINCT skills_to_job.skill_id) AS unique_skills_required
  FROM
    company_dim AS companies 
  LEFT JOIN job_postings_fact as job_postings ON companies.company_id = job_postings.company_id
  LEFT JOIN skills_job_dim as skills_to_job ON job_postings.job_id = skills_to_job.job_id
  GROUP BY
    companies.company_id
),
-- Gets the highest average yearly salary from the jobs that require at least one skills 
max_salary AS (
  SELECT
    job_postings.company_id,
    MAX(job_postings.salary_year_avg) AS highest_average_salary
  FROM
    job_postings_fact AS job_postings
  WHERE
    job_postings.job_id IN (SELECT job_id FROM skills_job_dim)
  GROUP BY
    job_postings.company_id
)
-- Joins 2 CTEs with table to get the query
SELECT
  companies.name,
  required_skills.unique_skills_required as unique_skills_required, --handle companies w/o any skills required
  max_salary.highest_average_salary
FROM
  company_dim AS companies
LEFT JOIN required_skills ON companies.company_id = required_skills.company_id
LEFT JOIN max_salary ON companies.company_id = max_salary.company_id
ORDER BY
	companies.name;