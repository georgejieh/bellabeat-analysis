COPY daily_activity FROM 
'/Users/nancy/Documents/Git Repo/Google Case Studies/bellabeat-analysis/fitbit-raw-data/csv-files/daily_activity.csv' CSV HEADER;

COPY heart_rate FROM 
'/Users/nancy/Documents/Git Repo/Google Case Studies/bellabeat-analysis/fitbit-raw-data/csv-files/heart_rate_per_5_second_intervals.csv' CSV HEADER;

COPY hourly_activity FROM 
'/Users/nancy/Documents/Git Repo/Google Case Studies/bellabeat-analysis/processed-data/csv-files/hourly_activity.csv' CSV HEADER;

COPY activity_per_minute FROM 
'/Users/nancy/Documents/Git Repo/Google Case Studies/bellabeat-analysis/processed-data/csv-files/activity_per_minute.csv' CSV HEADER;

COPY daily_sleep_data FROM 
'/Users/nancy/Documents/Git Repo/Google Case Studies/bellabeat-analysis/processed-data/csv-files/daily_sleep_data.csv' CSV HEADER;

COPY weight_log FROM 
'/Users/nancy/Documents/Git Repo/Google Case Studies/bellabeat-analysis/processed-data/csv-files/weight_log.csv' CSV HEADER;