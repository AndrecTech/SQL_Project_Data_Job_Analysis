/*
•	Question: What are the most optimal skills to learn?
    o	Optimal: High Demand AND High Paying
-	Identify skills in high demand and associate with high average salaries for Data Analyst roles
-	Concentrates on remote positions with specified salaries
-	Why? Target skills that offer job security (high demand) and financial benefits (high salaries), offering strategic insights for career development in data analysis
*/

WITH skills_demand AS (
    SELECT
        sd.skill_id,
        sd.skills,
        COUNT (sjd.skill_id) AS demand_count
    FROM
        job_postings_fact AS jpf
    INNER JOIN
        skills_job_dim AS sjd
    ON sjd.job_id = jpf.job_id
    INNER JOIN
        skills_dim AS sd
        ON sd.skill_id = sjd.skill_id
    WHERE
        jpf.job_title_short = 'Data Analyst'
        AND jpf.salary_year_avg IS NOT NULL
        AND jpf.job_work_from_home = TRUE -- Remote Filter
    GROUP BY
        sd.skill_id
), average_salary AS ( -- 2 WITH's separated with a coma
    SELECT
        sd.skill_id,
        ROUND (AVG (jpf.salary_year_avg), 0) AS avg_salary
    FROM
        job_postings_fact AS jpf
    INNER JOIN
        skills_job_dim AS sjd
    ON sjd.job_id = jpf.job_id
    INNER JOIN
        skills_dim AS sd
        ON sd.skill_id = sjd.skill_id
    WHERE
        jpf.job_title_short = 'Data Analyst'
        AND jpf.salary_year_avg IS NOT NULL
        AND jpf.job_work_from_home = TRUE -- Remote Filter
    GROUP BY
        sd.skill_id
)

SELECT
    skills_demand.skill_id,
    skills_demand.skills,
    skills_demand.demand_count,
    average_salary.avg_salary
FROM
    skills_demand
INNER JOIN
    average_salary
    ON average_salary.skill_id = skills_demand.skill_id
WHERE
    skills_demand.demand_count > 10 -- Not niche skills/skewed
ORDER BY
    average_salary.avg_salary DESC,
    skills_demand.demand_count DESC
LIMIT 25
;
