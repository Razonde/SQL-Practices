-- Date data types
/*
Time: 7:12 AM CTZ
Date: Monday 2nd May 2022 -> Interval 02/11/1979 - 02/11/1980
*/
-- Information you can get from a time stamp
SELECT
    date_part('year', '2022-12-01 18:37:12 EST'::timestamptz) AS year,
    date_part('month', '2022-12-01 18:37:12 EST'::timestamptz) AS month,
    date_part('day', '2022-12-01 18:37:12 EST'::timestamptz) AS day,
    date_part('hour', '2022-12-01 18:37:12 EST'::timestamptz) AS hour,
    date_part('minute', '2022-12-01 18:37:12 EST'::timestamptz) AS minute,
    date_part('seconds', '2022-12-01 18:37:12 EST'::timestamptz) AS seconds,
    date_part('timezone_hour', '2022-12-01 18:37:12 EST'::timestamptz) AS tz,
    date_part('week', '2022-12-01 18:37:12 EST'::timestamptz) AS week,
    date_part('quarter', '2022-12-01 18:37:12 EST'::timestamptz) AS quarter,
    date_part('epoch', '2022-12-01 18:37:12 EST'::timestamptz) AS epoch;

-- Extract works similar to date_part
SELECT extract(year from '2022-12-01 18:37:12 EST'::timestamptz) AS year;

-- This command makes a date based on normal date rules
SELECT make_date(2022, 2, 22); -- If you punt 2022, 2, 29, it doesn't work

-- This command makes hour-minute-second times, with terminal 
SELECT make_time(18, 4, 30.3);

-- This command makes a full timestamp, with a time zone according to geographic location given
SELECT make_timestamptz(2022, 2, 22, 18, 4, 30.3, 'Europe/Lisbon');

-- You can get the current timestamp, local, date, time, and time
SELECT
    current_timestamp,
    localtimestamp, --Doesn't give timezone
    current_date,
    current_time,
    localtime, --Doesn't give timezone
    now();

-- Get current timezone (According to machine?)
SELECT current_setting('timezone'); -- Can be used to create timestamptz

-- Get all timezones by abbreviation and name (continent / city)
SELECT * FROM pg_timezone_abbrevs ORDER BY abbrev;
SELECT * FROM pg_timezone_names ORDER BY name;


--You can change the Time Zone used by the database with:
SET TIME ZONE 'US/Pacific'; -- The QUERYs will change the date accordingly, 2023-01-01 4:00
-- SET TIME ZONE 'US/Eastern'; 2023-01-01 07:00:00-05

-- You can get the value of the interval of dates
SELECT '1929-09-30'::date - '1929-09-27'::date; -- You are substracting from both dates to get an integer
-- You can also add to dates with an interval
SELECT '1929-09-30'::date + '5 years'::interval; -- You are adding to the date 5 years

-- You can include specific parts of a timestamp for QUERYs
SELECT
    date_part('hour', tpep_pickup_datetime) AS trip_hour,
    count(*) as trip_number
FROM nyc_yellow_taxi_trips
GROUP BY trip_hour
ORDER BY trip_number desc;


--Challenge: Calculate the length of each ride, sort from the longest to the shortest

SELECT trip_id,
	tpep_dropoff_datetime - tpep_pickup_datetime  as trip_length
FROM nyc_yellow_taxi_trips
ORDER BY trip_length desc limit 10;
