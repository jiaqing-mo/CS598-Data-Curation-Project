CREATE TABLE grades (
    uid VARCHAR(10) PRIMARY KEY,
    gpa_all DECIMAL(4, 3),
    gpa_13s DECIMAL(4, 3),
    cs_65 DECIMAL(4, 3)
);
CREATE TABLE calendar_events (
    id VARCHAR(100) PRIMARY KEY,
    device VARCHAR(100) NOT NULL,
    timestamp BIGINT NOT NULL,
    account_label INTEGER,
    date DATE,
    time TIME,
    uid VARCHAR(10),
    FOREIGN KEY (uid) REFERENCES grades(uid) ON DELETE CASCADE,
    INDEX idx_calendar_uid (uid),
    INDEX idx_calendar_date (date),
    INDEX idx_calendar_timestamp (timestamp)
);
CREATE TABLE calendar_summary (
    uid VARCHAR(10) PRIMARY KEY,
    total_calendar_events INTEGER DEFAULT 0,
    FOREIGN KEY (uid) REFERENCES grades(uid) ON DELETE CASCADE
);
CREATE TABLE dining (
    id INT AUTO_INCREMENT PRIMARY KEY,
    uid VARCHAR(10) NOT NULL,
    date_time DATETIME NOT NULL,
    restaurant VARCHAR(255),
    type VARCHAR(50), 
    FOREIGN KEY (uid) REFERENCES grades(uid) ON DELETE CASCADE,
    INDEX idx_dining_uid (uid),
    INDEX idx_dining_date (date_time)
);
CREATE TABLE survey_bigfive (
    id INT AUTO_INCREMENT PRIMARY KEY,
    uid VARCHAR(10) NOT NULL,
    type VARCHAR(10), 
    openness DECIMAL(5, 2),
    conscientiousness DECIMAL(5, 2),
    extraversion DECIMAL(5, 2),
    agreeableness DECIMAL(5, 2),
    neuroticism DECIMAL(5, 2),
    FOREIGN KEY (uid) REFERENCES grades(uid) ON DELETE CASCADE,
    INDEX idx_bigfive_uid (uid),
    INDEX idx_bigfive_type (type)
);
CREATE TABLE survey_phq9 (
    id INT AUTO_INCREMENT PRIMARY KEY,
    uid VARCHAR(10) NOT NULL,
    type VARCHAR(10),
    q1 INTEGER, 
    q2 INTEGER, 
    q3 INTEGER, 
    q4 INTEGER, 
    q5 INTEGER, 
    q6 INTEGER, 
    q7 INTEGER, 
    q8 INTEGER, 
    q9 INTEGER, 
    total_score INTEGER, 
    FOREIGN KEY (uid) REFERENCES grades(uid) ON DELETE CASCADE,
    INDEX idx_phq9_uid (uid),
    INDEX idx_phq9_type (type)
);
CREATE TABLE survey_psqi (
    id INT AUTO_INCREMENT PRIMARY KEY,
    uid VARCHAR(10) NOT NULL,
    type VARCHAR(10),
    bedtime_time TIME,
    sleep_latency_minutes INTEGER,
    wake_time TIME,
    actual_sleep_hours DECIMAL(4, 2),
    cannot_sleep_30min INTEGER,
    wake_middle_night INTEGER,
    bathroom INTEGER,
    cannot_breathe INTEGER,
    cough_snore INTEGER,
    feel_cold INTEGER,
    feel_hot INTEGER,
    bad_dreams INTEGER,
    have_pain INTEGER,
    other_reason INTEGER,
    other_reason_description TEXT,
    sleep_medication_frequency INTEGER,
    daytime_dysfunction INTEGER,
    overall_quality INTEGER,
    total_score INTEGER, 
    FOREIGN KEY (uid) REFERENCES grades(uid) ON DELETE CASCADE,
    INDEX idx_psqi_uid (uid),
    INDEX idx_psqi_type (type)
);
CREATE TABLE survey_flourishing (
    id INT AUTO_INCREMENT PRIMARY KEY,
    uid VARCHAR(10) NOT NULL,
    type VARCHAR(10),
    q1 INTEGER,
    q2 INTEGER,
    q3 INTEGER,
    q4 INTEGER,
    q5 INTEGER,
    q6 INTEGER,
    q7 INTEGER,
    q8 INTEGER,
    total_score INTEGER,
    FOREIGN KEY (uid) REFERENCES grades(uid) ON DELETE CASCADE,
    INDEX idx_flourishing_uid (uid),
    INDEX idx_flourishing_type (type)
);
CREATE TABLE survey_perceived_stress (
    id INT AUTO_INCREMENT PRIMARY KEY,
    uid VARCHAR(10) NOT NULL,
    type VARCHAR(10),
    q1 VARCHAR(50),
    q2 VARCHAR(50),
    q3 VARCHAR(50),
    q4 VARCHAR(50),
    q5 VARCHAR(50),
    q6 VARCHAR(50),
    q7 VARCHAR(50),
    q8 VARCHAR(50),
    q9 VARCHAR(50),
    q10 VARCHAR(50),
    FOREIGN KEY (uid) REFERENCES grades(uid) ON DELETE CASCADE,
    INDEX idx_stress_uid (uid),
    INDEX idx_stress_type (type)
);
CREATE TABLE survey_vr12 (
    id INT AUTO_INCREMENT PRIMARY KEY,
    uid VARCHAR(10) NOT NULL,
    type VARCHAR(10),
    general_health VARCHAR(50),
    moderate_activities VARCHAR(50),
    climbing_stairs VARCHAR(50),
    accomplished_less INTEGER,
    limited_work INTEGER,
    accomplished_less_emotional INTEGER,
    careful_work INTEGER,
    pain_interference VARCHAR(50),
    felt_calm VARCHAR(50),
    had_energy VARCHAR(50),
    felt_downhearted VARCHAR(50),
    social_activities_interference VARCHAR(50),
    physical_health_score DECIMAL(5, 2),
    mental_health_score DECIMAL(5, 2),
    FOREIGN KEY (uid) REFERENCES grades(uid) ON DELETE CASCADE,
    INDEX idx_vr12_uid (uid),
    INDEX idx_vr12_type (type)
);
CREATE TABLE survey_loneliness (
    id INT AUTO_INCREMENT PRIMARY KEY,
    uid VARCHAR(10) NOT NULL,
    type VARCHAR(10),
    q1 INTEGER,
    q2 INTEGER,
    q3 INTEGER,
    q4 INTEGER,
    q5 INTEGER,
    q6 INTEGER,
    q7 INTEGER,
    q8 INTEGER,
    q9 INTEGER,
    q10 INTEGER,
    q11 INTEGER,
    q12 INTEGER,
    q13 INTEGER,
    q14 INTEGER,
    q15 INTEGER,
    q16 INTEGER,
    q17 INTEGER,
    q18 INTEGER,
    q19 INTEGER,
    q20 INTEGER,
    total_score INTEGER,
    FOREIGN KEY (uid) REFERENCES grades(uid) ON DELETE CASCADE,
    INDEX idx_loneliness_uid (uid),
    INDEX idx_loneliness_type (type)
);
CREATE TABLE survey_panas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    uid VARCHAR(10) NOT NULL,
    type VARCHAR(10), 
    interested INTEGER,
    distressed INTEGER,
    upset INTEGER,
    strong INTEGER,
    guilty INTEGER,
    scared INTEGER,
    hostile INTEGER,
    enthusiastic INTEGER,
    proud INTEGER,
    irritable INTEGER,
    alert INTEGER,
    inspired INTEGER,
    nervous INTEGER,
    determined INTEGER,
    attentive INTEGER,
    jittery INTEGER,
    active INTEGER,
    afraid INTEGER,
    positive_affect_score INTEGER,
    negative_affect_score INTEGER,
    FOREIGN KEY (uid) REFERENCES grades(uid) ON DELETE CASCADE,
    INDEX idx_panas_uid (uid),
    INDEX idx_panas_type (type)
);
CREATE TABLE call_logs (
    id VARCHAR(100) PRIMARY KEY,
    device VARCHAR(100) NOT NULL,
    timestamp BIGINT NOT NULL,
    calls_id INTEGER,
    calls_date BIGINT,
    calls_duration INTEGER, 
    calls_name VARCHAR(255),
    calls_number VARCHAR(50),
    calls_numberlabel VARCHAR(100),
    calls_numbertype VARCHAR(50),
    calls_type VARCHAR(50), 
    INDEX idx_call_logs_device (device),
    INDEX idx_call_logs_timestamp (timestamp),
    INDEX idx_call_logs_date (calls_date)
);
CREATE TABLE sms (
    id VARCHAR(100) PRIMARY KEY,
    device VARCHAR(100) NOT NULL,
    timestamp BIGINT NOT NULL,
    messages_address VARCHAR(255),
    messages_body TEXT,
    messages_date BIGINT,
    messages_locked BOOLEAN,
    messages_person VARCHAR(255),
    messages_protocol VARCHAR(50),
    messages_read BOOLEAN,
    messages_reply_path_present BOOLEAN,
    messages_service_center VARCHAR(255),
    messages_status INTEGER,
    messages_subject VARCHAR(255),
    messages_thread_id INTEGER,
    messages_type VARCHAR(50), 
    INDEX idx_sms_device (device),
    INDEX idx_sms_timestamp (timestamp),
    INDEX idx_sms_thread (messages_thread_id)
);
CREATE TABLE app_usage (
    id VARCHAR(100) PRIMARY KEY,
    device VARCHAR(100) NOT NULL,
    timestamp BIGINT NOT NULL,
    running_tasks_baseactivity_mclass VARCHAR(500),
    running_tasks_baseactivity_mpackage VARCHAR(255),
    running_tasks_id INTEGER,
    running_tasks_numactivities INTEGER,
    running_tasks_numrunning INTEGER,
    running_tasks_topactivity_mclass VARCHAR(500),
    running_tasks_topactivity_mpackage VARCHAR(255),
    INDEX idx_app_usage_device (device),
    INDEX idx_app_usage_timestamp (timestamp),
    INDEX idx_app_usage_package (running_tasks_baseactivity_mpackage)
);
CREATE TABLE sensing_activity (
    id INT AUTO_INCREMENT PRIMARY KEY,
    device VARCHAR(100) NOT NULL,
    timestamp BIGINT NOT NULL,
    activity_inference INTEGER, 
    INDEX idx_activity_device (device),
    INDEX idx_activity_timestamp (timestamp)
);
CREATE TABLE sensing_bluetooth (
    id INT AUTO_INCREMENT PRIMARY KEY,
    device VARCHAR(100) NOT NULL,
    time BIGINT NOT NULL,
    mac VARCHAR(17), 
    class_id BIGINT,
    level INTEGER, 
    INDEX idx_bluetooth_device (device),
    INDEX idx_bluetooth_time (time),
    INDEX idx_bluetooth_mac (mac)
);
CREATE TABLE sensing_gps (
    id INT AUTO_INCREMENT PRIMARY KEY,
    device VARCHAR(100) NOT NULL,
    timestamp BIGINT NOT NULL,
    latitude DECIMAL(10, 8),
    longitude DECIMAL(11, 8),
    altitude DECIMAL(10, 2),
    accuracy DECIMAL(10, 2),
    INDEX idx_gps_device (device),
    INDEX idx_gps_timestamp (timestamp),
    INDEX idx_gps_location (latitude, longitude)
);
CREATE TABLE sensing_wifi (
    id INT AUTO_INCREMENT PRIMARY KEY,
    device VARCHAR(100) NOT NULL,
    timestamp BIGINT NOT NULL,
    ssid VARCHAR(255),
    bssid VARCHAR(17), 
    rssi INTEGER, 
    frequency INTEGER,
    INDEX idx_wifi_device (device),
    INDEX idx_wifi_timestamp (timestamp),
    INDEX idx_wifi_bssid (bssid)
);
CREATE TABLE sensing_wifi_location (
    id INT AUTO_INCREMENT PRIMARY KEY,
    device VARCHAR(100) NOT NULL,
    timestamp BIGINT NOT NULL,
    latitude DECIMAL(10, 8),
    longitude DECIMAL(11, 8),
    accuracy DECIMAL(10, 2),
    INDEX idx_wifi_loc_device (device),
    INDEX idx_wifi_loc_timestamp (timestamp)
);
CREATE TABLE sensing_audio (
    id INT AUTO_INCREMENT PRIMARY KEY,
    device VARCHAR(100) NOT NULL,
    timestamp BIGINT NOT NULL,
    audio_level DECIMAL(10, 2),
    frequency DECIMAL(10, 2),
    INDEX idx_audio_device (device),
    INDEX idx_audio_timestamp (timestamp)
);
CREATE TABLE sensing_conversation (
    id INT AUTO_INCREMENT PRIMARY KEY,
    device VARCHAR(100) NOT NULL,
    timestamp BIGINT NOT NULL,
    conversation_detected BOOLEAN,
    duration INTEGER, 
    INDEX idx_conversation_device (device),
    INDEX idx_conversation_timestamp (timestamp)
);
CREATE TABLE sensing_phonecharge (
    id INT AUTO_INCREMENT PRIMARY KEY,
    device VARCHAR(100) NOT NULL,
    timestamp BIGINT NOT NULL,
    battery_level INTEGER, 
    charging_status BOOLEAN,
    INDEX idx_charge_device (device),
    INDEX idx_charge_timestamp (timestamp)
);
CREATE TABLE sensing_phonelock (
    id INT AUTO_INCREMENT PRIMARY KEY,
    device VARCHAR(100) NOT NULL,
    timestamp BIGINT NOT NULL,
    lock_status BOOLEAN, 
    INDEX idx_lock_device (device),
    INDEX idx_lock_timestamp (timestamp)
);
CREATE TABLE sensing_dark (
    id INT AUTO_INCREMENT PRIMARY KEY,
    device VARCHAR(100) NOT NULL,
    timestamp BIGINT NOT NULL,
    dark_status BOOLEAN, 
    INDEX idx_dark_device (device),
    INDEX idx_dark_timestamp (timestamp)
);
CREATE TABLE education_classes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    uid VARCHAR(10),
    class_code VARCHAR(50),
    class_name VARCHAR(255),
    semester VARCHAR(50),
    year INTEGER,
    FOREIGN KEY (uid) REFERENCES grades(uid) ON DELETE CASCADE,
    INDEX idx_classes_uid (uid),
    INDEX idx_classes_code (class_code)
);
CREATE TABLE education_deadlines (
    id INT AUTO_INCREMENT PRIMARY KEY,
    uid VARCHAR(10),
    class_code VARCHAR(50),
    deadline_name VARCHAR(255),
    deadline_date DATETIME,
    deadline_type VARCHAR(50), 
    FOREIGN KEY (uid) REFERENCES grades(uid) ON DELETE CASCADE,
    INDEX idx_deadlines_uid (uid),
    INDEX idx_deadlines_date (deadline_date)
);
CREATE TABLE education_piazza (
    id INT AUTO_INCREMENT PRIMARY KEY,
    uid VARCHAR(10),
    class_code VARCHAR(50),
    post_id VARCHAR(100),
    post_type VARCHAR(50), 
    timestamp BIGINT,
    content TEXT,
    FOREIGN KEY (uid) REFERENCES grades(uid) ON DELETE CASCADE,
    INDEX idx_piazza_uid (uid),
    INDEX idx_piazza_timestamp (timestamp)
);
CREATE TABLE device_mapping (
    device VARCHAR(100) PRIMARY KEY,
    uid VARCHAR(10),
    device_type VARCHAR(50),
    FOREIGN KEY (uid) REFERENCES grades(uid) ON DELETE CASCADE,
    INDEX idx_device_uid (uid)
);
CREATE VIEW user_summary AS
SELECT 
    g.uid,
    g.gpa_all,
    g.gpa_13s,
    g.cs_65,
    cs.total_calendar_events,
    (SELECT COUNT(*) FROM dining d WHERE d.uid = g.uid) AS total_dining_visits,
    (SELECT AVG(positive_affect_score) FROM survey_panas sp WHERE sp.uid = g.uid) AS avg_positive_affect,
    (SELECT AVG(negative_affect_score) FROM survey_panas sp WHERE sp.uid = g.uid) AS avg_negative_affect,
    (SELECT AVG(total_score) FROM survey_phq9 sp WHERE sp.uid = g.uid) AS avg_phq9_score
FROM grades g
LEFT JOIN calendar_summary cs ON g.uid = cs.uid;
CREATE VIEW daily_activity_summary AS
SELECT 
    DATE(FROM_UNIXTIME(timestamp)) AS activity_date,
    device,
    COUNT(*) AS total_events,
    COUNT(DISTINCT DATE(FROM_UNIXTIME(timestamp))) AS active_days
FROM (
    SELECT device, timestamp FROM call_logs
    UNION ALL
    SELECT device, timestamp FROM sms
    UNION ALL
    SELECT device, timestamp FROM app_usage
) AS combined_activity
GROUP BY DATE(FROM_UNIXTIME(timestamp)), device;
