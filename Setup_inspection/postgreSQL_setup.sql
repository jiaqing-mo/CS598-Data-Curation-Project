-- ==========================================
-- CS598 Dataset: Full Database Setup Script
-- ==========================================

-- Set path variables (update these paths as needed)
\set processed_data_path 'C:/Users/AnnieMo/source/uiuc-cs513-group/CS598-Data-Curation-Project/data_cleaning/processed_data'


-- 1. Create participants table
CREATE TABLE participants (
    uid VARCHAR(10) PRIMARY KEY
);

-- 2. Insert all uids
INSERT INTO participants(uid) VALUES
('u00'),('u01'),('u02'),('u03'),('u04'),('u05'),('u07'),('u08'),('u09'),('u10'),
('u12'),('u13'),('u14'),('u15'),('u16'),('u17'),('u18'),('u19'),('u20'),('u22'),
('u23'),('u24'),('u25'),('u27'),('u30'),('u31'),('u32'),('u33'),('u34'),('u35'),
('u36'),('u39'),('u41'),('u42'),('u43'),('u44'),('u45'),('u46'),('u47'),('u49'),
('u50'),('u51'),('u52'),('u53'),('u54'),('u56'),('u57'),('u58'),('u59');

-- 3. Create class table
CREATE TABLE class (
    uid VARCHAR(10) REFERENCES participants(uid),
    course1 VARCHAR(20),
    course2 VARCHAR(20),
    course3 VARCHAR(20),
    course4 VARCHAR(20)
);

-- 4. Import class_normalized.csv
\set class_normalized_file :processed_data_path '/class_normalized.csv'
\COPY class(uid, course1, course2, course3, course4)
FROM :'class_normalized_file' CSV HEADER;

-- 5. Create activity_summary table
CREATE TABLE activity_summary (
    uid VARCHAR(10) REFERENCES participants(uid),
    activity_id INT,
    activity_count INT
);

-- 6. Import activity_summary_all.csv from processed_data
\set activity_summary_file :processed_data_path '/activity_summary_all.csv'
\COPY activity_summary(uid, activity_id, activity_count)
FROM :'activity_summary_file' CSV HEADER;

-- 7. Create grades table with GPA columns
CREATE TABLE grades (
    id SERIAL PRIMARY KEY,
    uid VARCHAR(10) REFERENCES participants(uid),
    gpa_all FLOAT,
    gpa_13s FLOAT,
    cs_65 FLOAT
);

-- 8. Import grades CSV from processed_data
\set grades_file :processed_data_path '/grades.csv'
\COPY grades(uid, gpa_all, gpa_13s, cs_65)
FROM :'grades_file' CSV HEADER;

-- 9. Create calendar table
CREATE TABLE calendar (
    id VARCHAR(100),
    device VARCHAR(100),
    timestamp BIGINT,
    account_label VARCHAR(10),
    date DATE,
    time VARCHAR(20),
    uid VARCHAR(10) REFERENCES participants(uid)
);

-- 10. Import calendar CSV
\set calendar_file :processed_data_path '/calendar.csv'
\COPY calendar(id, device, timestamp, account_label, date, time, uid)
FROM :'calendar_file' CSV HEADER;

-- 11. Create call_log table
CREATE TABLE call_log (
    id VARCHAR(100),
    device VARCHAR(100),
    timestamp TIMESTAMP,
    calls_id FLOAT,
    calls_date TIMESTAMP,
    calls_duration FLOAT,
    calls_name TEXT,
    calls_number TEXT,
    calls_numberlabel TEXT,
    calls_numbertype TEXT,
    calls_type FLOAT,
    uid VARCHAR(10) REFERENCES participants(uid)
);

-- 12. Import call_log CSV
\set call_log_file :processed_data_path '/call_log.csv'
\COPY call_log(id, device, timestamp, calls_id, calls_date, calls_duration, calls_name, calls_number, calls_numberlabel, calls_numbertype, calls_type, uid)
FROM :'call_log_file' CSV HEADER;

-- 13. Create deadlines table
CREATE TABLE deadlines (
    uid VARCHAR(10) REFERENCES participants(uid),
    date DATE,
    num_deadlines INT
);

-- 14. Import deadlines CSV
\set deadlines_file :processed_data_path '/deadlines.csv'
\COPY deadlines(uid, date, num_deadlines)
FROM :'deadlines_file' CSV HEADER;

-- 15. Create dining table
CREATE TABLE dining (
    date TIMESTAMP,
    restaurant VARCHAR(100),
    type VARCHAR(20),
    date_time TIMESTAMP,
    uid VARCHAR(10) REFERENCES participants(uid)
);

-- 16. Import dining CSV (note: file is named dinning.csv)
\set dining_file :processed_data_path '/dinning.csv'
\COPY dining(date, restaurant, type, date_time, uid)
FROM :'dining_file' CSV HEADER;

-- 17. Create piazza table
CREATE TABLE piazza (
    uid VARCHAR(10) REFERENCES participants(uid),
    days_online INT,
    views INT,
    contributions INT,
    questions INT,
    notes INT,
    answers INT
);

-- 18. Import piazza CSV
\set piazza_file :processed_data_path '/piazza.csv'
\COPY piazza(uid, days_online, views, contributions, questions, notes, answers)
FROM :'piazza_file' CSV HEADER;

-- 19. Create sms table
CREATE TABLE sms (
    id VARCHAR(100),
    device VARCHAR(100),
    timestamp TIMESTAMP,
    messages_address TEXT,
    messages_body TEXT,
    messages_date FLOAT,
    messages_locked BOOLEAN,
    messages_person TEXT,
    messages_protocol FLOAT,
    messages_read BOOLEAN,
    messages_reply_path_present BOOLEAN,
    messages_service_center TEXT,
    messages_status FLOAT,
    messages_subject TEXT,
    messages_thread_id FLOAT,
    messages_type FLOAT,
    uid VARCHAR(10) REFERENCES participants(uid)
);

-- 20. Import sms CSV
\set sms_file :processed_data_path '/sms.csv'
\COPY sms(id, device, timestamp, messages_address, messages_body, messages_date, messages_locked, messages_person, messages_protocol, messages_read, messages_reply_path_present, messages_service_center, messages_status, messages_subject, messages_thread_id, messages_type, uid)
FROM :'sms_file' CSV HEADER;

-- 21. Create survey table (sleep questionnaire from processed_data)
CREATE TABLE survey (
    uid VARCHAR(10) REFERENCES participants(uid),
    type VARCHAR(10),
    bedtime VARCHAR(50),
    time_to_fall_sleep FLOAT,
    wake_up_time VARCHAR(50),
    hour_sleep FLOAT,
    sleep_quality_score INT
);

-- 22. Import survey CSV
\set survey_file :processed_data_path '/survey.csv'
\COPY survey(uid, type, bedtime, time_to_fall_sleep, wake_up_time, hour_sleep, sleep_quality_score)
FROM :'survey_file' CSV HEADER;

