-- Problem 1

/*
Identify the top 5 skills that are most frequently mentioned in job postings. 
Use a subquery to find the skill IDs with the highest counts in the 
skills_job_dim table and then join this result with the skills_dim table to get the skill names.
*/


SELECT sj.skill_id
,COUNT(sj.job_id) as job_count

FROM skills_job_dim as sj

WHERE 1=1

GROUP BY sj.skill_id

ORDER BY job_count DESC

LIMIT 5

;

SELECT ts.skill_id
,ts.job_count
,sd.skills

FROM

(
    SELECT sj.skill_id
    ,COUNT(sj.job_id) as job_count

    FROM skills_job_dim as sj

    WHERE 1=1

    GROUP BY sj.skill_id

    ORDER BY job_count DESC

    LIMIT 5
) as ts

LEFT JOIN skills_dim as sd
ON ts.skill_id = sd.skill_id

WHERE 1=1
;

-- Problem 2

/*
Determine the size category ('Small', 'Medium', or 'Large') for each company by first identifying the number of 
job postings they have. Use a subquery to calculate the total job postings per company. 
A company is considered 'Small' if it has less than 10 job postings, 'Medium' if the number of job postings is 
between 10 and 50, and 'Large' if it has more than 50 job postings. Implement a subquery to aggregate job counts 
per company before classifying them based on size.
*/

SELECT jf.company_id
,s1.company_name
,s1.job_postings
,CASE
    WHEN s1.job_postings > 50 THEN 'Large'
    WHEN s1.job_postings BETWEEN 10 and 50 THEN 'Medium'
    ELSE 'Small'
END AS company_size

FROM job_postings_fact as jf

LEFT JOIN 
(
    SELECT jf.company_id
    ,cd.name as company_name
    ,COUNT(jf.job_id) as job_postings

    FROM job_postings_fact as jf
    
    JOIN company_dim as cd
    ON jf.company_id = cd.company_id

    WHERE 1=1

    GROUP BY jf.company_id, cd.name
) as s1

ON jf.company_id = s1.company_id

WHERE 1=1

GROUP BY jf.company_id, s1.company_name, s1.job_postings

ORDER BY jf.company_id

;

SELECT COUNT(DISTINCT company_id)
FROM job_postings_fact;
;

-- Alternative solution:
SELECT 
  company_id,
  name,
	-- Categorize companies
  CASE
	WHEN job_count < 10 THEN 'Small'
    WHEN job_count BETWEEN 10 AND 50 THEN 'Medium'
    ELSE 'Large'
  END AS company_size

FROM 
-- Subquery to calculate number of job postings per company 
(
  SELECT 
		company_dim.company_id, 
		company_dim.name, 
		COUNT(job_postings_fact.job_id) as job_count
  FROM 
		company_dim
  INNER JOIN job_postings_fact ON company_dim.company_id = job_postings_fact.company_id
  GROUP BY 
		company_dim.company_id, 
		company_dim.name
) AS company_job_count
;

-- Problem 3

/*
Find companies that offer an average salary above the overall average yearly salary of all job postings. 
Use subqueries to select companies with an average salary higher than the overall average salary 
(which is another subquery).
*/

SELECT AVG(jf.salary_year_avg) as overall_average_salary

FROM job_postings_fact as jf

WHERE 1=1 -- 123268.815642515544
AND jf.salary_year_avg IS NOT NULL -- 123268.815642515544
;

SELECT jf.company_id
,cd.name as company_name
,AVG(jf.salary_year_avg) as company_average_salary

FROM job_postings_fact as jf

LEFT JOIN company_dim as cd
ON jf.company_id = cd.company_id

WHERE 1=1 
AND jf.salary_year_avg IS NOT NULL 

GROUP BY jf.company_id, company_name

;
--7333 all
--2737

SELECT c1.company_id
,c1.company_name
,c1.company_average_salary
,o1.overall_average_salary

FROM 
(
  SELECT jf.company_id
  ,cd.name as company_name
  ,AVG(jf.salary_year_avg) as company_average_salary

  FROM job_postings_fact as jf

  LEFT JOIN company_dim as cd
  ON jf.company_id = cd.company_id

  WHERE 1=1 
  AND jf.salary_year_avg IS NOT NULL 

  GROUP BY jf.company_id, company_name
) as c1

LEFT JOIN

(
SELECT jf.company_id
,(SELECT AVG(salary_year_avg) FROM job_postings_fact) as overall_average_salary

FROM job_postings_fact as jf

WHERE 1=1

GROUP BY jf.company_id
) o1

ON c1.company_id = o1.company_id


WHERE 1=1
AND c1.company_average_salary > o1.overall_average_salary

;

SELECT jf.company_id
,(SELECT AVG(salary_year_avg) FROM job_postings_fact) as overall_average_salary

FROM job_postings_fact as jf

WHERE 1=1

GROUP BY 1

;

SELECT company_dim.company_id 
    ,company_dim.name
    ,company_salaries.avg_salary
FROM 
    company_dim
INNER JOIN (
    -- Subquery to calculate average salary per company
    SELECT 
			company_id, 
			AVG(salary_year_avg) AS avg_salary
    FROM job_postings_fact
    GROUP BY company_id
    ) AS company_salaries ON company_dim.company_id = company_salaries.company_id
-- Filter for companies with an average salary greater than the overall average
WHERE company_salaries.avg_salary > (
    -- Subquery to calculate the overall average salary
    SELECT AVG(salary_year_avg)
    FROM job_postings_fact
);
