/*
•	Question: What are the most in-demand skills for my role (Data Analyst)?
- Join job postings to INNER JOIN table similar to query 2.
- Identify the top 5 in-demand skills for a data analyst.
- Focus on all job postings.
- Why? Retrieve the top 5 skills with the highest demand in
the job market, providing insights into the most valuable
skills for job seekers.
*/

SELECT *
FROM
	job_postings_fact AS jpf
INNER JOIN
	skills_job_dim AS sjd
ON sjd.job_id = jpf.job_id
INNER JOIN
	skills_dim AS sd
	ON sd.skill_id = sjd.skill_id
LIMIT 5
;
