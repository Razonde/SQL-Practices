-- Cleaning up data Chapter 10 from Github
/*Sometimes information is wrong, missing values or not what you need
therefore you must clean the database to reduce errors and problems*/

-- Setup

CREATE TABLE meat_poultry_egg_establishments (
    establishment_number text CONSTRAINT est_number_key PRIMARY KEY,
    company text,
    street text,
    city text,
    st text,
    zip text,
    phone text,
    grant_date date,
    activities text,
    dbas text
);

COPY meat_poultry_egg_establishments
FROM '/workspace/SQL-Practice/git_environment/practical-sql-2/Chapter_10/MPI_Directory_by_Establishment_Name.csv'
WITH (FORMAT CSV, HEADER);

-- Finding Duplicates
/* Identify the colums that will be unique
    Group by creates a generalized group defined by the columns given*/



-- Finding missing data
/*Check the records where the state is NULL, if needed, order by.
Group and count the values*/
SELECT establishment_number,
       company,
       city,
       st,
       zip
FROM meat_poultry_egg_establishments
WHERE st IS NULL;

/*Returns the total count and groups by NULL the ones with no State*/
SELECT st, 
       count(*) AS st_count
FROM meat_poultry_egg_establishments
GROUP BY st
ORDER BY st;

-- Finding inconsistent data
/*Some information may be wrong, or simply written wrongly in a database.
We need to understand the constraints for some columns, such as zip length or phone number length*/

SELECT length(zip),
       count(*) AS length_count
FROM meat_poultry_egg_establishments
GROUP BY length(zip)
ORDER BY length(zip) ASC;


-- Fixing missing data 
-- 1. Create a back-up table, it allows us to fix mistakes
CREATE TABLE meat_poultry_egg_establishments_backup AS
SELECT * FROM meat_poultry_egg_establishments;

-- 2. Create a new column and work in the new colum if possible. Fix the values
ALTER TABLE meat_poultry_egg_establishments ADD COLUMN st_copy text;
UPDATE meat_poultry_egg_establishments
SET st_copy = st;

-- 3. Change the values with expect ones. (Knowing which ones are the ones you need to change: 'NULL')
UPDATE meat_poultry_egg_establishments
SET st = 'WI'
WHERE establishment_number = 'M263A+P263A+V263A'
RETURNING establishment_number, company, city, st, zip; -- Returns value of column where changes happened


--Fixing inconsistent data
--Knowledge of the states where the zip code is wrong
UPDATE meat_poultry_egg_establishments
SET zip = '00' || zip -- Concatenate 00 + ZipCode
WHERE st IN('PR','VI') AND length(zip) = 3;


-- Fixing duplicated data
-- Finds the Max IDs and deletes all record that are duplicated, can al be Min IDs
delete from meat_poultry_egg_establishments --deletes all rows not in where
where establishment_number not in (
	SELECT max(establishment_number)
	FROM meat_poultry_egg_establishments
	GROUP BY company, street, city, st
);


-- Changing with backup data

-- If column was made a backup
UPDATE meat_poultry_egg_establishments
SET st = st_copy;

--If a table was made a backup
UPDATE meat_poultry_egg_establishments original
SET st = backup.st
FROM meat_poultry_egg_establishments_backup backup
WHERE original.establishment_number = backup.establishment_number


-- Challenge
/*Add a new colum meat_processing (boolean)
    set this column to true if the company has 'Meat Processing'*/

ALTER TABLE meat_poultry_egg_establishments ADD COLUMN meat_processing bool;

UPDATE meat_poultry_egg_establishments
set meat_processing = TRUE
WHERE activities like '%Meat Processing%';

UPDATE meat_poultry_egg_establishments
set meat_processing = FALSE
WHERE activities not like '%Meat Processing%';

SELECT activities, meat_processing FROM meat_poultry_egg_establishments where meat_processing = TRUE;

-- Transactions
/* Help to group db operations
Has rollbacks
Has commits*/

--Rollback changes
start transaction;

UPDATE meat_poultry_egg_establishments 
set company = 'gdl';

select company, * from meat_poultry_egg_establishments;

rollback;

--Commit changes
START TRANSACTION;

UPDATE meat_poultry_egg_establishments 
set company = 'gdl';

select company, * from meat_poultry_egg_establishments;

COMMIT;
