-- ==========================================
-- CS598 Dataset: Full Database Setup Script
-- ==========================================

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
\COPY class(uid, course1, course2, course3, course4)
FROM 'C:/Users/AnnieMo/Downloads/class_normalized.csv' CSV HEADER;

-- 5. Create activity_summary table
CREATE TABLE activity_summary (
    uid VARCHAR(10) REFERENCES participants(uid),
    activity_id INT,
    activity_count INT
);

-- 6. Import activity_summary_all.csv
\COPY activity_summary(uid, activity_id, activity_count)
FROM 'C:/Users/AnnieMo/Downloads/activity_summary_all.csv' CSV HEADER;

-- 7. Create sleep questionnaire table
CREATE TABLE sleep_questionnaire (
    uid VARCHAR(10) REFERENCES participants(uid),
    type VARCHAR(10),
    bedtime VARCHAR(20),
    time_to_fall_sleep FLOAT,
    wake_up_time VARCHAR(20),
    hours_sleep FLOAT,
    sleep_quality_score INT
);

-- 8. Import cleaned PSQI CSV
\COPY sleep_questionnaire(uid, type, bedtime, time_to_fall_sleep, wake_up_time, hours_sleep, sleep_quality_score)
FROM 'C:/Users/AnnieMo/Downloads/psqi-csv.csv' CSV HEADER;

-- ==========================================
-- CS598 Dataset: Full Database Setup Script
-- ==========================================

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
\COPY class(uid, course1, course2, course3, course4)
FROM 'C:/Users/AnnieMo/Downloads/class_normalized.csv' CSV HEADER;

-- 5. Create activity_summary table
CREATE TABLE activity_summary (
    uid VARCHAR(10) REFERENCES participants(uid),
    activity_id INT,
    activity_count INT
);

-- 6. Import activity_summary_all.csv
\COPY activity_summary(uid, activity_id, activity_count)
FROM 'C:/Users/AnnieMo/Downloads/activity_summary_all.csv' CSV HEADER;

-- 7. Create sleep questionnaire table
CREATE TABLE sleep_questionnaire (
    uid VARCHAR(10) REFERENCES participants(uid),
    type VARCHAR(10),
    bedtime VARCHAR(20),
    time_to_fall_sleep FLOAT,
    wake_up_time VARCHAR(20),
    hours_sleep FLOAT,
    sleep_quality_score INT
);

-- 8. Import cleaned PSQI CSV
\COPY sleep_questionnaire(uid, type, bedtime, time_to_fall_sleep, wake_up_time, hours_sleep, sleep_quality_score)
FROM 'C:/Users/AnnieMo/Downloads/psqi-csv.csv' CSV HEADER;

-- 9. Create grades table with GPA columns
CREATE TABLE grades (
    id SERIAL PRIMARY KEY,
    uid VARCHAR(10) REFERENCES participants(uid),
    gpa_all FLOAT,
    gpa_13s FLOAT,
    cs_65 FLOAT
);

-- 10. Import grades CSV (update file path)
\COPY grades(uid, gpa_all, gpa_13s, cs_65)
FROM 'C:/Users/AnnieMo/Downloads/grades.csv' CSV HEADER;
