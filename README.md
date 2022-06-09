# Google Data Analytics Case Study 2: How Can a Wellness Technology Company Play It Smart?

![img](https://i.imgur.com/0Dtva0S.png)

- TOC
{:toc}


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

Considering the METs that fitbit recorded is useless in determining calories burned per minute, the only other value we have that can determine calories burned is heart rate. With heart rate, depending on if the system knows your VO$_2$ max and your gender, different equations would be used. If the system doesn't track VO$_2$ max the following equation is used to calculate total calories burned for male:


$$
CaloriesBurned=\frac{Duration \times (0.6309 \times HeartRate - 0.1988 \times WeightInKg + 0.2017 \times Age - 95.7735)}{4.184}
$$


For female the equation is as follows:


$$
CaloriesBurned=\frac{Duration \times (0.4472 \times HeartRate - 0.1263 \times WeightInKg + 0.074 \times Age - 20.4022)}{4.184}
$$


If the system contains data for VO$_2$ max than the equation is slightly cleaner. First we need to know how VO$_2$ max is calculated. The VO$_2$ max equation is as follows:


$$
VO_2Max=15.3 \times \frac{220 - Age}{RestingHeartRate}
$$


With VO$_2$max value the equation transforms to the following for male:


$$
CaloriesBurned=\frac{Duration \times (0.634 \times HeartRate + 0.404 \times VO_2Max + 0.394 \times WeightInKg + 0.271 \times Age - 95.7735)}{4.184}
$$


While for females we have the following:


$$
CaloriesBurned=\frac{Duration \times (0.45 \times HeartRate + 0.380 \times VO_2Max + 0.103 \times WeightInKg + 0.274 \times Age - 59.3954)}{4.184}
$$


Without calulating examples with this equation we still have the issue where a person's weight and age are variables in determining calories burned. However since these information is more obtainable than accurate METs, which varies based on type of activity, it is the more probably method for the fitbit trackers to keep track of the amount of calories burned.This is reinforced by the joining of the heart rate table and the activity per minute table, where increase in heart rate directly influences the amount of calories burned per minute. 

#### R Prossessing and Analysis

To start with R we will need to import the tables we would like to work with into R as data frames. To do so we've prepared the R environment as such:

```R
# install and activate necessary packages
install.packages('tidyverse')
library(tidyverse)

# import data
setwd("/.../bellabeat-analysis/R-analysis/csv-for-import")
getwd() 
daily_sleep <- read.csv("daily_sleep_data.csv", stringsAsFactors = T)
weight_log <- read.csv("weight_log.csv", stringsAsFactors = T)
daily_activity <- read.csv("daily_activity.csv", stringsAsFactors = T)
```

Then we check the data with the following codes:

```R
str(daily_sleep)
str(daily_activity)
str(weight_log)
```

From this we can see that not all categories we would like to have set as factor became factors. To fix this we enter the following:

```R
daily_sleep$Id <- as.factor(daily_sleep$Id) 
daily_activity$Id <- as.factor(daily_activity$Id)
weight_log$Id <- as.factor(weight_log$Id)
```

Now there are some interesting calculated data we would like to add. One of such calculation is height of each user derived from weight and BMI. The mathematical equation is as such:


$$
HeightCM = \sqrt{\frac{WeightKg}{BMI}} \times 100
$$


To represent this in R and insert it into the weight_log data frame we use the following equation:

```R
weight_log$Height <- sqrt(weight_log$WeightKg/weight_log$BMI)*100
```

Another bit of calculated data we would want to add into our data frame regarding the weight_log will be BMI range classification. Different health organizations around the world will use different BMI ranges to determine what is considered a healthy BMI. Their differences are minimal, within 0.01 to 0.5 from each other, so for our purposes we can take the most commonly used ranges. The obesity ranges are as follows:

- Underweight is BMI < 18
- Healthy Weight is BMI $\geq$18 but BMI < 25
- Overweight is BMI $\geq$ 25 but BMI < 30
- Obese is BMI $\geq$ 30 but BMI < 40
- Severely Obese is BMI $\geq$ 40

There are some obvious issues with BMI being used to calculate how healthy someone is, since weight alone doesn't determine obesity. Muscles weight more than fat, so an individual that is particularly muscular could have a BMI that is outside of the healthy range, but a muscular person is arguably much more healthy than an individual that have the same BMI but is full of body fat. A better determination of obesity would be a direct calculation of an individual's body fat percentage. However, for our purposes we are using the obesity levels to categorize users to see if there are any differences in activity between each category. 

We used the following equation to insert the obesity level/categories into the data frame, and we also made the column into a factor:

```R
weight_log$ObesityLevel <- ifelse(weight_log$BMI < 18, 'UnderWeight', 
                                  ifelse(weight_log$BMI >= 18 & weight_log$BMI < 25,
                                        'HealthyWeight', 
                                         ifelse(weight_log$BMI >= 25 & weight_log$BMI < 30, 
                                               'OverWeight',
                                               ifelse(weight_log$BMI >= 30 & 
                                                      weight_log$BMI < 40,
                                                      'Obese', 'Severely Obese'))))
weight_log$ObesityLevel <- as.factor(weight_log$ObesityLevel)
```

Once we start combing the data frames later on, we will also be calculating information such as percentage of time active spent on light acitivities, or percentage of active time spent exerising.

Now we check the data integrity by pulling data statistics that we already know the answer to from SQL:

```R
n_distinct(daily_activity$Id)
n_distinct(daily_sleep$Id)
n_distinct(weight_log$Id)
nrow(daily_activity)
nrow(daily_sleep)
nrow(weight_log)
```

The results were 33, 24, 8, 940, 413, and 67 respectively, which matches up directly with the numbers provided by SQL.

Then we ran some quick summary statistics in R. The nice thing with R is that by using a single function we can get all the summary statistics information we would want that would have taken multiple or very long queries to obtain. The code we used was the following:

```R
daily_activity %>% 
  select(TotalSteps, TotalDistance, TrackerDistance, LoggedActivitiesDistance,
         VeryActiveDistance, ModeratelyActiveDistance, LightActiveDistance,
         SedentaryActiveDistance, VeryActiveMinutes, FairlyActiveMinutes,
         LightlyActiveMinutes, SedentaryMinutes, Calories) %>%
  summary()

daily_sleep %>% 
  select(TotalMinutesAsleep, TotalTimeInBed) %>% 
  summary()

weight_log %>% 
  select(WeightKg, WeightPounds, BMI, Height, IsManualReport) %>%
summary()
```

The printed results are as follows:

```
 TotalSteps    TotalDistance    TrackerDistance  LoggedActivitiesDistance VeryActiveDistance
 Min.   :    0   Min.   : 0.000   Min.   : 0.000   Min.   :0.0000           Min.   : 0.000    
 1st Qu.: 3790   1st Qu.: 2.620   1st Qu.: 2.620   1st Qu.:0.0000           1st Qu.: 0.000    
 Median : 7406   Median : 5.245   Median : 5.245   Median :0.0000           Median : 0.210    
 Mean   : 7638   Mean   : 5.490   Mean   : 5.475   Mean   :0.1082           Mean   : 1.503    
 3rd Qu.:10727   3rd Qu.: 7.713   3rd Qu.: 7.710   3rd Qu.:0.0000           3rd Qu.: 2.053    
 Max.   :36019   Max.   :28.030   Max.   :28.030   Max.   :4.9421           Max.   :21.920   
 
Mod...ActiveDist... Light...Dist... Sed...ActiveDist... VeryActiveMin... FairlyActiveMin...
 Min.   :0.0000     Min.   : 0.000  Min.   :0.000000    Min.   :  0.00    Min.   :  0.00     
 1st Qu.:0.0000     1st Qu.: 1.945  1st Qu.:0.000000    1st Qu.:  0.00    1st Qu.:  0.00     
 Median :0.2400     Median : 3.365  Median :0.000000    Median :  4.00    Median :  6.00     
 Mean   :0.5675     Mean   : 3.341  Mean   :0.001606    Mean   : 21.16    Mean   : 13.56     
 3rd Qu.:0.8000     3rd Qu.: 4.782  3rd Qu.:0.000000    3rd Qu.: 32.00    3rd Qu.: 19.00     
 Max.   :6.4800     Max.   :10.710  Max.   :0.110000    Max.   :210.00    Max.   :143.00     
 
 LightlyActiveMinutes SedentaryMinutes    Calories   
 Min.   :  0.0        Min.   :   0.0   Min.   :   0  
 1st Qu.:127.0        1st Qu.: 729.8   1st Qu.:1828  
 Median :199.0        Median :1057.5   Median :2134  
 Mean   :192.8        Mean   : 991.2   Mean   :2304  
 3rd Qu.:264.0        3rd Qu.:1229.5   3rd Qu.:2793  
 Max.   :518.0        Max.   :1440.0   Max.   :4900  
 
TotalMinutesAsleep TotalTimeInBed 
 Min.   : 58.0      Min.   : 61.0  
 1st Qu.:361.0      1st Qu.:403.0  
 Median :433.0      Median :463.0  
 Mean   :419.5      Mean   :458.6  
 3rd Qu.:490.0      3rd Qu.:526.0  
 Max.   :796.0      Max.   :961.0  
 
    WeightKg       WeightPounds        BMI            Height      IsManualReport 
 Min.   : 52.60   Min.   :116.0   Min.   :21.45   Min.   :152.4   Mode :logical  
 1st Qu.: 61.40   1st Qu.:135.4   1st Qu.:23.96   1st Qu.:160.1   FALSE:26       
 Median : 62.50   Median :137.8   Median :24.39   Median :160.1   TRUE :41       
 Mean   : 72.04   Mean   :158.8   Mean   :25.19   Mean   :168.5                  
 3rd Qu.: 85.05   3rd Qu.:187.5   3rd Qu.:25.56   3rd Qu.:182.8                  
 Max.   :133.50   Max.   :294.3   Max.   :47.54   Max.   :182.8                   
```

From these data we can infer quite a few things:

- All data that requires someone to conciously make a decision to log or requires people to do something for the equipment to log have minimum values higher than 0. Such as weight and sleep information.
- Though various levels of activity history makes sense to have 0, but calories burned having a minimum of 0 doesn't make much sense since people can burn calories while sleeping as well.
- Sedentary minutes and distance also having a minimum of 0 doesn't make sense as well, since a person won't be active 24 hours a day. The only explanation of this is if a person turns off their tracker when they are not exercising.
- Our sample size to determine height is not large, only 8 people, but what is interesting is that our median height is 160.10 cm, which is very close to the world median height for women. There is a possibility that most users that used fitbit products to track weight and height are women.
- On average the users logging their weight is on the upper end of healthy weight.
- We also see there is very little Very Active and Fairly Active, also known as exercising, minutes, while majority of activity is sedentary. 

After running the quick statistics we would need to start merging the data frame to make meaningful graphs that shows relationship between multiple dimensions. To combine the data we ran the following code:

```R
combined_data1 <- merge(daily_activity, daily_sleep, by = c('Id', 'Date'), all.x= TRUE)
n_distinct(combined_data1$Id)
combined_data2 <- merge(combined_data1, weight_log, by=c('Id', 'Date'))
n_distinct(combined_data2$Id)
```

We did this in two steps and created two data frames because combining weight_log into the rest of the data removes too many data points, which will make sample size too small to find any trends. So most analysis will be done with combined_data1 while we will only use combined_data2 if we need the weight data.

Before we can do further analysis, there are a few calulations we would like to do. First we want to calculate how much Sedentary minutes is actually sedentary, since if a user have their tracker on 24hrs, then some of the sedentary minutes tracked includes sleeping minutes. Though later we would find this this could cause isses since not all users have their activity trackers on 24/7, which causes some of these calculated data to have a negative value. The code we used to calculate non-sleeping sedentary minutes is as follows:

```R
combined_data1$NonSleepingSedentaryMinutes <- combined_data1$SedentaryMinutes - 
  combined_data1$TotalTimeInBed
```

To make things easier for us during our analysis we also decided to combine all non-sedentary minutes categories into one active minutes category. Also we decided to break down activie minutes by creating a category of exerising minutes, which only included fairly active minutes and very active minutes. Lightly active minutes isn't considered as exercising because it can be triggered from people walking and moving about doing their regular day to day tasks.

```R
combined_data1$ActiveMinutes <- combined_data1$VeryActiveMinutes + 
  combined_data1$FairlyActiveMinutes + combined_data1$LightlyActiveMinutes

combined_data2$ActiveMinutes <- combined_data2$VeryActiveMinutes + 
  combined_data2$FairlyActiveMinutes + combined_data2$LightlyActiveMinutes

combined_data1$ExerciseMinutes <- combined_data1$VeryActiveMinutes + 
  combined_data1$FairlyActiveMinutes
  
combined_data2$ExerciseMinutes <- combined_data2$VeryActiveMinutes + 
  combined_data2$FairlyActiveMinutes
```

We then wanted some of the data represented as percentages instead of hard numbers.

```R
combined_data1$PercentageofActiveTimeOnLightActivity <- (combined_data1$LightlyActiveMinutes /
                                                           combined_data1$ActiveMinutes) * 100

combined_data1$PercentageofActiveTimeOnHigherActivity <- ((combined_data1$FairlyActiveMinutes + 
                                                             combined_data1$VeryActiveMinutes)/
                                                           combined_data1$ActiveMinutes) * 100
```

Once all these are set, we experimented with various graphs to find something that is meaningful. Out of all the graphs generated, the following are worth highlighting:

```R
ggplot(data=combined_data1, aes(y=TotalSteps, x=ActiveMinutes, colour=Calories)) + 
  geom_point() + xlim(c(1,560)) +
  xlab("Minutes Active") + ylab("Number of Steps") + 
  labs(colour="Calories Burned") +
  ggtitle("Daily Calories Burned Based on Length of Activity and Total Steps") +
  theme(axis.title.x = element_text(size=12),
        axis.title.y = element_text(size=12),
        axis.text.x = element_text(size=10),
        axis.text.y = element_text(size=10),
        legend.title = element_text(size=12),
        legend.text = element_text(size=10),
        plot.title = element_text(size=18, hjust = 0.5))

ggplot(data=combined_data1, aes(y=Calories, x=ActiveMinutes, colour=Calories)) + 
  geom_point() + geom_smooth(fill=NA) + xlim(c(1,560)) +
  xlab("Minutes Active") + 
  ylab("Calories Burned") + labs(colour="Calories Burned") +
  ggtitle("Daily Calories Burned Based on Minutes Active") +
  theme(axis.title.x = element_text(size=12),
        axis.title.y = element_text(size=12),
        axis.text.x = element_text(size=10),
        axis.text.y = element_text(size=10),
        legend.title = element_text(size=12),
        legend.text = element_text(size=10),
        plot.title = element_text(size=18, hjust = 0.5))

ggplot(data=combined_data1, aes(y=Calories, x=ActiveMinutes, colour=PercentageofActiveTimeOnLightActivity)) + 
  geom_point() + geom_smooth(fill=NA) + xlim(c(1,560)) +
  xlab("Minutes Active") + 
  ylab("Calories Burned") + labs(colour="% of Active Time Lightly Active") +
  ggtitle("Daily Calories Burned Based on Minutes Active (Light Activity)") +
  theme(axis.title.x = element_text(size=12),
        axis.title.y = element_text(size=12),
        axis.text.x = element_text(size=10),
        axis.text.y = element_text(size=10),
        legend.title = element_text(size=12),
        legend.text = element_text(size=10),
        plot.title = element_text(size=18, hjust = 0.5))

ggplot(data=combined_data1, aes(y=Calories, x=ActiveMinutes, colour=PercentageofActiveTimeOnHigherActivity)) + 
  geom_point() + geom_smooth(fill=NA) + xlim(c(1,560)) +
  xlab("Minutes Active") + 
  ylab("Calories Burned") + labs(colour="% of Active Time Exerising") +
  ggtitle("Daily Calories Burned Based on Minutes Active (Exercise)") +
  theme(axis.title.x = element_text(size=12),
        axis.title.y = element_text(size=12),
        axis.text.x = element_text(size=10),
        axis.text.y = element_text(size=10),
        legend.title = element_text(size=12),
        legend.text = element_text(size=10),
        plot.title = element_text(size=18, hjust = 0.5))

ggplot(data=combined_data1, aes(y=Calories, x=PercentageofActiveTimeOnHigherActivity, colour=Calories)) + 
  geom_point() + geom_smooth(fill=NA) + xlim(c(1,100)) +
  xlab("% of Active Time Exercising") + 
  ylab("Calories Burned") + labs(colour="Calories Burned") +
  ggtitle("Daily Calories Burned Based on % of Active Time Spent Exercising") +
  theme(axis.title.x = element_text(size=12),
        axis.title.y = element_text(size=12),
        axis.text.x = element_text(size=10),
        axis.text.y = element_text(size=10),
        legend.title = element_text(size=12),
        legend.text = element_text(size=10),
        plot.title = element_text(size=18, hjust = 0.5))

ggplot(data=combined_data1, aes(y=TotalSteps, x=NonSleepingSedentaryMinutes, 
                                colour=Calories)) + 
  geom_point() + xlim(c(0,1000)) + ylim(c(0,25000)) + geom_smooth(fill=NA) +
  xlab("Minutes Sedentary While Not In Bed") + 
  ylab("Total Steps Taken") + labs(colour="Calories Burned") +
  ggtitle("Daily Steps Taken In Relation to Total Time Sedentary While Not In Bed") +
  theme(axis.title.x = element_text(size=12),
        axis.title.y = element_text(size=12),
        axis.text.x = element_text(size=10),
        axis.text.y = element_text(size=10),
        legend.title = element_text(size=12),
        legend.text = element_text(size=10),
        plot.title = element_text(size=18, hjust = 0.5))

ggplot(data=combined_data2, aes(y=Calories, x=TotalSteps, colour=ObesityLevel)) +
  geom_point() + geom_smooth(fill=NA) +
  xlab("Total Steps Taken") + 
  ylab("Calories Burned") + labs(colour="Obesity Level") +
  ggtitle("Daily Calories Burned Based on Total Steps Taken (Obesity Level)") +
  theme(axis.title.x = element_text(size=12),
        axis.title.y = element_text(size=12),
        axis.text.x = element_text(size=10),
        axis.text.y = element_text(size=10),
        legend.title = element_text(size=12),
        legend.text = element_text(size=10),
        plot.title = element_text(size=18, hjust = 0.5))

ggplot(data=combined_data2, aes(x=ActiveMinutes)) + 
  geom_density(aes(fill=ObesityLevel), alpha=0.5) +
  xlab("Minutes Active") + 
  ylab("Density") + labs(fill="Obesity Level") +
  ggtitle("Daily Active Minutes Density Chart") +
  theme(axis.title.x = element_text(size=12),
        axis.title.y = element_text(size=12),
        axis.text.x = element_text(size=10),
        axis.text.y = element_text(size=10),
        legend.title = element_text(size=12),
        legend.text = element_text(size=10),
        plot.title = element_text(size=18, hjust = 0.5))

ggplot(data=combined_data2, aes(x=Calories)) + 
  geom_density(aes(fill=ObesityLevel), alpha=0.5) +
  xlab("Calories Burned") + 
  ylab("Density") + labs(fill="Obesity Level") +
  ggtitle("Daily Calories Burned Density Chart") +
  theme(axis.title.x = element_text(size=12),
        axis.title.y = element_text(size=12),
        axis.text.x = element_text(size=10),
        axis.text.y = element_text(size=10),
        legend.title = element_text(size=12),
        legend.text = element_text(size=10),
        plot.title = element_text(size=18, hjust = 0.5))

ggplot(data=combined_data2, aes(x=ExerciseMinutes)) + 
  geom_density(aes(fill=ObesityLevel), alpha=0.5) +
  xlab("Minutes Exercising") + 
  ylab("Density") + labs(fill="Obesity Level") +
  ggtitle("Daily Minutes Exercising Density Chart") +
  theme(axis.title.x = element_text(size=12),
        axis.title.y = element_text(size=12),
        axis.text.x = element_text(size=10),
        axis.text.y = element_text(size=10),
        legend.title = element_text(size=12),
        legend.text = element_text(size=10),
        plot.title = element_text(size=18, hjust = 0.5))

ggplot(data=combined_data2, aes(x=LightlyActiveMinutes)) + 
  geom_density(aes(fill=ObesityLevel), alpha = 0.5) +
  xlab("Lightly Active Minutes") + 
  ylab("Density") + labs(fill="Obesity Level") +
  ggtitle("Daily Lightly Active Minutes Density Chart") +
  theme(axis.title.x = element_text(size=12),
        axis.title.y = element_text(size=12),
        axis.text.x = element_text(size=10),
        axis.text.y = element_text(size=10),
        legend.title = element_text(size=12),
        legend.text = element_text(size=10),
        plot.title = element_text(size=18, hjust = 0.5))
```

The above code generates the following charts and graphs:

![img](https://i.imgur.com/YkhkkyU.png)

![img](https://i.imgur.com/TL4MBWm.png)

![img](https://i.imgur.com/yPAwKQC.png)

![img](https://i.imgur.com/B6rqcbG.png)

![img](https://i.imgur.com/kLY8ssS.png)

![img](https://i.imgur.com/fgw22MI.png)

![img](https://i.imgur.com/PWbbbhG.png)

![img](https://i.imgur.com/zOI3rSR.png)

![img](https://i.imgur.com/z49oSx4.png)

![img](https://i.imgur.com/m0Gc2ct.png)

![img](https://i.imgur.com/DxELZco.png)

These charts reveal a few interesting trends. In the density chart it shows that Healthy Weight and Overweight individuals, in general, is active for similar amounts of time. Howeveer Overweight individuals tends to burn more calories per day while Healthy Weight individuals is mostly around 2000 calories burned per day.  We found the reason behind this from the density chart of daily minutes exercising and daily lightly active minutes. These two charts show that overweight inviduals tends to exercise longer and spend less time being lightly active, which can contribute to inrease in calories burned. This is later reinforced by the plot graph "Daily Calories Burned Based on Total Steps Taken (Obesity Level)". Though the sample size is way too small to provide any meaningful trend for the severely obese, but it shows us that Overweight individuals tends to tale more steps per day, around 20k, while healthy individuals take the doctors recommended steps per day, which is around 10k.

In the scatter plot section we see there is a positive corelation between number of steps taken, minutes active, and calories burned per day. in general the more steps you take the more minutes active you will be, which results in more calories burned. For the "Daily Calories Burned Based on Length of Activity and Total Steps" chart, this correlation is extremely obvious, however this becomes less obvious in the "Daily Calories Burned Based on Minutes Active" chart. In this specific chart we see two clusters. One cluster is above the trend line despite however long an individual is activem and the other cluster is below the trend line, no matter how long someone is active. For example there are cases where both people is active for about 490 minutes, but one individual burns about 3750 calories while the other only burned around 2600 calories. To see why this is the case, the next two graphs provides a bit of insight. Though it is not super obvious, because people spend very little time exercising per day in comparison to just walking around. From the charts we can see, generally speaking, data points below the trend line are primarily lightly active, while data points above the trend line tends to involve some level of exercise.

From the trend lines we can see that there is a positive, though very minor, correlation between time spent exercising and calories burned. The trend line starts curving one we pass 50% of active time spend exercising because the lack of sample size and also not many people exercises more than 4 hours a day. 

Without a suprise, the plot graphs also shows that the less time someone spends sedantary the more steps that take per day. It is when drawing this graph did we realize the issues that calculating sedentary time while not in bed could cause. There were negative values, which makes no sense, so for the sake of the graph they were cut off. Though this trend makes logical sense, the graph itself, because it was created with calculated data that were based on not completely correct assumptions, is somewhat useless.

## Share Phase

For the share phase we utilized the previous visualizations generated by R, but we also utilized Tableau. With Tableau we were able to generate the following visualization:

![img](https://i.imgur.com/91MiWAv.png)

You can find the Tableau public link [here](https://public.tableau.com/app/profile/george.jieh/viz/GoogleDataAnalyticsCase2/Dashboard1). I recommend going directly to the tableau public link so the image is more interactive and the graphs can be manipulated to better resolution. 

From these graphs we learn the following:

- People spend majority of their day sedentary and exercise fairly litte.
- Suprisingly it seems like people tend to exercise more from Monday to Wednesday. 
- People tends to be more sedentary on Monday, Tuesday, and Friday. 
- Both Obese and Healthy weight individuals are fairly consistent on their daily calories burned, keeping in mind there is a very small sample size of Obese individuals. Also we've learned that there may be some errors in the code we used in R to categorize obesity levels, since the data points that are marked as Obese in Tableau are the same data points that are marked as Very Obese in R. 
- Another interesting find is the trend for actively reported weight data. It shows that people that are Obese and some of the people that are slightly overweight tends to not actively report their weight data, while people that are overweight and approaching being obese, and people that are healthy do actively report their weight data.

From all of this we have quite a few of our business questions answered. The story that our visualization tells us is that people that are healthy uses these tracking tools to make sure they do the doctors recommended amount to stay healthy, while people that are overweight but not to the point of being completely obese, they use tracking tools to lose weight. 

## Act Phase

From our analysis we can draw a number of conclusions, such as exercising more burns more calories, not all types of activities are created equal when it comes to losing weight, and calories burned doesn't have a obvious direct correlation with the numbers of steps you take in a day. However none of these conclusions is as important as the tracker usage trends discovered for healthy individuals and overweight individuals. 

With these two trends there are targeted marketing opportunities. To target the overweight public that wants to lose weight, there can be marketing done with weight loss in mind, while for the healthy public, the products can be marketed as something that helps you keep track and make sure you are meeting your doctors recommendations.

###### [Back To Home](https://georgejieh.github.io/georges-data-analytics-portfolio/)







<script type="text/javascript" charset="utf-8" 
src="https://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML,
https://vincenttam.github.io/javascripts/MathJaxLocal.js"></script>
