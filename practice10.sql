-- Database extensions
/* You can add more functions to your db with extensions*/
select * from pg_available_extensions; -- Extension list for database, not active by default

CREATE EXTENSION tablefunc; -- Cross table functionality

SELECT *
FROM crosstab('SELECT office, 
                      flavor,
                      count(*)
               FROM ice_cream_survey
               GROUP BY office, flavor
               ORDER BY office',

              'SELECT flavor
               FROM ice_cream_survey
               GROUP BY flavor
               ORDER BY flavor') -- Crosstab is the function

AS (office text,
    chocolate bigint,
    strawberry bigint,
    vanilla bigint);

--Challenge
-- Make office the pivot

SELECT *
FROM crosstab('SELECT flavor, 
                      office,
                      count(*)
               FROM ice_cream_survey
               GROUP BY flavor, office
               ORDER BY flavor',

              'SELECT office
               FROM ice_cream_survey
               GROUP BY office
               ORDER BY office') -- Crosstab is the function
AS (office text,
    Uptown bigint,
    Middletown bigint,
    Downtown bigint);