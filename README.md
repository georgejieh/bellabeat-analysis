# Google Data Analytics Case Study 2: How Can a Wellness Technology Company Play It Smart?

![img](https://i.imgur.com/0Dtva0S.png)

## Introduction

Bellabeat is a high-tech manufacturer of health-focused products for women. Currently it is a sucessful small business, but have potential to become a larger player in the global smart device market. The cofundouner and Chief Creative Officer of Bellabeat, Urska Srsen, believes that by analyzing smart device fitness data could help find new growth for the company. The case study wants us to pick one of Bellabeat's products and analyze comparible smart device data to gain insight into how consumers are using their smart devices. With the analysis come up with high-level recommendations for marketing strategy.

## Ask Phase

#### Business Task

Analyze smart device usage data in order to gain insight into how consumers use non-Bellabeat smart devices then apply the findings to one of Bellabeat's products. What are the rends in smart device usage and how do they apply to Bellabeat customers? How could these trends influence Bellabeat marketing strategy?

#### Key Stake Holders

- **Urska Srsen:** Bellabeat's cofounder and Chief Creative Officer
- **Sando Mur:** Key executive team member, Mathematician, and Bellabeat's cofounder
- **Bellabeat marketing analytics team**

## Prepare Phase

The non-Bellabeat smart device data we will be using is [FitBit's data set](https://www.kaggle.com/datasets/arashnic/fitbit) that is available on Kaggle.The data set contains physical activity, heart rate, and sleep data from 30 users. The downloaded zip file was placed into /bellabeat-analysis/fitbit-raw-data/zip-files. The unziped CSV files are then placed into /bellabeat-analysis/fitbit-raw-data/csv-files.

Looking at the CSV files we can see a lot of limitations with this data set. To put it simply, the sample size is too small. 30 users by itself is a decent size to do some basic analysis, however not all tables have 30 users. For example the amount of users in daily_activity.csv that also appears in weight_log.csv is only 8. Also the time span that the data was collected was also too short. The duration of sample collection was for 2 months. This lack of sample size will pose problems when we analyze certain categories. The best example of this is any analysis related to weight_log.csv. Two months is not long enough for any one person to lose statistically significant amount of weight unless they put themselves on some intense weightloss program. So we will be unable to analyze the effects of activity and calories burned to weight lost. The low number of users tracked on weight_log.csv also makes it hard to come up with any statistically conclusive trend based on BMI categories. This can be shown by the fact that there is only one individual that is considered severely obsese and no one is considered underweight.    

## Process and Analyze Phase

The tools that would be used to process the data is primarily SQL with a little bit of Excel. The reason why we use SQL is because a lot of the tables have over 1 million rows of data, which Excel cannot handle. We've only used excel to standardize some row values and names across the following three tables, daily_activity.csv, daily_sleep_data.csv, and weight_log.csv. These three tables will be used for R analysis later on so they are saved in the diretor /bellabeat-analysis/R-analysis/csv-for-import.

Since the data in general is clean so we've combined the process and analyze phase. Most data imported into SQL and R could immediately be used for analysis. 

#### SQL Processing and Analysis

The SQL language used is pSQL due to acessibility. To start out with SQL we need to build the schema to import our table into. The schema I ended up deciding is the following:

```sql
CREATE TABLE daily_activity
	(
		user_id BIGINT NOT NULL,
		activity_date DATE NOT NULL,
		total_steps INTEGER,
		total_distance REAL,
		tracker_distance REAL,
		logged_activities_distance REAL,
		very_active_distance REAL,
		moderately_active_distance REAL,
		lightly_active_distance REAL,
		sedentary_active_distance REAL,
		very_active_min SMALLINT,
		moderately_active_min SMALLINT,
		lightly_active_min SMALLINT,
		sedentary_active_min SMALLINT,
		calories SMALLINT
	);

CREATE TABLE heart_rate
	(
		user_id BIGINT NOT NULL,
		time_stamp TIMESTAMP NOT NULL,
		five_second_heart_rate SMALLINT NOT NULL
	);
	
CREATE TABLE hourly_activity
	(
		user_id BIGINT NOT NULL,
		time_stamp TIMESTAMP NOT NULL,
		total_steps SMALLINT,
		total_intensity SMALLINT,
		avg_intensity REAL,
		calories SMALLINT
	);

CREATE TABLE activity_per_minute
	(
		user_id BIGINT NOT NULL,
		time_stamp TIMESTAMP NOT NULL,
		steps SMALLINT,
		intensity SMALLINT,
		metabolic_rate SMALLINT,
		calories REAL
	);
	
CREATE TABLE daily_sleep_data
	(
		user_id BIGINT NOT NULL,
		sleep_date DATE NOT NULL,
		minutes_asleep SMALLINT,
		minutes_in_bed SMALLINT
	);

CREATE TABLE weight_log
	(
		user_id BIGINT NOT NULL,
		weigh_date DATE NOT NULL,
		weight_kg REAL,
		weight_lb REAL,
		BMI REAL,
		manual_report BOOLEAN
	);
```

The way the tables are presented there is no way to use primary keys and foreign keys. The user ids recpeats itself for each instance of entry. Dates and time stamps could be used as keys but since there are rows in tables that doesn't have the same time stamp as others it would cause data to be deleted. To keep data integrity, it would be best to not have keys set. 

The next step is to import the tables into the database. To do so the following queries were used:

```sql
COPY daily_activity FROM
'/.../bellabeat-analysis/fitbit-raw-data/csv-files/daily_activity.csv' CSV HEADER;

COPY heart_rate FROM
'/.../bellabeat-analysis/fitbit-raw-data/csv-files/heart_rate_per_5_second_intervals.csv' CSV HEADER;

COPY hourly_activity FROM
'/.../bellabeat-analysis/processed-data/csv-files/hourly_activity.csv' CSV HEADER;

COPY activity_per_minute FROM
'/.../bellabeat-analysis/processed-data/csv-files/activity_per_minute.csv' CSV HEADER;

COPY daily_sleep_data FROM 
'/.../bellabeat-analysis/processed-data/csv-files/daily_sleep_data.csv' CSV HEADER;

COPY weight_log FROM
'/.../bellabeat-analysis/processed-data/csv-files/weight_log.csv' CSV HEADER;
```

Once the data is imported we check to make sure there isn't anything wrong with the data with the following queries:

```sql
SELECT COUNT(*) FROM activity_per_minute;
SELECT COUNT(*) FROM hourly_activity;
SELECT COUNT(*) FROM daily_activity;
SELECT COUNT(*) FROM daily_sleep_data;
SELECT COUNT(*) FROM weight_log;
SELECT COUNT(*) FROM heart_rate;
```

The results are as follow:

| Table               | Count   |
| ------------------- | ------- |
| activity_per_minute | 1048575 |
| hourly_activity     | 22099   |
| daily_activity      | 940     |
| daily_sleep_data    | 413     |
| weight_log          | 67      |
| heart_rate          | 2483658 |

Then we count the number of unique users in each table with the following queries:

```sql
SELECT COUNT(DISTINCT user_id) FROM activity_per_minute;
SELECT COUNT(DISTINCT user_id) FROM hourly_activity;
SELECT COUNT(DISTINCT user_id) FROM daily_activity;
SELECT COUNT(DISTINCT user_id) FROM daily_sleep_data;
SELECT COUNT(DISTINCT user_id) FROM weight_log;
SELECT COUNT(DISTINCT user_id) FROM heart_rate;
```

The results are as follow:

| Table               | Count |
| ------------------- | ----- |
| activity_per_minute | 27    |
| hourly_activity     | 33    |
| daily_activity      | 33    |
| daily_sleep_data    | 24    |
| weight_log          | 8     |
| heart_rate          | 14    |

From these numbers we see the issues that were brought up during prepare phase. The sample size is way too small and the number of users recorded isn't equal across all tables. You also have 33 users for hourly and daily activity table, which doesn't make a whole lot of sense since the dataset should at maximum only contain 30 users. It is difficult to explain the discrepency of user counts between each table. A possible explanation is that some tables use different fitbit products or features of products that the others don't have or use. For example the weight_log data is most likely from fitbit's smart scales line and the weight logging feature of the fitbit app. If a user doesn't have the aforementioned product or use the weight feature on their app then there won't be a record of it. The same an be said for heart rate data and sleep data. All fitbit products track heart rate, sleep data, and activity, however if a customer only have the app then heart rate might not be available and sleep tracking may not be a feature that is turned on. What is more suprising is the difference in user count between activity per minute and the rest of the activity tracking categories since no matter which fitbit product a user uses they should all be tracked at the same time.    

After we verified the data integrity we will be doing some basic summary statistics. For this we will include a custom median function as well with the following query:

```sql
CREATE OR REPLACE FUNCTION _final_median(numeric[])
   RETURNS numeric AS
$$
   SELECT AVG(val)
   FROM (
     SELECT val
     FROM unnest($1) val
     ORDER BY 1
     LIMIT  2 - MOD(array_upper($1, 1), 2)
     OFFSET CEIL(array_upper($1, 1) / 2.0) - 1
   ) sub;
$$
LANGUAGE 'sql' IMMUTABLE;

CREATE AGGREGATE median(numeric) (
  SFUNC=array_append,
  STYPE=numeric[],
  FINALFUNC=_final_median,
  INITCOND='{}'
);
```

Since there are multiple tables and the query can get quite long I will only be showing one of the may queries as example for summary statistics. Below is the summary statistics query for the table activity_per_minute:

```sql
SELECT user_id, 
	ROUND(CAST(AVG(steps) AS NUMERIC),3) AS avg_steps, 
	ROUND(CAST(AVG(intensity) AS NUMERIC),3) AS avg_intensity, 
	ROUND(CAST(AVG(metabolic_rate) AS NUMERIC),3) AS avg_metabolic_rate, 
	ROUND(CAST(AVG(calories) AS NUMERIC),3) AS avg_calories,
	ROUND(median(CAST(steps AS NUMERIC)),3) AS median_steps, 
	ROUND(median(CAST(intensity AS NUMERIC)),3) AS median_intensity, 
	ROUND(median(CAST(metabolic_rate AS NUMERIC)),3) AS median_metabolic_rate, 
	ROUND(median(CAST(calories AS NUMERIC)),3) AS median_calories,
	ROUND(MIN(CAST(steps AS NUMERIC)),3) AS min_steps, 
	ROUND(MIN(CAST(intensity AS NUMERIC)),3) AS min_intensity, 
	ROUND(MIN(CAST(metabolic_rate AS NUMERIC)),3) AS min_metabolic_rate, 
	ROUND(MIN(CAST(calories AS NUMERIC)),3) AS min_calories,
	ROUND(MAX(CAST(steps AS NUMERIC)),3) AS max_steps, 
	ROUND(MAX(CAST(intensity AS NUMERIC)),3) AS max_intensity, 
	ROUND(MAX(CAST(metabolic_rate AS NUMERIC)),3) AS max_metabolic_rate, 
	ROUND(MAX(CAST(calories AS NUMERIC)),3) AS max_calories
FROM activity_per_minute
GROUP BY user_id;
```

CAST() function is used here because the data type for some of the columns run into issues when not made into a numeric type, such as the custom median function. 

To fully understand what intensity means and what makes something sedentary, lightly active, moderately active, and very active we need to look at the query below:

```sql
SELECT intensity, 
	avg(steps) AS avg_steps, 
	avg(metabolic_rate) AS avg_METS, 
	avg(calories)AS avg_calories, 
	avg(five_second_heart_rate) AS avg_heart_rate
FROM activity_per_minute apm
JOIN heart_rate hr 
	ON hr.time_stamp = apm.time_stamp 
	AND hr.user_id = apm.user_id
GROUP BY intensity
ORDER BY intensity;
```

This query combines intensity value with heart rate data. The import part of the results to look at is the following:

| Intensity Level | Average Heart Rate Per Minute |
| --------------- | ----------------------------- |
| 0               | 67.48                         |
| 1               | 85.95                         |
| 2               | 100.96                        |
| 3               | 116.23                        |

From here we can infer that 0 means sedentary, 1 is lightly active, 2 is moderate, and 3 is very active. Without knowing the actual age of each individual it is hard to determine how accurate the intensity levels are, but one thing we do know is that for most adults, only while exercising will you get a 100 or higher heart rate per minute. We also know that light to very light activity for a 30 to 40 year old will result in a heart rate of around 90 beats per minute. 

Armed with this knowledge we know that for 0 intensity in a hour means sedentary, 60 intensity in a hour equals to light activity, 120 intensity in a hour is moderate, and 180 intensity in a hour is very active. 

Now armed with this knowledge we can start looking at our statistics summary. Another point we should realize is, depending on how a user tracks their activity, their daily sedentary time length will include the time they are asleep.

So here is what we learned from the sql summary statistics:

- When calculated by minutes, all users a prone to being sedentary. 
- When calculated by hours, all users are between sedentary to lightly active.
- Individuals that have over 10 thousand steps per day tends to burn more than 2000 calories per day. There are exceptions to this rule since calories burned can be effected by metabolism rate, which is different for everyone. 

To give a good idea of how burned calories is calculated by the trackers we need to understand the relationship between metabolism rate, also known as METs, and calories burned. Using the termanology given by the dataset A METs of 1 to 2 is sedentary, light activity is between 2 to 4, medium activity is between 4 to 6, and anything 6 and above is very active. Once you know the approximate METs for the activity you are doing then the equation to calulate the amount of calories burned per minute is as follows:


$$
CaloriesPerMinute=\frac{METs\times3.5\times WeightInKg}{200}
$$


For example if an individual weighs 70 kg and goes on a regular bicycle ride (METs of 8) for a hour the equation will look like this:


$$
(\frac{8 \times 3.5 \times 70}{200})\times 60 = 588
$$


That individual will burn 588 calories for the hour. This brings back to my point that since activity type and the weight of an individual is a variable in calculating amount of calories burned, it is difficult to simply say having a daily amount of steps over X amount will burn X amount of calories. However looking at how METs is tracked in the tables, fitbit is not tracking METs based on common knowledge since the minimum METs that fitbit set per user is 10, which based on various reference charts found online is equivalent to running a 10 minute mile. This we know is impossible considering the user is sedentary at the time. 

Considering the METs that fitbit recorded is useless in determining calories burned per minute, the only other value we have that can determine calories burned is heart rate. With heart rate, depending on if the system knows your VO~2~ max and your gender, different equations would be used. If the system doesn't track VO~2~ max the following equation is used to calculate total calories burned for male:


$$
CaloriesBurned=\frac{Duration \times (0.6309 \times HeartRate - 0.1988 \times WeightInKg + 0.2017 \times Age - 95.7735)}{4.184}
$$


For female the equation is as follows:


$$
CaloriesBurned=\frac{Duration \times (0.4472 \times HeartRate - 0.1263 \times WeightInKg + 0.074 \times Age - 20.4022)}{4.184}
$$


If the system contains data for VO~2~ max than the equation is slightly cleaner. First we need to know how VO~2~ max is calculated. The VO~2~ max equation is as follows:


$$
VO_2Max=15.3 \times \frac{220 - Age}{RestingHeartRate}
$$


With VO~2~max value the equation transforms to the following for male:


$$
CaloriesBurned=\frac{Duration \times (0.634 \times HeartRate + 0.404 \times VO_2Max + 0.394 \times WeightInKg + 0.271 \times Age - 95.7735)}{4.184}
$$


While for females we have the following:


$$
CaloriesBurned=\frac{Duration \times (0.45 \times HeartRate + 0.380 \times VO_2Max + 0.103 \times WeightInKg + 0.274 \times Age - 59.3954)}{4.184}
$$


Without calulating examples with this equation we still have the issue where a person's weight and age are variables in determining calories burned. However since these information is more obtainable than accurate METs, which varies based on type of activity, it is the more probably method for the fitbit trackers to keep track of the amount of calories burned.This is reinforced by the joining of the heart rate table and the activity per minute table, where increase in heart rate directly influences the amount of calories burned per minute. 