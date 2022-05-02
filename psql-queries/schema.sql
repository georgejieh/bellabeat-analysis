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