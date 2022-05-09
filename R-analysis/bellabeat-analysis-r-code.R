# install and activate necessary packages
install.packages('tidyverse')
library(tidyverse)

# import data
setwd("/Users/nancy/Documents/Git Repo/Google Case Studies/bellabeat-analysis/R-analysis/csv-for-import")
getwd() 
daily_sleep <- read.csv("daily_sleep_data.csv", stringsAsFactors = T)
weight_log <- read.csv("weight_log.csv", stringsAsFactors = T)
daily_activity <- read.csv("daily_activity.csv", stringsAsFactors = T)

# check data
head(daily_sleep)
head(weight_log)
head(daily_activity)
str(daily_sleep)
str(daily_activity)
str(weight_log)

# set Id as factor
daily_sleep$Id <- as.factor(daily_sleep$Id) 
daily_activity$Id <- as.factor(daily_activity$Id)
weight_log$Id <- as.factor(weight_log$Id)

# calculate height of participants
weight_log$Height <- sqrt(weight_log$WeightKg/weight_log$BMI)*100
weight_log$ObesityLevel <- ifelse(weight_log$BMI < 18, 'UnderWeight', 
                                  ifelse(weight_log$BMI >= 18 & weight_log$BMI <= 24,
                                         'HealthyWeight', 
                                         ifelse(weight_log$BMI >= 25 & weight_log$BMI <= 29, 
                                                'OverWeight',
                                                ifelse(weight_log$BMI >= 30 & weight_log$BMI <= 39,
                                                       'Obese', 'Severely Obese'))))

# set obesity level as factor
weight_log$ObesityLevel <- as.factor(weight_log$ObesityLevel)

# number of participants
n_distinct(daily_activity$Id)
n_distinct(daily_sleep$Id)
n_distinct(weight_log$Id)

# number of observastion
nrow(daily_activity)
nrow(daily_sleep)
nrow(weight_log)

# quick summary statistics
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

# plotting for exploration
ggplot(data=daily_activity, aes(x=TotalSteps, y=SedentaryMinutes)) +
  geom_point() + geom_smooth()

ggplot(data=daily_sleep, aes(x=TotalMinutesAsleep, y=TotalTimeInBed)) + 
  geom_point() + geom_smooth()

ggplot(data=weight_log, aes(x=Height, fill=Id)) +
  geom_histogram(binwidth=4, colour="Black", alpha=0.65) +
  facet_grid(.~ObesityLevel)

# combining datasets
combined_data1 <- merge(daily_sleep, daily_activity, by="Id")
n_distinct(combined_data1$Id)
combined_data2 <- merge(weight_log, combined_data1, by="Id")
n_distinct(combined_data2$Id)
head(combined_data2)
nrow(combined_data2)
str(combined_data2)
str(combined_data1)

# exploring data of combined datasets
ggplot(data=combined_data2, aes(x=SedentaryMinutes, y=BMI, 
                               colour=ObesityLevel)) + geom_point()

ggplot(data=combined_data2, aes(x=SedentaryMinutes, y=Height, 
                                colour=ObesityLevel)) + geom_point()

ggplot(data=combined_data2, aes(x=SedentaryMinutes, y=WeightKg, 
                                colour=ObesityLevel)) + geom_point()

ggplot(data=combined_data2, aes(x=SedentaryMinutes, y=TotalSteps, 
                                colour=ObesityLevel)) + geom_point()

ggplot(data=combined_data1, aes(x=TotalTimeInBed, y=SedentaryMinutes, 
                                )) + geom_point() + geom_smooth()

ggplot(data=combined_data2, aes(x=TotalTimeInBed, y=TotalSteps, 
                                colour=ObesityLevel)) + geom_point() + geom_smooth()

ggplot(data=combined_data1, aes(x=TotalTimeInBed, y=TotalSteps, 
                                )) + geom_point() + geom_smooth()

ggplot(data=combined_data2, aes(y=Calories, x=TotalSteps, colour=ObesityLevel)) +
  geom_point() + geom_smooth()

ggplot(data=daily_activity, aes(y=Calories, x=TotalSteps, colour=Calories)) +
  geom_point() + geom_smooth()

ggplot(data=combined_data1, aes(y=Calories, x=VeryActiveMinutes, colour=Calories)) +
  geom_point() + geom_smooth()
