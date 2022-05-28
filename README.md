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

The non-Bellabeat smart device data we will be using is [FitBit's data set](https://www.kaggle.com/datasets/arashnic/fitbit) that is available on Kaggle.The data set contains physical activity, heart rate, and sleep data from 30 users. The downloaded zip file was placed into bellabeat-analysis/fitbit-raw-data/zip-files. The unziped CSV files are then placed into bellabeat-analysis/fitbit-raw-data/csv-files.

Looking at the CSV files we can see a lot of limitations with this data set. To put it simply, the sample size is too small. 30 users by itself is a decent size to do some basic analysis, however not all tables have 30 users. For example the amount of users in daily_activity.csv that also appears in weight_log.csv is only 8. Also the time span that the data was collected was also too short. The duration of sample collection was for 2 months. This lack of sample size will pose problems when we analyze certain categories. The best example of this is any analysis related to weight_log.csv. Two months is not long enough for any one person to lose statistically significant amount of weight unless they put themselves on some intense weightloss program. So we will be unable to analyze the effects of activity and calories burned to weight lost. The low number of users tracked on weight_log.csv also makes it hard to come up with any statistically conclusive trend based on BMI categories. This can be shown by the fact that there is only one individual that is considered severely obsese and no one is considered underweight.   