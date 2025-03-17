# Bellabeat Smart Device Analysis

![Bellabeat Logo](https://i.imgur.com/0Dtva0S.png)

## Project Overview

This project analyzes smart device usage data to gain insights into how consumers use fitness tracking devices. The analysis focuses on understanding usage patterns to provide strategic recommendations for Bellabeat, a high-tech manufacturer of health-focused products for women.

## Business Objective

Analyze smart device usage data to:
- Identify trends in smart device usage
- Apply findings to Bellabeat's product strategy
- Develop data-driven marketing recommendations

## Key Stakeholders

- Urška Sršen: Bellabeat's cofounder and Chief Creative Officer
- Sando Mur: Mathematician and Bellabeat's cofounder
- Bellabeat marketing analytics team

## Data Source

This analysis uses [FitBit Fitness Tracker Data](https://www.kaggle.com/datasets/arashnic/fitbit) available on Kaggle. The dataset contains physical activity, heart rate, and sleep data from 30 users of Fitbit devices.

## Methodology

### Data Preparation and Limitations

The dataset has several limitations:
- Small sample size (only 30 users total)
- Not all users appear in every table (e.g., only 8 users in weight_log.csv)
- Short collection period (2 months)
- Limited demographic information

These limitations affect certain analysis areas, particularly weight loss correlation with activity levels. For example, the low number of users tracked in weight_log.csv makes it difficult to establish statistically significant trends based on BMI categories.

### Processing and Analysis

#### Tools Used
- SQL: For data processing and analysis of large tables (>1M rows)
- Excel: For standardizing row values and initial data exploration
- R: For statistical analysis and visualization

#### SQL Schema Design
The SQL schema was designed to structure the data efficiently:

```sql
CREATE TABLE daily_activity (
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

CREATE TABLE heart_rate (
    user_id BIGINT NOT NULL,
    time_stamp TIMESTAMP NOT NULL,
    five_second_heart_rate SMALLINT NOT NULL
);
    
CREATE TABLE hourly_activity (
    user_id BIGINT NOT NULL,
    time_stamp TIMESTAMP NOT NULL,
    total_steps SMALLINT,
    total_intensity SMALLINT,
    avg_intensity REAL,
    calories SMALLINT
);

CREATE TABLE activity_per_minute (
    user_id BIGINT NOT NULL,
    time_stamp TIMESTAMP NOT NULL,
    steps SMALLINT,
    intensity SMALLINT,
    metabolic_rate SMALLINT,
    calories REAL
);
    
CREATE TABLE daily_sleep_data (
    user_id BIGINT NOT NULL,
    sleep_date DATE NOT NULL,
    minutes_asleep SMALLINT,
    minutes_in_bed SMALLINT
);

CREATE TABLE weight_log (
    user_id BIGINT NOT NULL,
    weigh_date DATE NOT NULL,
    weight_kg REAL,
    weight_lb REAL,
    BMI REAL,
    manual_report BOOLEAN
);
```

#### SQL Analysis Techniques

Custom SQL functions were implemented for advanced statistical analysis:

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

### Activity Intensity Analysis

To understand what defines different activity levels, we analyzed intensity and heart rate data:

```sql
SELECT intensity, 
    avg(steps) AS avg_steps, 
    avg(metabolic_rate) AS avg_METS, 
    avg(calories) AS avg_calories, 
    avg(five_second_heart_rate) AS avg_heart_rate
FROM activity_per_minute apm
JOIN heart_rate hr 
    ON hr.time_stamp = apm.time_stamp 
    AND hr.user_id = apm.user_id
GROUP BY intensity
ORDER BY intensity;
```

This analysis revealed the following relationship between intensity levels and heart rate:

| Intensity Level | Average Heart Rate Per Minute |
| --------------- | ----------------------------- |
| 0 (Sedentary)   | 67.48                         |
| 1 (Light)       | 85.95                         |
| 2 (Moderate)    | 100.96                        |
| 3 (Very Active) | 116.23                        |

From this data, we can infer that:
- 0 intensity corresponds to sedentary activity
- 1 corresponds to light activity
- 2 corresponds to moderate activity
- 3 corresponds to very active periods

For hourly calculations, 60 intensity in an hour equals light activity, 120 intensity corresponds to moderate activity, and 180 intensity indicates very active periods.

## Metabolic Equivalent (METs) and Calorie Analysis

Understanding how calories are calculated by fitness trackers is crucial for this analysis. The relationship between Metabolic Equivalent of Task (METs) and calories burned is defined by the following equation:

$$
CaloriesPerMinute = \frac{METs \times 3.5 \times WeightInKg}{200}
$$

For example, if an individual weighing 70 kg goes for a bicycle ride (METs of 8) for one hour, the calculation would be:

$$
\left(\frac{8 \times 3.5 \times 70}{200}\right) \times 60 = 588
$$

This person would burn 588 calories during the hour-long ride.

However, our analysis revealed that Fitbit's tracking of METs doesn't align with standard definitions. The minimum METs recorded in the dataset is 10, which according to published reference charts would correspond to running a 10-minute mile, clearly inconsistent with sedentary periods.

Given this discrepancy, heart rate is likely the primary factor used by Fitbit to calculate calories burned. The formula typically used for calorie calculation based on heart rate varies by gender:

For males:
$$
CaloriesBurned = \frac{Duration \times (0.6309 \times HeartRate - 0.1988 \times WeightInKg + 0.2017 \times Age - 95.7735)}{4.184}
$$

For females:
$$
CaloriesBurned = \frac{Duration \times (0.4472 \times HeartRate - 0.1263 \times WeightInKg + 0.074 \times Age - 20.4022)}{4.184}
$$

When VO₂ max data is available, the calculation can be refined. VO₂ max is typically calculated as:

$$
VO_2Max = 15.3 \times \frac{220 - Age}{RestingHeartRate}
$$

With this value, the calorie calculation becomes:

For males:
$$
CaloriesBurned = \frac{Duration \times (0.634 \times HeartRate + 0.404 \times VO_2Max + 0.394 \times WeightInKg + 0.271 \times Age - 95.7735)}{4.184}
$$

For females:
$$
CaloriesBurned = \frac{Duration \times (0.45 \times HeartRate + 0.380 \times VO_2Max + 0.103 \times WeightInKg + 0.274 \times Age - 59.3954)}{4.184}
$$

The correlation between heart rate and calories burned in the dataset supports the hypothesis that Fitbit uses heart rate-based calculations rather than METs-based ones.

## R Analysis Methodology

The R analysis began with importing necessary packages and data:

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

### Data Processing in R

Data processing steps included converting IDs to factors and calculating derived metrics:

```R
daily_sleep$Id <- as.factor(daily_sleep$Id) 
daily_activity$Id <- as.factor(daily_activity$Id)
weight_log$Id <- as.factor(weight_log$Id)
```

#### Height Calculation

From BMI and weight data, we calculated user height using the formula:

$$
HeightCM = \sqrt{\frac{WeightKg}{BMI}} \times 100
$$

In R code:
```R
weight_log$Height <- sqrt(weight_log$WeightKg/weight_log$BMI)*100
```

#### BMI Classification

We categorized users according to standard BMI ranges:
- Underweight: BMI < 18
- Healthy Weight: 18 ≤ BMI < 25
- Overweight: 25 ≤ BMI < 30
- Obese: 30 ≤ BMI < 40
- Severely Obese: BMI ≥ 40

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

### Statistical Summary

Basic statistical analysis of the dataset revealed:

```
 TotalSteps    TotalDistance    TrackerDistance  LoggedActivitiesDistance VeryActiveDistance
 Min.   :    0   Min.   : 0.000   Min.   : 0.000   Min.   :0.0000           Min.   : 0.000    
 1st Qu.: 3790   1st Qu.: 2.620   1st Qu.: 2.620   1st Qu.:0.0000           1st Qu.: 0.000    
 Median : 7406   Median : 5.245   Median : 5.245   Median :0.0000           Median : 0.210    
 Mean   : 7638   Mean   : 5.490   Mean   : 5.475   Mean   :0.1082           Mean   : 1.503    
 3rd Qu.:10727   3rd Qu.: 7.713   3rd Qu.: 7.710   3rd Qu.:0.0000           3rd Qu.: 2.053    
 Max.   :36019   Max.   :28.030   Max.   :28.030   Max.   :4.9421           Max.   :21.920   
 
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

### Data Integration for Analysis

To analyze relationships between different metrics, we merged the datasets:

```R
combined_data1 <- merge(daily_activity, daily_sleep, by = c('Id', 'Date'), all.x= TRUE)
n_distinct(combined_data1$Id)
combined_data2 <- merge(combined_data1, weight_log, by=c('Id', 'Date'))
n_distinct(combined_data2$Id)
```

We created additional calculated fields for deeper analysis:

```R
combined_data1$NonSleepingSedentaryMinutes <- combined_data1$SedentaryMinutes - 
  combined_data1$TotalTimeInBed

combined_data1$ActiveMinutes <- combined_data1$VeryActiveMinutes + 
  combined_data1$FairlyActiveMinutes + combined_data1$LightlyActiveMinutes

combined_data1$ExerciseMinutes <- combined_data1$VeryActiveMinutes + 
  combined_data1$FairlyActiveMinutes
  
combined_data1$PercentageofActiveTimeOnLightActivity <- (combined_data1$LightlyActiveMinutes /
                                                           combined_data1$ActiveMinutes) * 100

combined_data1$PercentageofActiveTimeOnHigherActivity <- ((combined_data1$FairlyActiveMinutes + 
                                                             combined_data1$VeryActiveMinutes)/
                                                           combined_data1$ActiveMinutes) * 100
```

## Data Visualization and Findings

### Activity and Calorie Relationship

![Daily Calories Burned Based on Minutes Active](https://i.imgur.com/TL4MBWm.png)

This visualization demonstrates the positive correlation between active minutes and calories burned. However, the relationship is not perfectly linear, indicating other factors influence calorie burn.

![Daily Calories Burned Based on Minutes Active (Light Activity)](https://i.imgur.com/yPAwKQC.png)

![Daily Calories Burned Based on Minutes Active (Exercise)](https://i.imgur.com/B6rqcbG.png)

These graphs reveal that users who spend more of their active time in exercise (versus light activity) burn more calories at the same total active minutes, forming distinct clusters above and below the trend line.

### Activity Intensity Impact

![Daily Calories Burned Based on % of Active Time Spent Exercising](https://i.imgur.com/kLY8ssS.png)

The analysis shows a positive correlation between the percentage of active time spent exercising and total calories burned, though the effect diminishes above 50% (likely due to sample size limitations).

### Weight Category Analysis

![Daily Calories Burned Based on Total Steps Taken (Obesity Level)](https://i.imgur.com/PWbbbhG.png)

This visualization reveals interesting patterns by weight category:
- Overweight individuals tend to take more steps per day (around 20k)
- Healthy weight individuals typically take around 10k steps (the commonly recommended amount)
- Overweight individuals appear to burn more calories per day compared to healthy weight individuals

![Daily Active Minutes Density Chart](https://i.imgur.com/zOI3rSR.png)

![Daily Minutes Exercising Density Chart](https://i.imgur.com/z49oSx4.png)

![Daily Lightly Active Minutes Density Chart](https://i.imgur.com/DxELZco.png)

These density plots show that:
- Healthy weight and overweight individuals are active for similar total durations
- Overweight individuals tend to exercise longer but spend less time in light activity
- This difference in intensity distribution explains the higher calorie burn observed in overweight individuals

## Key Insights

1. **Activity Patterns and Intensity**:
   - Most users are predominantly sedentary (average 991.2 minutes daily)
   - Higher intensity activity has a disproportionate impact on calorie expenditure
   - The quality of activity (intensity) matters more than pure quantity (steps or minutes)

2. **User Segmentation by Weight Category**:
   - Distinct usage patterns emerge between weight categories
   - Healthy weight users: Focus on consistent, moderate activity
   - Overweight users: Focus on higher intensity exercise for shorter durations

3. **Device Usage Purpose**:
   - Different user segments appear to use fitness trackers for different purposes
   - Healthy weight users: Track maintenance of current activity levels
   - Overweight users: Monitor progress toward weight loss goals

4. **Calories and Activity Relationship**:
   - Steps alone are an imperfect predictor of calories burned
   - Intensity distribution and user-specific factors create significant variation
   - Heart rate appears to be the primary factor in calorie calculations

## Strategic Recommendations

1. **Targeted Marketing Strategy**:
   - Develop dual messaging for different user segments:
     - Weight loss segment: Emphasize tracking capabilities for exercise intensity and calorie burn
     - Maintenance segment: Focus on long-term tracking and habit formation

2. **Product Feature Development**:
   - Enhance intensity tracking and calorie burn algorithms
   - Develop features that integrate sleep quality with activity metrics
   - Create personalized insights based on usage patterns

3. **App Experience Optimization**:
   - Customize dashboard views based on identified user goals
   - Provide different achievement metrics for different segments
   - Implement personalized recommendations based on activity patterns

## Methodological Limitations

1. **Sample Size Constraints**:
   - Limited number of users (30 total, only 8 with weight data)
   - Short data collection period (2 months)
   - Limited demographic information

2. **Data Quality Issues**:
   - Inconsistent data across tables
   - Questionable METs calculations
   - Missing data for some metrics

3. **Analytical Constraints**:
   - Unable to establish long-term trends due to limited timeframe
   - Cannot accurately correlate activity with weight changes
   - Limited ability to segment by demographics

## Future Research Directions

With expanded data collection, future analysis could explore:
- Long-term impact of activity patterns on weight management
- Correlation between sleep quality and activity intensity
- Seasonal variations in activity patterns
- Demographic influences on usage patterns

The current analysis provides a solid foundation for understanding user behavior, but expanded data collection would strengthen the statistical significance of these findings.
