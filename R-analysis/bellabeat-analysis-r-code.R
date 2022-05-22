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

# calculate height of participants and set BMI standards
weight_log$Height <- sqrt(weight_log$WeightKg/weight_log$BMI)*100
weight_log$ObesityLevel <- ifelse(weight_log$BMI < 18, 'UnderWeight', 
                                  ifelse(weight_log$BMI >= 18 & weight_log$BMI < 25,
                                         'HealthyWeight', 
                                         ifelse(weight_log$BMI >= 25 & weight_log$BMI < 30, 
                                                'OverWeight',
                                                ifelse(weight_log$BMI >= 30 & weight_log$BMI < 40,
                                                       'Obese', 'Severely Obese'))))

# set obesity level as factor
weight_log$ObesityLevel <- as.factor(weight_log$ObesityLevel)

# number of participants
n_distinct(daily_activity$Id)
n_distinct(daily_sleep$Id)
n_distinct(weight_log$Id)

# number of observations
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
combined_data1 <- merge(daily_activity, daily_sleep, by = c('Id', 'Date'), all.x= TRUE)
n_distinct(combined_data1$Id)
combined_data2 <- merge(combined_data1, weight_log, by=c('Id', 'Date'))
n_distinct(combined_data2$Id)
head(combined_data2)
nrow(combined_data2)
str(combined_data2)
str(combined_data1)

# exploring data of combined datasets
ggplot(data=combined_data2, aes(x=SedentaryMinutes, y=BMI, 
                                fill=ObesityLevel)) + geom_boxplot() +
  geom_jitter()

ggplot(data=combined_data2, aes(x=SedentaryMinutes, y=Height, 
                                colour=ObesityLevel)) + geom_point()

ggplot(data=combined_data2, aes(x=SedentaryMinutes, y=WeightKg, 
                                colour=ObesityLevel)) + geom_point()

ggplot(data=combined_data2, aes(x=SedentaryMinutes, y=TotalSteps, 
                                colour=ObesityLevel)) + geom_point() + 
  geom_smooth() + ylim(c(0,20500))

ggplot(data=combined_data1, aes(x=TotalTimeInBed, y=SedentaryMinutes, 
                                )) + geom_point()

ggplot(data=combined_data2, aes(x=TotalTimeInBed, y=TotalSteps, 
                                colour=ObesityLevel)) + geom_point()

plot_data <- combined_data2 %>% filter(TotalTimeInBed != SedentaryMinutes)
ggplot(data=plot_data, aes(x=ObesityLevel, y=SedentaryMinutes, 
                                fill=ObesityLevel)) + geom_boxplot()

ggplot(data=combined_data2, aes(x=ObesityLevel, y=TotalSteps, 
                           fill=Id)) + geom_boxplot()

ggplot(data=combined_data1, aes(x=TotalTimeInBed, y=TotalSteps, 
                                )) + geom_point() + geom_smooth()

ggplot(data=combined_data2, aes(y=Calories, x=TotalSteps, colour=ObesityLevel)) +
  geom_point() + geom_smooth()

ggplot(data=daily_activity, aes(y=Calories, x=TotalSteps, colour=Calories)) +
  geom_point() + geom_smooth()

ggplot(data=combined_data1, aes(y=Calories, x=VeryActiveMinutes, colour=Calories)) +
  geom_point() + geom_smooth()

ggplot(data=combined_data1, aes(x=TotalMinutesAsleep, y=SedentaryMinutes)) +
  geom_point() + geom_smooth()

# most things drawn with combined_data2 does not produce useful results due to 
# small unique Id sample size.

combined_data1$NonSleepingSedentaryMinutes <- combined_data1$SedentaryMinutes - 
  combined_data1$TotalTimeInBed
ggplot(data=combined_data1, aes(y=Calories, x=NonSleepingSedentaryMinutes, colour=Calories)) + 
  geom_point() + geom_smooth()

combined_data1$ActiveMinutes <- combined_data1$VeryActiveMinutes + 
  combined_data1$FairlyActiveMinutes + combined_data1$LightlyActiveMinutes

combined_data2$ActiveMinutes <- combined_data2$VeryActiveMinutes + 
  combined_data2$FairlyActiveMinutes + combined_data2$LightlyActiveMinutes

ggplot(data=combined_data1, aes(y=Calories, x=ActiveMinutes, colour=Calories)) + 
  geom_point() + geom_smooth()
ggplot(data=combined_data1, aes(y=TotalSteps, x=ActiveMinutes, colour=Calories)) + 
  geom_point() + geom_smooth()
ggplot(data=combined_data1, aes(y=TotalMinutesAsleep, x=ActiveMinutes, colour=Calories)) + 
  geom_point() + geom_smooth()

ggplot(data=combined_data2, aes(x=ActiveMinutes)) + geom_density(aes(fill=ObesityLevel))
ggplot(data=combined_data2, aes(x=Calories)) + geom_density(aes(fill=ObesityLevel))
ggplot(data=combined_data2, aes(x=VeryActiveMinutes)) + geom_density(aes(fill=ObesityLevel))
ggplot(data=combined_data2, aes(x=FairlyActiveMinutes)) + geom_density(aes(fill=ObesityLevel))
ggplot(data=combined_data2, aes(x=LightlyActiveMinutes)) + geom_density(aes(fill=ObesityLevel))

#meaningful charts and graphs

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

combined_data1$PercentageofActiveTimeOnLightActivity <- (combined_data1$LightlyActiveMinutes /
                                                           combined_data1$ActiveMinutes) * 100

combined_data1$PercentageofActiveTimeOnHigherActivity <- ((combined_data1$FairlyActiveMinutes + 
                                                             combined_data1$VeryActiveMinutes)/
                                                           combined_data1$ActiveMinutes) * 100

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

ggplot(data=combined_data1, aes(y=TotalSteps, x=NonSleepingSedentaryMinutes, colour=Calories)) + 
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

combined_data2$ExerciseMinutes <- combined_data2$VeryActiveMinutes + 
  combined_data2$FairlyActiveMinutes

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
