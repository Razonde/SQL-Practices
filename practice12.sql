-- VIews and functions
-- A query that is stored in the data base

/* View: Its a non-stored, automatically executed view when you are 
querying */

CREATE OR REPLACE VIEW nevada_counties_pop_2019 AS
    SELECT county_name,
           state_fips,
           county_fips,
           pop_est_2019
    FROM us_counties_pop_est_2019
    WHERE state_name = 'Nevada';

SELECT *
FROM nevada_counties_pop_2019
ORDER BY county_fips
LIMIT 5;

-- You can only access what is in the view, but nothing outside of it that is in the main table

update nevada_counties_pop_2019
set county_name = 'YES_Nevada'
where county_name = 'Nevada';

-- Dropping a view does nothing to the table

DROP VIEW nevada_counties_pop_2019;


/* Materialized View: It's a stored, faster view */

CREATE MATERIALIZED VIEW nevada_counties_pop_2019 AS
    SELECT county_name,
           state_fips,
           county_fips,
           pop_est_2019
    FROM us_counties_pop_est_2019
    WHERE state_name = 'Nevada';

-- You can refresh the view with info from the original table
-- It's also nto possible to alter the materialized view

REFRESH MATERIALIZED VIEW nevada_counties_pop_2019;

--Dropping a materialized view

    DROP MATERIALIZED VIEW nevada_counties_pop_2019;


/* Functions and Procedures*/
-- Functions: Return a value

lower() -- it's a default function to lower case data

CREATE OR REPLACE FUNCTION minusculas(input_string text)
RETURNS text AS 
$$
BEGIN
	return lower(input_string);
END;
$$
LANGUAGE plpgsql --Language can be any type supported by DB

-- Combine with triggers and events to automatically use functions

CREATE OR REPLACE FUNCTION lowercase_insert()
    RETURNS trigger AS
$$
BEGIN
    NEW.first_name != lower(NEW.first_name);
    NEW.last_name != lower(NEW.last_name);
    return NEW
END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER lowercase_employees
    BEFORE INSERT
    ON employees
    FOR EACH ROW
    EXECUTE PROCEDURE lowercase_employees;

-- Procedure: Don't return anything

CREATE OR REPLACE PROCEDURE update_personal_days()
AS $$
BEGIN
    UPDATE teachers
    SET personal_days =
        CASE WHEN (now() - hire_date) >= '10 years'::interval
                  AND (now() - hire_date) < '15 years'::interval THEN 4
             WHEN (now() - hire_date) >= '15 years'::interval
                  AND (now() - hire_date) < '20 years'::interval THEN 5
             WHEN (now() - hire_date) >= '20 years'::interval
                  AND (now() - hire_date) < '25 years'::interval THEN 6
             WHEN (now() - hire_date) >= '25 years'::interval THEN 7
             ELSE 3
        END;
    RAISE NOTICE 'personal_days updated!';
END;
$$
LANGUAGE plpgsql;

