-- create clean table for daily activity
CREATE OR REPLACE TABLE daily_activity_clean AS
SELECT
  CAST(Id AS INT64) AS user_id,
  PARSE_DATE('%m/%d/%Y', ActivityDate) AS activity_date,
  CAST(TotalSteps AS INT64) AS total_steps,
  CAST(TotalDistance AS FLOAT64) AS total_distance,
  CAST(VeryActiveDistance AS FLOAT64) AS very_active_distance,
  CAST(ModeratelyActiveDistance AS FLOAT64) AS moderately_active_distance,
  CAST(LightActiveDistance AS FLOAT64) AS light_active_distance,
  CAST(SedentaryActiveDistance AS FLOAT64) AS sedentary_distance,
  CAST(VeryActiveMinutes AS INT64) AS very_active_minutes,
  CAST(FairlyActiveMinutes AS INT64) AS fairly_active_minutes,
  CAST(LightlyActiveMinutes AS INT64) AS lightly_active_minutes,
  CAST(SedentaryMinutes AS INT64) AS sedentary_minutes,
  CAST(Calories AS INT64) AS calories
FROM raw_daily_activity; 

-- Remove duplicates
CREATE OR REPLACE TABLE `maximal-plate-492011-g5.fitbit_031226_041226.daily_activity_clean` AS
SELECT
  user_id,
  activity_date,
  MAX(total_steps) AS total_steps,
  MAX(total_distance) AS total_distance,
  MAX(tracker_distance) AS tracker_distance,
  MAX(logged_activities_distance) AS logged_activities_distance,
  MAX(moderately_active_distance) AS moderately_active_distance,
  MAX(sedentary_distance) AS sedentary_distance,
  MAX(very_active_minutes) AS very_active_minutes,
  MAX(fairly_active_minutes) AS fairly_active_minutes,
  MAX(lightly_active_minutes) AS lightly_active_minutes,
  MAX(sedentary_minutes) AS sedentary_minutes,
  MAX(calories) AS calories
FROM `maximal-plate-492011-g5.fitbit_031226_041226.daily_activity_clean`
GROUP BY user_id, activity_date;

SELECT user_id, activity_date, COUNT(*) AS duplicates
FROM `maximal-plate-492011-g5.fitbit_031226_041226.daily_activity_clean`
GROUP BY user_id, activity_date
HAVING COUNT(*) > 1;

--remove impossible data, like negative steps or calories
CREATE OR REPLACE TABLE daily_activity_clean AS
SELECT *
FROM daily_activity_clean
WHERE total_steps >= 0
AND calories >= 0;

--create sleep table
CREATE OR REPLACE TABLE sleep_day_clean AS
SELECT
  CAST(Id AS INT64) AS user_id,
  PARSE_TIMESTAMP('%m/%d/%Y %I:%M:%S %p', SleepDay) AS sleep_datetime,
  CAST(TotalSleepRecords AS INT64) AS sleep_records,
  CAST(TotalMinutesAsleep AS INT64) AS minutes_asleep,
  CAST(TotalTimeInBed AS INT64) AS time_in_bed
FROM raw_sleep_day;

--correct the timestamp
CREATE OR REPLACE TABLE sleep_day_clean AS
SELECT
  user_id,
  DATE(sleep_datetime) AS sleep_date,
  minutes_asleep,
  time_in_bed
FROM sleep_day_clean;

--check sleep duplicates
SELECT user_id, sleep_date, COUNT(*)
FROM sleep_day_clean
GROUP BY user_id, sleep_date
HAVING COUNT(*) > 1;

CREATE OR REPLACE TABLE sleep_day_clean AS
SELECT DISTINCT *
FROM sleep_day_clean;

--clean weight table
CREATE OR REPLACE TABLE weight_log_clean AS
SELECT
  CAST(Id AS INT64) AS user_id,
  PARSE_TIMESTAMP('%m/%d/%Y %I:%M:%S %p', Date) AS weight_datetime,
  CAST(WeightKg AS FLOAT64) AS weight_kg,
  CAST(BMI AS FLOAT64) AS bmi
FROM raw_weight_log
WHERE WeightKg IS NOT NULL;

--add date
CREATE OR REPLACE TABLE weight_log_clean AS
SELECT
  user_id,
  DATE(weight_datetime) AS weight_date,
  weight_kg,
  bmi
FROM weight_log_clean;

--check final tables
SELECT COUNT(DISTINCT user_id) FROM daily_activity_clean;
SELECT COUNT(DISTINCT user_id) FROM sleep_day_clean;
SELECT COUNT(DISTINCT user_id) FROM weight_log_clean;

SELECT COUNT(*) FROM daily_activity_clean;
SELECT COUNT(*) FROM sleep_day_clean;
SELECT COUNT(*) FROM weight_log_clean;

CREATE OR REPLACE TABLE `maximal-plate-492011-g5.fitbit_031226_041226.daily_activity_clean` AS
SELECT DISTINCT *
FROM `maximal-plate-492011-g5.fitbit_031226_041226.daily_activity_clean`;

--removing duplicates (keys)
CREATE OR REPLACE TABLE `maximal-plate-492011-g5.fitbit_031226_041226.daily_activity_clean` AS
SELECT
  user_id,
  activity_date,
  MAX(total_steps) AS total_steps,
  MAX(total_distance) AS total_distance,
  MAX(tracker_distance) AS tracker_distance,
  MAX(logged_activities_distance) AS logged_activities_distance,
  MAX(moderately_active_distance) AS moderately_active_distance,
  MAX(sedentary_distance) AS sedentary_distance,
  MAX(very_active_minutes) AS very_active_minutes,
  MAX(fairly_active_minutes) AS fairly_active_minutes,
  MAX(lightly_active_minutes) AS lightly_active_minutes,
  MAX(sedentary_minutes) AS sedentary_minutes,
  MAX(calories) AS calories
FROM `maximal-plate-492011-g5.fitbit_031226_041226.daily_activity_clean`
GROUP BY user_id, activity_date;

SELECT user_id, activity_date, COUNT(*) AS duplicates
FROM `maximal-plate-492011-g5.fitbit_031226_041226.daily_activity_clean`
GROUP BY user_id, activity_date
HAVING COUNT(*) > 1;

SELECT user_id, sleep_date, COUNT(*) AS duplicates
FROM `maximal-plate-492011-g5.fitbit_031226_041226.sleep_day_clean`
GROUP BY user_id, sleep_date
HAVING COUNT(*) > 1;

CREATE OR REPLACE TABLE `maximal-plate-492011-g5.fitbit_031226_041226.sleep_day_clean` AS
SELECT
  user_id,
  sleep_date,
  MAX(minutes_asleep) AS minutes_asleep,
  MAX(time_in_bed) AS time_in_bed
FROM `maximal-plate-492011-g5.fitbit_031226_041226.sleep_day_clean`
GROUP BY user_id, sleep_date;

-- Standardize date formats
CREATE OR REPLACE TABLE `maximal-plate-492011-g5.fitbit_031226_041226.sleep_day_clean` AS
SELECT
  CAST(Id AS INT64) AS user_id,
  DATE(PARSE_TIMESTAMP('%m/%d/%Y %I:%M:%S %p', SleepDay)) AS sleep_date,
  CAST(TotalSleepRecords AS INT64) AS sleep_records,
  CAST(TotalMinutesAsleep AS INT64) AS minutes_asleep,
  CAST(TotalTimeInBed AS INT64) AS time_in_bed
FROM `maximal-plate-492011-g5.fitbit_031226_041226.sleepDay`;

--create clean weight table
CREATE OR REPLACE TABLE `maximal-plate-492011-g5.fitbit_031226_041226.weight_log_clean` AS
SELECT
  CAST(Id AS INT64) AS user_id,
  DATE(PARSE_TIMESTAMP('%m/%d/%Y %I:%M:%S %p', Date)) AS weight_date,
  CAST(WeightKg AS FLOAT64) AS weight_kg,
  CAST(BMI AS FLOAT64) AS bmi
FROM `maximal-plate-492011-g5.fitbit_031226_041226.raw_weightInfo`
WHERE WeightKg IS NOT NULL;

--check duplicates
SELECT user_id, weight_date, COUNT(*) AS duplicates
FROM `maximal-plate-492011-g5.fitbit_031226_041226.weight_log_clean`
GROUP BY user_id, weight_date
HAVING COUNT(*) > 1;

--aggregate duplicates
CREATE OR REPLACE TABLE `maximal-plate-492011-g5.fitbit_031226_041226.weight_log_clean` AS
SELECT
  user_id,
  weight_date,
  MAX(weight_kg) AS weight_kg,
  MAX(bmi) AS bmi
FROM `maximal-plate-492011-g5.fitbit_031226_041226.weight_log_clean`
GROUP BY user_id, weight_date;

-- Handle missing values
SELECT *
FROM `maximal-plate-492011-g5.fitbit_031226_041226.daily_activity_clean`
WHERE TotalSteps IS NULL
   OR Calories IS NULL
   OR TotalDistance IS NULL;

SELECT *
FROM `maximal-plate-492011-g5.fitbit_031226_041226.sleep_day_clean`
WHERE TotalMinutesAsleep IS NULL
   OR TotalTimeInBed IS NULL;



--check final tables number of users and number of rows
SELECT COUNT(DISTINCT user_id) FROM `maximal-plate-492011-g5.fitbit_031226_041226.daily_activity_clean`;
SELECT COUNT(DISTINCT user_id) FROM `maximal-plate-492011-g5.fitbit_031226_041226.sleep_day_clean`;
SELECT COUNT(DISTINCT user_id) FROM `maximal-plate-492011-g5.fitbit_031226_041226.weight_log_clean`;

SELECT COUNT(*) FROM `maximal-plate-492011-g5.fitbit_031226_041226.daily_activity_clean`;
SELECT COUNT(*) FROM `maximal-plate-492011-g5.fitbit_031226_041226.sleep_day_clean`;
SELECT COUNT(*) FROM `maximal-plate-492011-g5.fitbit_031226_041226.weight_log_clean`;
