-- Subquery

-- Using subquerys on a WHERE clause
SELECT percentile_cont(.9) WITHIN GROUP (ORDER BY pop_est_2019)
    FROM us_counties_pop_est_2019 --Check the value of the 90% percentile

-- In the where clause
SELECT county_name,
       state_name,
       pop_est_2019
FROM us_counties_pop_est_2019
WHERE pop_est_2019 >= (
    SELECT percentile_cont(.9) WITHIN GROUP (ORDER BY pop_est_2019)
    FROM us_counties_pop_est_2019
    )
ORDER BY pop_est_2019 DESC;

-- Get values from a subgroup
SELECT round(calcs.average, 0) as average,
       calcs.median,
       round(calcs.average - calcs.median, 0) AS median_average_diff
FROM (
     SELECT avg(pop_est_2019) AS average,
            percentile_cont(.5)
                WITHIN GROUP (ORDER BY pop_est_2019)::numeric AS median
     FROM us_counties_pop_est_2019
     )
AS calcs;

--You can join subquerys

SELECT census.state_name AS st,
       census.pop_est_2018,
       est.establishment_count,
       round((est.establishment_count/census.pop_est_2018::numeric) * 1000, 1)
           AS estabs_per_thousand
FROM
    (
         SELECT st,
                sum(establishments) AS establishment_count
         FROM cbp_naics_72_establishments
         GROUP BY st
    )
    AS est
JOIN
    (
        SELECT state_name,
               sum(pop_est_2018) AS pop_est_2018
        FROM us_counties_pop_est_2019
        GROUP BY state_name
    )
    AS census
ON est.st = census.state_name
ORDER BY estabs_per_thousand DESC;

-- You can use subquerys as a column 
SELECT county_name,
       state_name AS st,
       pop_est_2019,
       (SELECT percentile_cont(.5) WITHIN GROUP (ORDER BY pop_est_2019)
        FROM us_counties_pop_est_2019) AS us_median
FROM us_counties_pop_est_2019;

-- You can even use them as part of a calculation
SELECT county_name,
       state_name AS st,
       pop_est_2019,
       pop_est_2019 - (SELECT percentile_cont(.5) WITHIN GROUP (ORDER BY pop_est_2019)
                       FROM us_counties_pop_est_2019) AS diff_from_median
FROM us_counties_pop_est_2019
WHERE (pop_est_2019 - (SELECT percentile_cont(.5) WITHIN GROUP (ORDER BY pop_est_2019)
                       FROM us_counties_pop_est_2019))
       BETWEEN -1000 AND 1000;


-- You can search for certain values in other querys from different tables
SELECT first_name, last_name
FROM employees
WHERE emp_id IN ( -- If it can return NULL values, IN may not work
    SELECT id
    FROM retirees)
ORDER BY emp_id;

-- If IN doesn't work, use EXISTS
SELECT first_name, last_name
FROM employees
WHERE EXISTS (
    SELECT id
    FROM retirees
    WHERE id = employees.emp_id);

-- Can be used for lateral subqueries

-- You can create CTE (Common Table Expressions) stored in memory (temporal table) using subqueries
WITH large_counties (county_name, state_name, pop_est_2019) --Define table
AS ( -- subquery, use same column names
    SELECT county_name, state_name, pop_est_2019
    FROM us_counties_pop_est_2019
    WHERE pop_est_2019 >= 100000
   ) -- Continue query
SELECT state_name, count(*)
FROM large_counties
GROUP BY state_name
ORDER BY count(*) DESC;

