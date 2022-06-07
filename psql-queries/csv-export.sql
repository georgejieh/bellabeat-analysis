Copy (SELECT user_id,
		ROUND(CAST(AVG(steps) AS NUMERIC),3) AS avg_steps,
		ROUND(CAST(AVG(intensity) AS NUMERIC),3) AS avg_intensity,
		ROUND(CAST(AVG(metabolic_rate) AS NUMERIC),3) AS avg_metabolic_rate,
		ROUND(CAST(AVG(calories) AS NUMERIC),3) AS avg_calories
	FROM activity_per_minute
	GROUP BY user_id)
To '/.../bellabeat-analysis/psql-queries/csv-export/avg_activity_per_min.csv'
With CSV DELIMITER ',' HEADER;

Copy (SELECT user_id,
		ROUND(MAX(CAST(steps AS NUMERIC)),3) AS max_steps,
		ROUND(MAX(CAST(intensity AS NUMERIC)),3) AS max_intensity,
		ROUND(MAX(CAST(metabolic_rate AS NUMERIC)),3) AS max_metabolic_rate,
		ROUND(MAX(CAST(calories AS NUMERIC)),3) AS max_calories
	FROM activity_per_minute
	GROUP BY user_id)
To '/.../bellabeat-analysis/psql-queries/csv-export/max_activity_per_min.csv'
With CSV DELIMITER ',' HEADER;

Copy (SELECT user_id,
		ROUND(CAST(AVG(total_steps) AS NUMERIC),3) AS avg_steps,
		ROUND(CAST(AVG(total_intensity) AS NUMERIC),3) AS avg_hourly_intensity,
		ROUND(CAST(AVG(calories) AS NUMERIC),3) AS avg_calories
	FROM hourly_activity
	GROUP BY user_id)
To '/.../bellabeat-analysis/psql-queries/csv-export/avg_hourly_activity.csv'
With CSV DELIMITER ',' HEADER;

Copy (SELECT user_id,
		ROUND(MAX(CAST(total_steps AS NUMERIC)),3) AS max_steps,
		ROUND(MAX(CAST(total_intensity AS NUMERIC)),3) AS max_total_intensity,
		ROUND(MAX(CAST(avg_intensity AS NUMERIC)),3) AS max_hourly_avg_intensity,
		ROUND(MAX(CAST(calories AS NUMERIC)),3) AS max_calories
	FROM hourly_activity
	GROUP BY user_id)
To '/.../bellabeat-analysis/psql-queries/csv-export/max_hourly_activity.csv'
With CSV DELIMITER ',' HEADER;

Copy (SELECT user_id,
		ROUND(CAST(AVG(total_steps) AS NUMERIC),3) AS avg_steps,
		ROUND(CAST(AVG(total_distance) AS NUMERIC),3) AS avg_distance,
		ROUND(CAST(AVG(tracker_distance) AS NUMERIC),3) AS avg_tracker_distance,
		ROUND(CAST(AVG(logged_activities_distance) AS NUMERIC),3) AS avg_logged_distance,
		ROUND(CAST(AVG(very_active_distance) AS NUMERIC),3) AS avg_very_active_distance,
		ROUND(CAST(AVG(moderately_active_distance) AS NUMERIC),3) AS avg_mod_distance,
		ROUND(CAST(AVG(lightly_active_distance) AS NUMERIC),3) AS avg_light_distance,
		ROUND(CAST(AVG(sedentary_active_distance) AS NUMERIC),3) AS avg_sed_distance,
		ROUND(CAST(AVG(very_active_min) AS NUMERIC),3) AS avg_very_active_min,
		ROUND(CAST(AVG(moderately_active_min) AS NUMERIC),3) AS avg_mod_min,
		ROUND(CAST(AVG(lightly_active_min) AS NUMERIC),3) AS avg_light_min,
		ROUND(CAST(AVG(sedentary_active_min) AS NUMERIC),3) AS avg_sed_min,
		ROUND(CAST(AVG(calories) AS NUMERIC),3) AS avg_calories
	FROM daily_activity
	GROUP BY user_id)
To '/.../bellabeat-analysis/psql-queries/csv-export/avg_daily_activity.csv'
With CSV DELIMITER ',' HEADER;

Copy (SELECT user_id,
		ROUND(median(CAST(total_steps AS NUMERIC)),3) AS med_steps,
		ROUND(median(CAST(total_distance AS NUMERIC)),3) AS med_distance,
		ROUND(median(CAST(tracker_distance AS NUMERIC)),3) AS med_tracker_distance,
		ROUND(median(CAST(logged_activities_distance AS NUMERIC)),3) AS med_logged_distance,
		ROUND(median(CAST(very_active_distance AS NUMERIC)),3) AS med_very_active_distance,
		ROUND(median(CAST(moderately_active_distance AS NUMERIC)),3) AS med_mod_distance,
		ROUND(median(CAST(lightly_active_distance AS NUMERIC)),3) AS med_light_distance,
		ROUND(median(CAST(sedentary_active_distance AS NUMERIC)),3) AS med_sed_distance,
		ROUND(median(CAST(very_active_min AS NUMERIC)),3) AS med_very_active_min,
		ROUND(median(CAST(moderately_active_min AS NUMERIC)),3) AS med_mod_min,
		ROUND(median(CAST(lightly_active_min AS NUMERIC)),3) AS med_light_min,
		ROUND(median(CAST(sedentary_active_min AS NUMERIC)),3) AS med_sed_min,
		ROUND(median(CAST(calories AS NUMERIC)),3) AS med_calories
	FROM daily_activity
	GROUP BY user_id)
To '/.../bellabeat-analysis/psql-queries/csv-export/median_daily_activity.csv'
With CSV DELIMITER ',' HEADER;

Copy (SELECT user_id,
		ROUND(MIN(CAST(total_steps AS NUMERIC)),3) AS min_steps,
		ROUND(MIN(CAST(total_distance AS NUMERIC)),3) AS min_distance,
		ROUND(MIN(CAST(tracker_distance AS NUMERIC)),3) AS min_tracker_distance,
		ROUND(MIN(CAST(logged_activities_distance AS NUMERIC)),3) AS min_logged_distance,
		ROUND(MIN(CAST(very_active_distance AS NUMERIC)),3) AS min_very_active_distance,
		ROUND(MIN(CAST(moderately_active_distance AS NUMERIC)),3) AS min_mod_distance,
		ROUND(MIN(CAST(lightly_active_distance AS NUMERIC)),3) AS min_light_distance,
		ROUND(MIN(CAST(sedentary_active_distance AS NUMERIC)),3) AS min_sed_distance,
		ROUND(MIN(CAST(very_active_min AS NUMERIC)),3) AS min_very_active_min,
		ROUND(MIN(CAST(moderately_active_min AS NUMERIC)),3) AS min_mod_min,
		ROUND(MIN(CAST(lightly_active_min AS NUMERIC)),3) AS min_light_min,
		ROUND(MIN(CAST(sedentary_active_min AS NUMERIC)),3) AS min_sed_min,
		ROUND(MIN(CAST(calories AS NUMERIC)),3) AS min_calories
	FROM daily_activity
	GROUP BY user_id)
To '/.../bellabeat-analysis/psql-queries/csv-export/min_daily_activity.csv'
With CSV DELIMITER ',' HEADER;

Copy (SELECT user_id,
		ROUND(MAX(CAST(total_steps AS NUMERIC)),3) AS max_steps,
		ROUND(MAX(CAST(total_distance AS NUMERIC)),3) AS max_distance,
		ROUND(MAX(CAST(tracker_distance AS NUMERIC)),3) AS max_tracker_distance,
		ROUND(MAX(CAST(logged_activities_distance AS NUMERIC)),3) AS max_logged_distance,
		ROUND(MAX(CAST(very_active_distance AS NUMERIC)),3) AS max_very_active_distance,
		ROUND(MAX(CAST(moderately_active_distance AS NUMERIC)),3) AS max_mod_distance,
		ROUND(MAX(CAST(lightly_active_distance AS NUMERIC)),3) AS max_light_distance,
		ROUND(MAX(CAST(sedentary_active_distance AS NUMERIC)),3) AS max_sed_distance,
		ROUND(MAX(CAST(very_active_min AS NUMERIC)),3) AS max_very_active_min,
		ROUND(MAX(CAST(moderately_active_min AS NUMERIC)),3) AS max_mod_min,
		ROUND(MAX(CAST(lightly_active_min AS NUMERIC)),3) AS max_light_min,
		ROUND(MAX(CAST(sedentary_active_min AS NUMERIC)),3) AS max_sed_min,
		ROUND(MAX(CAST(calories AS NUMERIC)),3) AS max_calories
	FROM daily_activity
	GROUP BY user_id)
To '/.../bellabeat-analysis/psql-queries/csv-export/max_daily_activity.csv'
With CSV DELIMITER ',' HEADER;

Copy (SELECT user_id,
		ROUND(CAST(AVG(minutes_asleep) AS NUMERIC),3) AS avg_min_asleep,
		ROUND(CAST(AVG(minutes_in_bed) AS NUMERIC),3) AS avg_min_in_bed
	FROM daily_sleep_data
	GROUP BY user_id)
To '/.../bellabeat-analysis/psql-queries/csv-export/avg_sleep_activity.csv'
With CSV DELIMITER ',' HEADER;

Copy (SELECT user_id,
		ROUND(median(CAST(minutes_asleep AS NUMERIC)),3) AS median_min_asleep,
		ROUND(median(CAST(minutes_in_bed AS NUMERIC)),3) AS median_min_in_bed
	FROM daily_sleep_data
	GROUP BY user_id)
To '/.../bellabeat-analysis/psql-queries/csv-export/median_sleep_activity.csv'
With CSV DELIMITER ',' HEADER;

Copy (SELECT user_id,
		ROUND(MIN(CAST(minutes_asleep AS NUMERIC)),3) AS min_min_asleep,
		ROUND(MIN(CAST(minutes_in_bed AS NUMERIC)),3) AS min_min_in_bed
	FROM daily_sleep_data
	GROUP BY user_id)
To '/.../bellabeat-analysis/psql-queries/csv-export/min_sleep_activity.csv'
With CSV DELIMITER ',' HEADER;

Copy (SELECT user_id,
		ROUND(MAX(CAST(minutes_asleep AS NUMERIC)),3) AS max_min_asleep,
		ROUND(MAX(CAST(minutes_in_bed AS NUMERIC)),3) AS max_min_in_bed
	FROM daily_sleep_data
	GROUP BY user_id)
To '/.../bellabeat-analysis/psql-queries/csv-export/max_sleep_activity.csv'
With CSV DELIMITER ',' HEADER;

Copy (SELECT user_id,
		ROUND(CAST(AVG(weight_kg) AS NUMERIC),3) AS avg_weight_kg,
		ROUND(CAST(AVG(weight_lb) AS NUMERIC),3) AS avg_weight_lb,
		ROUND(CAST(AVG(bmi) AS NUMERIC),3) AS avg_bmi
	FROM weight_log
	GROUP BY user_id)
To '/.../bellabeat-analysis/psql-queries/csv-export/avg_weight_data.csv'
With CSV DELIMITER ',' HEADER;

Copy (SELECT user_id,
		ROUND(MIN(CAST(weight_kg AS NUMERIC)),3) AS min_weight_kg,
		ROUND(MIN(CAST(weight_lb AS NUMERIC)),3) AS min_weight_lb,
		ROUND(MIN(CAST(bmi AS NUMERIC)),3) AS min_bmi
	FROM weight_log
	GROUP BY user_id)
To '/.../bellabeat-analysis/psql-queries/csv-export/min_weight_data.csv'
With CSV DELIMITER ',' HEADER;

Copy (SELECT user_id,
		ROUND(MAX(CAST(weight_kg AS NUMERIC)),3) AS max_weight_kg,
		ROUND(MAX(CAST(weight_lb AS NUMERIC)),3) AS max_weight_lb,
		ROUND(MAX(CAST(bmi AS NUMERIC)),3) AS max_bmi
	FROM weight_log
	GROUP BY user_id)
To '/.../bellabeat-analysis/psql-queries/csv-export/max_weight_data.csv'
With CSV DELIMITER ',' HEADER;

Copy (SELECT user_id,
		ROUND(CAST(AVG(five_second_heart_rate) AS NUMERIC),3) AS avg_heart_rate
	FROM heart_rate
	GROUP BY user_id)
To '/.../bellabeat-analysis/psql-queries/csv-export/avg_heart_rate.csv'
With CSV DELIMITER ',' HEADER;

Copy (SELECT user_id,
		ROUND(median(CAST(five_second_heart_rate AS NUMERIC)),3) AS median_heart_rate
	FROM heart_rate
	GROUP BY user_id)
To '/.../bellabeat-analysis/psql-queries/csv-export/median_heart_rate.csv'
With CSV DELIMITER ',' HEADER;

Copy (SELECT user_id,
		ROUND(MIN(CAST(five_second_heart_rate AS NUMERIC)),3) AS min_heart_rate
	FROM heart_rate
	GROUP BY user_id)
To '/.../bellabeat-analysis/psql-queries/csv-export/min_heart_rate.csv'
With CSV DELIMITER ',' HEADER;

Copy (SELECT user_id,
		ROUND(MAX(CAST(five_second_heart_rate AS NUMERIC)),3) AS max_heart_rate
	FROM heart_rate
	GROUP BY user_id)
To '/.../bellabeat-analysis/psql-queries/csv-export/max_heart_rate.csv'
With CSV DELIMITER ',' HEADER;

Copy (SELECT EXTRACT(isodow from activity_date) AS day_of_week,
		ROUND(CAST(AVG(total_steps) AS NUMERIC),3) AS avg_steps,
		ROUND(CAST(AVG(total_distance) AS NUMERIC),3) AS avg_distance,
		ROUND(CAST(AVG(tracker_distance) AS NUMERIC),3) AS avg_tracker_distance,
		ROUND(CAST(AVG(logged_activities_distance) AS NUMERIC),3) AS avg_logged_distance,
		ROUND(CAST(AVG(very_active_distance) AS NUMERIC),3) AS avg_very_active_distance,
		ROUND(CAST(AVG(moderately_active_distance) AS NUMERIC),3) AS avg_mod_distance,
		ROUND(CAST(AVG(lightly_active_distance) AS NUMERIC),3) AS avg_light_distance,
		ROUND(CAST(AVG(sedentary_active_distance) AS NUMERIC),3) AS avg_sed_distance,
		ROUND(CAST(AVG(very_active_min) AS NUMERIC),3) AS avg_very_active_min,
		ROUND(CAST(AVG(moderately_active_min) AS NUMERIC),3) AS avg_mod_min,
		ROUND(CAST(AVG(lightly_active_min) AS NUMERIC),3) AS avg_light_min,
		ROUND(CAST(AVG(sedentary_active_min) AS NUMERIC),3) AS avg_sed_min,
		ROUND(CAST(AVG(calories) AS NUMERIC),3) AS avg_calories
	FROM daily_activity
	GROUP BY day_of_week
	ORDER BY day_of_week)
To '/.../bellabeat-analysis/psql-queries/csv-export/avg_daily_activity_by_dow.csv'
With CSV DELIMITER ',' HEADER;

Copy (SELECT EXTRACT(isodow from sleep_date) AS day_of_week,
		ROUND(CAST(AVG(minutes_asleep) AS NUMERIC),3) AS avg_min_asleep,
		ROUND(CAST(AVG(minutes_in_bed) AS NUMERIC),3) AS avg_min_in_bed
	FROM daily_sleep_data
	GROUP BY day_of_week
	ORDER BY day_of_week)
To '/.../bellabeat-analysis/psql-queries/csv-export/avg_daily_sleep_activity_by_dow.csv' 
With CSV DELIMITER ',' HEADER;
