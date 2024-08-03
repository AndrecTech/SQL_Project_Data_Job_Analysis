/*
SUBQUERIES AND CTEs OVERALL PRACTICE PROBLEMS:
1) Identify the top 5 skills that are most frequently mentioned in job postings.
Use a subquery to find the skill IDs with the highest counts in the skills_job_dim table
and then join this result with the skills_dim table to get the skill names.
*/

-- STEP 2 do the main query: join this result with the skills_dim table to get the skill names.
SELECT
    sd.skill_id,
    sd.skills,
    sq.skill_count
FROM
    skills_dim AS sd

JOIN (
-- STEP 1 do the subquery: Use a subquery to find the skill IDs with the highest counts in the skills_job_dim table
    SELECT
        skill_id,
        COUNT(*) AS skill_count
    FROM
        skills_job_dim
    GROUP BY
        skill_id
    ORDER BY
        skill_count DESC
    LIMIT 5
    ) AS sq
    ON sd.skill_id = sq.skill_id
ORDER BY
    sq.skill_count DESC;

/*
Problem #2: Determine the size category (‘Small’, ‘Medium’, or ‘ Large’)
for each company by first identifying the number of job postings they have.
Use a subquery to calculate the total job postings per company.

A company is considered ‘Small’ if it has less than 10 postings,
‘Medium’ if the number of job postings is between 10 and 50,
and ‘Large’ if it has more than 50 job postings.

Implement a subquery to aggregate job counts per company before classifying them based on size
*/

WITH company_job_count AS (
    SELECT
        company_id,
        COUNT (*) AS job_post_count
    FROM
        job_postings_fact
    GROUP BY
        company_id
)
SELECT
    cjc.company_id,
    cd.name,
    cjc.job_post_count,
    CASE
        WHEN cjc.job_post_count < 10 THEN 'Small'
        WHEN cjc.job_post_count BETWEEN 10 AND 50 THEN 'Medium'
        ELSE 'LARGE'
    END AS size_category
FROM
    company_job_count AS cjc
JOIN company_dim AS cd
    ON cjc.company_id = cd.company_id
ORDER BY
    cjc.job_post_count ASC;

--Step 1: Look at the table that connects the two other tables
SELECT
	job_id,
	skill_id
FROM
	skills_job_dim AS sjd
;

--Step 2: Connect the main fact table
SELECT
	jpf.job_id,
	sjd.skill_id,
    jpf.job_work_from_home
FROM
	skills_job_dim AS sjd
INNER JOIN job_postings_fact AS jpf ON jpf.job_id = sjd.job_id
WHERE
    jpf.job_work_from_home = TRUE
;

-- Step 3: Delete remote column (was only to verify correct query)
-- add skill count, and remove job_id since it is not being grouped by or needed.


--Step 4: We have our CTE build, add syntax
WITH remote_job_skills AS (
    SELECT
        sjd.skill_id,
        COUNT (*) AS skill_count -- and add skill count.
    FROM
        skills_job_dim AS sjd
    INNER JOIN job_postings_fact AS jpf ON jpf.job_id = sjd.job_id
    WHERE
        jpf.job_work_from_home = TRUE
    GROUP BY
        sjd.skill_id -- whenever you add an aggregation, you need a GROUP BY
)
;

--Step 5: JOIN CTE 'remote_job_skills' with skills_dim table
-- to get the names

WITH remote_job_skills AS (
    SELECT
        sjd.skill_id,
        COUNT (*) AS skill_count -- and add skill count.
    FROM
        skills_job_dim AS sjd
    INNER JOIN job_postings_fact AS jpf ON jpf.job_id = sjd.job_id
    WHERE
        jpf.job_work_from_home = TRUE
    GROUP BY
        sjd.skill_id -- whenever you add an aggregation, you need a GROUP BY
)
SELECT
    sd.skill_id,
    sd.skills AS skill_name,
    rjs.skill_count
FROM
    remote_job_skills AS rjs
INNER JOIN
    skills_dim AS sd
    ON sd.skill_id = rjs.skill_id -- *last table to join new/past table
;

--Step 6: ORDER and LIMIT

WITH remote_job_skills AS (
    SELECT
        sjd.skill_id,
        COUNT (*) AS skill_count 
    FROM
        skills_job_dim AS sjd
    INNER JOIN job_postings_fact AS jpf ON jpf.job_id = sjd.job_id
    WHERE
        jpf.job_work_from_home = TRUE
    GROUP BY
        sjd.skill_id 
)
SELECT
    sd.skill_id,
    sd.skills AS skill_name,
    rjs.skill_count
FROM
    remote_job_skills AS rjs
INNER JOIN
    skills_dim AS sd
    ON sd.skill_id = rjs.skill_id 
ORDER BY
    rjs.skill_count DESC
LIMIT 5
;

--Step 7 (OPTIONAL): Look only for data analyst jobs

WITH remote_job_skills AS (
    SELECT
        sjd.skill_id,
        COUNT (*) AS skill_count 
    FROM
        skills_job_dim AS sjd
    INNER JOIN job_postings_fact AS jpf ON jpf.job_id = sjd.job_id
    WHERE
        jpf.job_work_from_home = TRUE
        AND jpf.job_title_short = 'Data Analyst' -- Line added
    GROUP BY
        sjd.skill_id 
)
SELECT
    sd.skill_id,
    sd.skills AS skill_name,
    rjs.skill_count
FROM
    remote_job_skills AS rjs
INNER JOIN
    skills_dim AS sd
    ON sd.skill_id = rjs.skill_id 
ORDER BY
    rjs.skill_count DESC
LIMIT 5
;

-- Scenario: Get jobs and companies from January (UNION)
-- Step 1: Check
SELECT
	job_title_short,
	company_id,
	job_location
FROM
	january_jobs
;

-- Scenario: Get jobs and companies from February as well
SELECT
	job_title_short,
	company_id,
	job_location
FROM
	january_jobs

UNION -- Combine another table

SELECT
	job_title_short,
	company_id,
	job_location
FROM
	february_jobs
;

-- Scenario: Get jobs and companies from March as well
SELECT
	job_title_short,
	company_id,
	job_location
FROM
	january_jobs

UNION -- Combine another table

SELECT
	job_title_short,
	company_id,
	job_location
FROM
	february_jobs

UNION

SELECT
	job_title_short,
	company_id,
	job_location
FROM
	march_jobs
;

-- Scenario: Get jobs and companies from January (UNION ALL)
-- Step 1: Check
SELECT
	job_title_short,
	company_id,
	job_location
FROM
	january_jobs
;

-- Scenario: Get jobs and companies from February as well
SELECT
	job_title_short,
	company_id,
	job_location
FROM
	january_jobs

UNION ALL -- Combine another table

SELECT
	job_title_short,
	company_id,
	job_location
FROM
	february_jobs
;

-- Scenario: Get jobs and companies from March as well
SELECT
	job_title_short,
	company_id,
	job_location
FROM
	january_jobs

UNION ALL-- Combine another table

SELECT
	job_title_short,
	company_id,
	job_location
FROM
	february_jobs

UNION ALL

SELECT
	job_title_short,
	company_id,
	job_location
FROM
	march_jobs
;

/*
OVERALL UNION PRACTICE PROBLEM:
1)	Get the corresponding skill and skill type for each job in Q1
•	Includes those without any skills, too
•	Why? Look at the skills and the type for each job in the first quarter that has a salary > $70,000
*/

WITH jobs_Q1 AS (
	SELECT
		job_id,
		job_title_short,
        salary_year_avg
	FROM
		january_jobs

	UNION ALL

	SELECT
		job_id,
		job_title_short,
        salary_year_avg
	FROM
		february_jobs

	UNION ALL

	SELECT
		job_id,
		job_title_short,
        salary_year_avg
	FROM
		march_jobs
)

SELECT
    jq1.job_id,
    jq1.job_title_short,
    jq1.salary_year_avg,
    sd.skills,
    sd.type
FROM
	jobs_Q1 AS jq1
LEFT JOIN skills_job_dim AS sjd
    ON sjd.job_id = jq1.job_id
LEFT JOIN skills_dim AS sd
    ON sd.skill_id = sjd.skill_id

WHERE
	jq1.salary_year_avg > 70000
ORDER BY
    jq1.job_id
;

/* 
If the goal is to include all jobs even if they do not
have any associated skills (i.e., include jobs
with NULL values for skills), a LEFT JOIN is more
appropriate. A FULL JOIN would include all rows from
both tables, potentially leading to a larger result set
with rows from skills_job_dim or skills_dim even if they
have no corresponding job in the CombinedJobs.
*/


--------------------------------
/*
OVERALL PRACTICE PROBLEM #8:

Find job postings form the first quarter that we have a salary greater than $70K
	- Combine job posting tables from the first quarter of 2023 (Jan-Mar)
	- Get job postings with an average yearly salary > $70,000
*/

SELECT
    jobs_Q1.job_title_short,
    jobs_Q1.job_location,
    jobs_Q1.job_via,
    jobs_Q1.job_posted_date::DATE,
    jobs_Q1.salary_year_avg
FROM (
    SELECT *
    FROM january_jobs

    UNION ALL

    SELECT *
    FROM february_jobs

    UNION ALL

    SELECT *
    FROM march_jobs
) AS jobs_Q1
WHERE
    jobs_Q1.salary_year_avg > 70000
    AND jobs_Q1.job_title_short = 'Data Analyst'
ORDER BY
    jobs_Q1.salary_year_avg DESC
;
