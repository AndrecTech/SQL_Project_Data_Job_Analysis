/*
•	Question: What are the top-paying jobs for my role (data analysts jobs)?
- Identify the top 10 highest-paying Data Analyst roles that are available remotely.
- Focuses on job postings with specified salaries (remove nulls).
- Discover which companies are they offering the roles.
- Why? Highlight the top-paying opportunities for Data Analysts, offering insights into employment opportunities.
*/

SELECT
	jpf.job_id,
    cd.name AS company_name,
	jpf.job_title,
	jpf.job_location,
	jpf.salary_year_avg,
    jpf.job_schedule_type,
	jpf.job_posted_date
FROM
	job_postings_fact AS jpf
LEFT JOIN
    company_dim AS cd
    ON cd.company_id = jpf.company_id
WHERE
    jpf.job_title_short = 'Data Analyst'
    AND jpf.job_location = 'Anywhere'
    AND jpf.salary_year_avg IS NOT NULL
ORDER BY
    jpf.salary_year_avg DESC
LIMIT 10
;

/*
We can no have frame of mind on what we could expect
on the top paying jobst to expect for
*/