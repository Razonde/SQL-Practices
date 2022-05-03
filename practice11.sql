-- Mining Text
/* We can extrapolate from text certain expressions*/

SELECT trim(' Pat '); -- Remove spaces from beginning and end

SELECT replace('bat', 'b', 'c'); -- Replace b for c


-- Regular expressions (Regex101.com)

SELECT substring('The game starts at 7 p.m. on May 2, 2024.' from '.+'); --Maches with anything,

SELECT substring('The game starts at 7 p.m. on May 2, 2024.' from '\d{1,2} (?:a.m.|p.m.)');

--Using regular expressions in select

SELECT county_name
FROM us_counties_pop_est_2019
WHERE county_name ~* '(lade|lare)'
ORDER BY county_name;

-- Regex

SELECT crime_id,
       regexp_match(original_text, '\d{1,2}\/\d{1,2}\/\d{2}')
FROM crime_reports
ORDER BY crime_id;

--\d -> for digits, can be added {} for amount
--\w -> for word or words if a + /Meaning one or more is added
--* can be used to say 0 or more
--Special characters may be written the same, such as \n
-- | is used to create optionality in strings

--Challenge, create a regular expression for ID
(C\d+|SO\d+)

