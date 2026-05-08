SELECT *
FROM maximal-plate-492011-g5.fitbit_031226_041226.dailyActivity
LIMIT 10;

--sort data
SELECT *
FROM daily_activity
ORDER BY Id, ActivityDate;

SELECT *
FROM sleep_day
ORDER BY Id, SleepDay;

SELECT *
FROM hourly_steps
ORDER BY Id, ActivityHour;

--убедиться, что данные идут хронологически и нет «сломанных» дат.
--date validation
SELECT 
    MIN(ActivityDate) AS min_date,
    MAX(ActivityDate) AS max_date
FROM daily_activity;

SELECT 
    MIN(SleepDay),
    MAX(SleepDay)
FROM sleep_day;

--unique users
SELECT COUNT(DISTINCT Id) AS unique_users
FROM daily_activity;

SELECT COUNT(DISTINCT Id) AS unique_users
FROM sleep_day;

SELECT COUNT(DISTINCT Id) AS unique_users
FROM hourly_steps;
--показать, что не все пользователи используют все функции

--check dupliates
SELECT Id, ActivityDate, COUNT(*) AS duplicates
FROM daily_activity
GROUP BY Id, ActivityDate
HAVING COUNT(*) > 1;

SELECT Id, SleepDay, COUNT(*) AS duplicates
FROM sleep_day
GROUP BY Id, SleepDay
HAVING COUNT(*) > 1;

--check NULL values
SELECT *
FROM daily_activity
WHERE TotalSteps IS NULL
   OR Calories IS NULL
   OR TotalDistance IS NULL;

SELECT *
FROM sleep_day
WHERE TotalMinutesAsleep IS NULL
   OR TotalTimeInBed IS NULL;

--check 0 values
SELECT *
FROM daily_activity
WHERE TotalSteps = 0;

SELECT *
FROM daily_activity
WHERE Calories = 0;

SELECT *
FROM sleep_day
WHERE TotalMinutesAsleep = 0;

--amount of days per user
SELECT 
    Id,
    COUNT(DISTINCT ActivityDate) AS active_days
FROM daily_activity
GROUP BY Id
ORDER BY active_days;
--найти пользователей с очень малым количеством данных.

--check users with less than 10 days
SELECT *
FROM (
    SELECT Id, COUNT(DISTINCT ActivityDate) AS active_days
    FROM daily_activity
    GROUP BY Id
) t
WHERE active_days < 10;
--low involvement

--compare the users
SELECT DISTINCT Id
FROM daily_activity
WHERE Id NOT IN (
    SELECT DISTINCT Id FROM sleep_day
);
