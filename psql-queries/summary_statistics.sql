-- review tables
SELECT * FROM activity_per_minute;
SELECT * FROM hourly_activity;
SELECT * FROM daily_activity;
SELECT * FROM daily_sleep_data;
SELECT * FROM weight_log;
SELECT * FROM heart_rate;

-- average activity per minute per user
SELECT user_id, 
	ROUND(CAST(AVG(steps) AS NUMERIC),3) AS avg_steps, 
	ROUND(CAST(AVG(intensity) AS NUMERIC),3) AS avg_intensity, 
	ROUND(CAST(AVG(metabolic_rate) AS NUMERIC),3) AS avg_metabolic_rate, 
	ROUND(CAST(AVG(calories) AS NUMERIC),3) AS avg_calories
FROM activity_per_minute
GROUP BY user_id;

-- median activity per minute per user
SELECT user_id, 
	ROUND(median(CAST(steps AS NUMERIC)),3) AS median_steps, 
	ROUND(median(CAST(intensity AS NUMERIC)),3) AS median_intensity, 
	ROUND(median(CAST(metabolic_rate AS NUMERIC)),3) AS median_metabolic_rate, 
	ROUND(median(CAST(calories AS NUMERIC)),3) AS median_calories
FROM activity_per_minute
GROUP BY user_id;

-- minimum activity per minute per user
SELECT user_id, 
	ROUND(MIN(CAST(steps AS NUMERIC)),3) AS min_steps, 
	ROUND(MIN(CAST(intensity AS NUMERIC)),3) AS min_intensity, 
	ROUND(MIN(CAST(metabolic_rate AS NUMERIC)),3) AS min_metabolic_rate, 
	ROUND(MIN(CAST(calories AS NUMERIC)),3) AS min_calories
FROM activity_per_minute
GROUP BY user_id;

-- maximum activity per minute per user
SELECT user_id, 
	ROUND(MAX(CAST(steps AS NUMERIC)),3) AS max_steps, 
	ROUND(MAX(CAST(intensity AS NUMERIC)),3) AS max_intensity, 
	ROUND(MAX(CAST(metabolic_rate AS NUMERIC)),3) AS max_metabolic_rate, 
	ROUND(MAX(CAST(calories AS NUMERIC)),3) AS max_calories
FROM activity_per_minute
GROUP BY user_id;

-- total activity per minute per user
SELECT user_id, 
	ROUND(SUM(CAST(steps AS NUMERIC)),3) AS total_steps, 
	ROUND(SUM(CAST(intensity AS NUMERIC)),3) AS total_intensity, 
	ROUND(SUM(CAST(metabolic_rate AS NUMERIC)),3) AS total_metabolic_rate, 
	ROUND(SUM(CAST(calories AS NUMERIC)),3) AS total_calories
FROM activity_per_minute
GROUP BY user_id;

-- average activity per hour per user
SELECT user_id, 
	ROUND(CAST(AVG(total_steps) AS NUMERIC),3) AS avg_steps, 
	ROUND(CAST(AVG(total_intensity) AS NUMERIC),3) AS avg_hourly_intensity, 
	ROUND(CAST(AVG(calories) AS NUMERIC),3) AS avg_calories
FROM hourly_activity
GROUP BY user_id;

-- median activity per hour per user
SELECT user_id, 
	ROUND(median(CAST(total_steps AS NUMERIC)),3) AS median_steps, 
	ROUND(median(CAST(total_intensity AS NUMERIC)),3) AS median_hourly_intensity, 
	ROUND(median(CAST(calories AS NUMERIC)),3) AS median_calories
FROM hourly_activity
GROUP BY user_id;

-- minimum activity per hour per user
SELECT user_id, 
	ROUND(MIN(CAST(total_steps AS NUMERIC)),3) AS min_steps, 
	ROUND(MIN(CAST(total_intensity AS NUMERIC)),3) AS min_total_intensity, 
	ROUND(MIN(CAST(avg_intensity AS NUMERIC)),3) AS min_hourly_avg_intensity, 
	ROUND(MIN(CAST(calories AS NUMERIC)),3) AS min_calories
FROM hourly_activity
GROUP BY user_id;

-- maximum activity per hourly per user
SELECT user_id, 
	ROUND(MAX(CAST(total_steps AS NUMERIC)),3) AS max_steps, 
	ROUND(MAX(CAST(total_intensity AS NUMERIC)),3) AS max_total_intensity, 
	ROUND(MAX(CAST(avg_intensity AS NUMERIC)),3) AS max_hourly_avg_intensity, 
	ROUND(MAX(CAST(calories AS NUMERIC)),3) AS max_calories
FROM hourly_activity
GROUP BY user_id;

-- total activity per minute per user
SELECT user_id, 
	ROUND(SUM(CAST(total_steps AS NUMERIC)),3) AS total_steps, 
	ROUND(SUM(CAST(total_intensity AS NUMERIC)),3) AS total_intensity, 
	ROUND(SUM(CAST(calories AS NUMERIC)),3) AS total_calories
FROM hourly_activity
GROUP BY user_id;