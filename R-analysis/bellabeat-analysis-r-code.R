install.packages('tidyverse')
library(tidyverse)

setwd("/Users/nancy/Documents/Git Repo/Google Case Studies/bellabeat-analysis/R-analysis/csv-for-import")
getwd() 

daily_sleep <- read.csv("daily_sleep_data.csv", stringsAsFactors = T)
weight_log <- read.csv("weight_log.csv", stringsAsFactors = T)
daily_activity <- read.csv("daily_activity.csv", stringsAsFactors = T)

head(daily_sleep)
head(weight_log)
head(daily_activity)
str(daily_sleep)
str(daily_activity)
str(weight_log)
summary(daily_activity)
summary(daily_sleep)
summary(weight_log)

daily_sleep$Id <- as.factor(daily_sleep$Id) 
daily_activity$Id <- as.factor(daily_activity$Id)
weight_log$Id <- as.factor(weight_log$Id)

