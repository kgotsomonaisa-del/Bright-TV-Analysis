------------------------------------------------------------------------------------------------------------------------------------------------------
-----Viewership SQL Code
------------------------------------------------------------------------------------------------------------------------------------------------------
select * from workspace.brighttv.viewership limit 10;

-------------------------------------------------------------------------
---1. Retrieving the first ten rows of the viewership table
-------------------------------------------------------------------------
select * from `workspace`.`brighttv`.`viewership` limit 10;



-------------------------------------------------------------------------
---2. counting all rows in the viewership table
-------------------------------------------------------------------------
---there are 10 000 rows in the table
select count(*) from `workspace`.`brighttv`.`viewership`;



-------------------------------------------------------------------------
---3. retreiving distinct channels from the viewership table
-------------------------------------------------------------------------
---there are 21 channel2 distinct channels in the table
select distinct Channel2 
from `workspace`.`brighttv`.`viewership`;

-----------------------------------------------------------------------------------------------------------------------
---4. Retreiving data on the recording date, day name, month name, day of month, day classification, recording buckets
-----------------------------------------------------------------------------------------------------------------------
select
---Dates
      RecordDate2 as recording_date,
      Dayname(RecordDate2) as day_name,
      Monthname(RecordDate2) as month_name,
      Dayofmonth(RecordDate2) as day_of_month,
      case
          when Dayname(RecordDate2) in ('Sun' , 'Sat') then 'Weekend'
          else 'Weekday'
          end as day_of_recording,

-------------------------------------------------------------------------------
---5. Converting Duration from Global time (UTC) to South African time (SAST)
---------------------------------------------------------------------------------
select `Duration 2` as global_time,
      from_utc_timestamp(`Duration 2`, 'Africa/Johannesburg') AS south_african_time
from `workspace`.`brighttv`.`viewership`;


------------------------------------------------------------------------------------          
---6. date_format(recording_time, 'HH:mm:ss') as recording_time
------------------------------------------------------------------------------------
select 
    case
          when date_format(`Duration 2`, 'HH:mm:ss') between '00:00:00' and '11:59:59' then 'Morning'
          when date_format(`Duration 2`, 'HH:mm:ss') between '12:00:00' and '16:59:59' then 'Afternoon'
          when date_format(`Duration 2`, 'HH:mm:ss') >= '17:00:00' then 'Evening'
          end as duration_buckets
      from `workspace`.`brighttv`.`viewership`
    
---------------------------------------------------------------------------------
---7. retrieving all total views
---------------------------------------------------------------------------------
    select
      Channel2,
      count(*) as total_views
      from `workspace`.`brighttv`.`viewership`
      group by Channel2;


---------------------------------------------------------------------------------
---8. converting the time from UTC South African time (SAST)
---------------------------------------------------------------------------------     
select 
    `Duration 2` as Duration_2_utc,
    from_utc_timestamp(`Duration 2`, 'Africa/Johannesburg') AS duration_time_sast
from `workspace`.`brighttv`.`viewership`;


------------------------------------------------------------------------------------------------------------------
---9. converting the time from UTC to SAST and creating a duration bucket column
------------------------------------------------------------------------------------------------------------------
select 
    `Duration 2` as Duration_2_utc,
    from_utc_timestamp(`Duration 2`, 'Africa/Johannesburg') AS duration_time_sast,
    case
        when date_format(`Duration 2`, 'HH:mm:ss') between '00:00:00' and '11:59:59' then 'Morning'
        when date_format(`Duration 2`, 'HH:mm:ss') between '12:00:00' and '16:59:59' then 'Afternoon'
        when date_format(`Duration 2`, 'HH:mm:ss') >= '17:00:00' then 'Evening'
    end as duration_buckets
from `workspace`.`brighttv`.`viewership`;

------------------------------------------------------------------------------------------------------------------------------------------------------
-----User Profile SQL Code
------------------------------------------------------------------------------------------------------------------------------------------------------
select *  from workspace.brighttv.user_profiles limit 10

--------------------------------------------------------------------------
---1. Retrieving the first ten rows of the user_profiles table
--------------------------------------------------------------------------
select * from `workspace`.`brighttv`.`user_profiles` limit 10;

---------------------------------------------------------------------------
---2. counting all the rows in the user_profile table
---------------------------------------------------------------------------
---there are 5375 rows in the user_profile table
select count(*) 
from `workspace`.`brighttv`.`user_profiles`;

---------------------------------------------------------------------------
---3. Joining the user_profile and viewership tables using INNER JOIN
---------------------------------------------------------------------------

select * 
from `workspace`.`brighttv`.`user_profiles` as up
inner join `workspace`.`brighttv`.`viewership` as v
on up.userID = v.userid4;

--------------------------------------------------------------------------------------
---4. viewing distinct race from the user_profile table
--------------------------------------------------------------------------------------
select distinct race 
from `workspace`.`brighttv`.`user_profiles`;

--------------------------------------------------------------------------------------
---5. viewing distinct gender from the user_profile table
--------------------------------------------------------------------------------------
select distinct Gender 
from `workspace`.`brighttv`.`user_profiles`;

--------------------------------------------------------------------------------------
---6. Removing spaces (TRIM)
--------------------------------------------------------------------------------------
SELECT
    TRIM(Name) AS Name,
    TRIM(Surname) AS Surname
FROM `workspace`.`brighttv`.`user_profiles`;

--------------------------------------------------------------------------------------
---7. handling missing values
--------------------------------------------------------------------------------------
SELECT
    COALESCE(TRIM(Name), 'Unknown') AS Name,
    COALESCE(TRIM(Surname), 'Unknown') AS Surname
FROM `workspace`.`brighttv`.`user_profiles`;

--------------------------------------------------------------------------------------
---8. stabdardise gender
--------------------------------------------------------------------------------------
SELECT
    CASE 
        WHEN LOWER(TRIM(Gender)) IN ('m', 'male') THEN 'Male'
        WHEN LOWER(TRIM(Gender)) IN ('f', 'female') THEN 'Female'
        ELSE 'Not Specified'
    END AS Gender
FROM `workspace`.`brighttv`.`user_profiles`;

--------------------------------------------------------------------------------------
---9. Fixing Province names
--------------------------------------------------------------------------------------
SELECT
    CASE 
        WHEN LOWER(TRIM(Province)) = 'kwazulu natal' THEN 'KwaZulu-Natal'
        WHEN Province IS NULL OR TRIM(Province) = '' THEN 'Unknown'
        ELSE TRIM(Province)
    END AS Province
FROM `workspace`.`brighttv`.`user_profiles`;

--------------------------------------------------------------------------------------
---10. Clean age
--------------------------------------------------------------------------------------
SELECT
    CASE 
        WHEN Age < 0 OR Age > 100 THEN NULL
        ELSE Age
    END AS Age
FROM `workspace`.`brighttv`.`user_profiles`;

--------------------------------------------------------------------------------------
---11. Validate Email
--------------------------------------------------------------------------------------
SELECT
    CASE 
        WHEN Email LIKE '%@%' THEN TRIM(Email)
        ELSE NULL
    END AS Email
FROM `workspace`.`brighttv`.`user_profiles`;

--------------------------------------------------------------------------------------
---12. Combining all codes into one
--------------------------------------------------------------------------------------
SELECT
    up.UserID,
---Dates
    v.RecordDate2 as recording_date,
    Dayname(v.RecordDate2) as day_name,
    Monthname(v.RecordDate2) as month_name,
    Dayofmonth(v.RecordDate2) as day_of_month,
    CASE
        WHEN Dayname(v.RecordDate2) in ('Sun' , 'Sat') THEN 'Weekend'
        ELSE 'Weekday'
    END as day_of_recording,
    Year(v.RecordDate2) as year,
    v.`Duration 2` as duration,
    CASE
        WHEN date_format(v.`Duration 2`, 'HH:mm:ss') between '00:00:00' and '11:59:59' THEN 'Morning'
        WHEN date_format(v.`Duration 2`, 'HH:mm:ss') between '12:00:00' and '16:59:59' THEN 'Afternoon'
        WHEN date_format(v.`Duration 2`, 'HH:mm:ss') >= '17:00:00' THEN 'Evening'
    END as duration_buckets,
    v.Channel2,
    from_utc_timestamp(v.`Duration 2`, 'Africa/Johannesburg') AS converted_time,
---cleaning name
    COALESCE(TRIM(up.Name), 'Unknown') AS Name,
    COALESCE(TRIM(up.Surname), 'Unknown') AS Surname,
---cleaning gender
    CASE 
        WHEN LOWER(TRIM(up.Gender)) IN ('m', 'male') THEN 'Male'
        WHEN LOWER(TRIM(up.Gender)) IN ('f', 'female') THEN 'Female'
        ELSE 'Not Specified'
    END AS Gender,
---cleaning race
    COALESCE(TRIM(up.Race), 'Not Specified') AS Race,
---cleaning age
    CASE 
        WHEN up.Age < 0 OR up.Age > 100 THEN NULL
        ELSE up.Age
    END AS Age,
---Fixing Province names
    CASE 
        WHEN LOWER(TRIM(up.Province)) = 'kwazulu natal' THEN 'KwaZulu-Natal'
        WHEN up.Province IS NULL OR TRIM(up.Province) = '' THEN 'Unknown'
        ELSE TRIM(up.Province)
    END AS Province,
---validating email
    CASE 
        WHEN up.Email LIKE '%@%' THEN TRIM(up.Email)
        ELSE NULL
    END AS Email,
---cleaning social media
    COALESCE(TRIM(up.`Social Media Handle`), 'N/A') AS Social_Media_Handle
FROM `workspace`.`brighttv`.`user_profiles` as up
INNER JOIN `workspace`.`brighttv`.`viewership` as v
ON up.userID = v.userid4;

--------------------------------------------------------------------------------------
---13. Removing duplicates
--------------------------------------------------------------------------------------
CREATE OR REPLACE TABLE `workspace`.`brighttv`.`bright_tv_final` AS
SELECT *
FROM (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY UserID ORDER BY UserID) AS rn
    FROM `workspace`.`brighttv`.`bright_tv_cleaned`
)
WHERE rn = 1;

--------------------------------------------------------------------------------------
---14. Removing duplicates
--------------------------------------------------------------------------------------
SELECT
    COUNT(*) AS total_rows,
    COUNT(CASE WHEN Name = 'Unknown' THEN 1 END) AS unknown_names,
    COUNT(CASE WHEN Gender = 'Not Specified' THEN 1 END) AS missing_gender
FROM `workspace`.`brighttv`.`user_profiles`;

--------------------------------------------------------------------------------------
---14. Retrieving the nuber of veiwers per province
--------------------------------------------------------------------------------------
select Province, count(distinct UserID) as viewers_per_province
from `workspace`.`brighttv`.`user_profiles`
group by Province
order by viewers_per_province desc

--------------------------------------------------------------------------------------
---15. Retrieving the nuber of veiwers per province
--------------------------------------------------------------------------------------














