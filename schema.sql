CREATE TABLE users (
    uid VARCHAR(10) PRIMARY KEY,
    device_id VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE grades (
    id SERIAL PRIMARY KEY,
    uid VARCHAR(10) NOT NULL REFERENCES users(uid),
    gpa_all DECIMAL(3,2),
    gpa_13s DECIMAL(4,2),
    cs_65 DECIMAL(3,2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE classes (
    id SERIAL PRIMARY KEY,
    class_code VARCHAR(20) NOT NULL,
    class_name VARCHAR(200),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(class_code)
);
CREATE TABLE user_classes (
    id SERIAL PRIMARY KEY,
    uid VARCHAR(10) NOT NULL REFERENCES users(uid),
    class_code VARCHAR(20) NOT NULL REFERENCES classes(class_code),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(uid, class_code)
);
CREATE TABLE deadlines (
    id SERIAL PRIMARY KEY,
    uid VARCHAR(10) NOT NULL REFERENCES users(uid),
    deadline_date DATE NOT NULL,
    deadline_count INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE piazza_activity (
    id SERIAL PRIMARY KEY,
    uid VARCHAR(10) NOT NULL REFERENCES users(uid),
    days_online INTEGER,
    views INTEGER,
    contributions INTEGER,
    questions INTEGER,
    notes INTEGER,
    answers INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE app_usage (
    id SERIAL PRIMARY KEY,
    uid VARCHAR(10) NOT NULL REFERENCES users(uid),
    device_id VARCHAR(50),
    record_id VARCHAR(100),
    timestamp BIGINT NOT NULL,
    base_activity_class VARCHAR(500),
    base_activity_package VARCHAR(200),
    task_id INTEGER,
    num_activities INTEGER,
    num_running INTEGER,
    top_activity_class VARCHAR(500),
    top_activity_package VARCHAR(200),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE calendar_events (
    id SERIAL PRIMARY KEY,
    uid VARCHAR(10) NOT NULL REFERENCES users(uid),
    device_id VARCHAR(50),
    record_id VARCHAR(100),
    timestamp BIGINT NOT NULL,
    account_label INTEGER,
    event_date DATE,
    event_time TIME,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE call_logs (
    id SERIAL PRIMARY KEY,
    uid VARCHAR(10) NOT NULL REFERENCES users(uid),
    device_id VARCHAR(50),
    record_id VARCHAR(100),
    timestamp BIGINT NOT NULL,
    call_id INTEGER,
    call_date BIGINT,
    call_duration INTEGER,
    call_name TEXT,
    call_number TEXT,
    call_number_label TEXT,
    call_number_type TEXT,
    call_type INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE sms_messages (
    id SERIAL PRIMARY KEY,
    uid VARCHAR(10) NOT NULL REFERENCES users(uid),
    device_id VARCHAR(50),
    record_id VARCHAR(100),
    timestamp BIGINT NOT NULL,
    message_address TEXT,
    message_body TEXT,
    message_date BIGINT,
    message_locked BOOLEAN,
    message_person TEXT,
    message_protocol INTEGER,
    message_read BOOLEAN,
    reply_path_present BOOLEAN,
    service_center TEXT,
    message_status INTEGER,
    message_subject TEXT,
    thread_id INTEGER,
    message_type INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE dining_records (
    id SERIAL PRIMARY KEY,
    uid VARCHAR(10) NOT NULL REFERENCES users(uid),
    date_time TIMESTAMP NOT NULL,
    restaurant VARCHAR(200),
    meal_type VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE activity_sensing (
    id SERIAL PRIMARY KEY,
    uid VARCHAR(10) NOT NULL REFERENCES users(uid),
    timestamp BIGINT NOT NULL,
    activity_inference INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE audio_sensing (
    id SERIAL PRIMARY KEY,
    uid VARCHAR(10) NOT NULL REFERENCES users(uid),
    timestamp BIGINT NOT NULL,
    audio_inference INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE bluetooth_sensing (
    id SERIAL PRIMARY KEY,
    uid VARCHAR(10) NOT NULL REFERENCES users(uid),
    time BIGINT NOT NULL,
    mac_address VARCHAR(20),
    class_id INTEGER,
    level INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE conversation_sensing (
    id SERIAL PRIMARY KEY,
    uid VARCHAR(10) NOT NULL REFERENCES users(uid),
    start_timestamp BIGINT NOT NULL,
    end_timestamp BIGINT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE dark_sensing (
    id SERIAL PRIMARY KEY,
    uid VARCHAR(10) NOT NULL REFERENCES users(uid),
    start_time BIGINT NOT NULL,
    end_time BIGINT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE gps_sensing (
    id SERIAL PRIMARY KEY,
    uid VARCHAR(10) NOT NULL REFERENCES users(uid),
    time BIGINT NOT NULL,
    provider VARCHAR(20),
    network_type VARCHAR(20),
    accuracy DECIMAL(10,2),
    latitude DECIMAL(10,7),
    longitude DECIMAL(10,7),
    altitude DECIMAL(10,2),
    bearing DECIMAL(10,2),
    speed DECIMAL(10,2),
    travel_state VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE phone_charge (
    id SERIAL PRIMARY KEY,
    uid VARCHAR(10) NOT NULL REFERENCES users(uid),
    start_time BIGINT NOT NULL,
    end_time BIGINT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE phone_lock (
    id SERIAL PRIMARY KEY,
    uid VARCHAR(10) NOT NULL REFERENCES users(uid),
    start_time BIGINT NOT NULL,
    end_time BIGINT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE wifi_sensing (
    id SERIAL PRIMARY KEY,
    uid VARCHAR(10) NOT NULL REFERENCES users(uid),
    time BIGINT NOT NULL,
    bssid VARCHAR(20),
    frequency INTEGER,
    level INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE wifi_location (
    id SERIAL PRIMARY KEY,
    uid VARCHAR(10) NOT NULL REFERENCES users(uid),
    time BIGINT NOT NULL,
    bssid VARCHAR(20),
    frequency INTEGER,
    level INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE survey_bigfive (
    id SERIAL PRIMARY KEY,
    uid VARCHAR(10) NOT NULL REFERENCES users(uid),
    survey_type VARCHAR(10) NOT NULL, 
    q1_talkative VARCHAR(50),
    q2_finds_fault VARCHAR(50),
    q3_thorough_job VARCHAR(50),
    q4_depressed VARCHAR(50),
    q5_original_ideas VARCHAR(50),
    q6_reserved VARCHAR(50),
    q7_helpful VARCHAR(50),
    q8_careless VARCHAR(50),
    q9_relaxed VARCHAR(50),
    q10_curious VARCHAR(50),
    q11_full_energy VARCHAR(50),
    q12_starts_quarrels VARCHAR(50),
    q13_reliable_worker VARCHAR(50),
    q14_tense VARCHAR(50),
    q15_ingenious VARCHAR(50),
    q16_generates_enthusiasm VARCHAR(50),
    q17_forgiving VARCHAR(50),
    q18_disorganized VARCHAR(50),
    q19_worries VARCHAR(50),
    q20_active_imagination VARCHAR(50),
    q21_quiet VARCHAR(50),
    q22_trusting VARCHAR(50),
    q23_lazy VARCHAR(50),
    q24_emotionally_stable VARCHAR(50),
    q25_inventive VARCHAR(50),
    q26_assertive VARCHAR(50),
    q27_cold_aloof VARCHAR(50),
    q28_perseveres VARCHAR(50),
    q29_moody VARCHAR(50),
    q30_artistic VARCHAR(50),
    q31_shy VARCHAR(50),
    q32_considerate VARCHAR(50),
    q33_efficient VARCHAR(50),
    q34_calm VARCHAR(50),
    q35_routine_work VARCHAR(50),
    q36_outgoing VARCHAR(50),
    q37_rude VARCHAR(50),
    q38_makes_plans VARCHAR(50),
    q39_nervous VARCHAR(50),
    q40_reflect_ideas VARCHAR(50),
    q41_few_artistic VARCHAR(50),
    q42_cooperates VARCHAR(50),
    q43_distracted VARCHAR(50),
    q44_sophisticated VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(uid, survey_type)
);
CREATE TABLE survey_phq9 (
    id SERIAL PRIMARY KEY,
    uid VARCHAR(10) NOT NULL REFERENCES users(uid),
    survey_type VARCHAR(10) NOT NULL, 
    q1_interest_pleasure VARCHAR(50),
    q2_feeling_down VARCHAR(50),
    q3_sleep_problems VARCHAR(50),
    q4_tired_energy VARCHAR(50),
    q5_appetite VARCHAR(50),
    q6_feeling_bad VARCHAR(50),
    q7_concentrating VARCHAR(50),
    q8_moving_speaking VARCHAR(50),
    q9_thoughts_hurting VARCHAR(50),
    response VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(uid, survey_type)
);
CREATE TABLE survey_psqi (
    id SERIAL PRIMARY KEY,
    uid VARCHAR(10) NOT NULL REFERENCES users(uid),
    survey_type VARCHAR(10) NOT NULL,
    bedtime VARCHAR(50),
    sleep_latency_minutes VARCHAR(50),
    wake_time VARCHAR(50),
    hours_sleep VARCHAR(50),
    trouble_a VARCHAR(50),
    trouble_b VARCHAR(50),
    trouble_c VARCHAR(50),
    trouble_d VARCHAR(50),
    trouble_e VARCHAR(50),
    trouble_f VARCHAR(50),
    trouble_g VARCHAR(50),
    trouble_h VARCHAR(50),
    trouble_i VARCHAR(50),
    trouble_j VARCHAR(50),
    trouble_other TEXT,
    sleep_medication VARCHAR(50),
    trouble_staying_awake VARCHAR(50),
    enthusiasm_problem VARCHAR(50),
    sleep_quality_rating VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(uid, survey_type)
);
CREATE TABLE survey_flourishing (
    id SERIAL PRIMARY KEY,
    uid VARCHAR(10) NOT NULL REFERENCES users(uid),
    survey_type VARCHAR(10) NOT NULL,
    q1_purposeful_life INTEGER,
    q2_social_relationships INTEGER,
    q3_engaged_interested INTEGER,
    q4_contribute_happiness INTEGER,
    q5_competent_capable INTEGER,
    q6_good_person INTEGER,
    q7_optimistic INTEGER,
    q8_people_respect INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(uid, survey_type)
);
CREATE TABLE survey_perceived_stress (
    id SERIAL PRIMARY KEY,
    uid VARCHAR(10) NOT NULL REFERENCES users(uid),
    survey_type VARCHAR(10) NOT NULL,
    q1_upset_unexpected VARCHAR(50),
    q2_unable_control VARCHAR(50),
    q3_nervous_stressed VARCHAR(50),
    q4_confident_handle_problems VARCHAR(50),
    q5_things_going_way VARCHAR(50),
    q6_could_not_cope VARCHAR(50),
    q7_control_irritations VARCHAR(50),
    q8_on_top_of_things VARCHAR(50),
    q9_angered_outside_control VARCHAR(50),
    q10_difficulties_piling VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(uid, survey_type)
);
CREATE TABLE survey_vr12 (
    id SERIAL PRIMARY KEY,
    uid VARCHAR(10) NOT NULL REFERENCES users(uid),
    survey_type VARCHAR(10) NOT NULL,
    general_health VARCHAR(50),
    moderate_activities VARCHAR(50),
    climbing_stairs VARCHAR(50),
    accomplished_less_physical VARCHAR(50),
    limited_work_activities VARCHAR(50),
    accomplished_less_emotional VARCHAR(50),
    careful_work VARCHAR(50),
    pain_interference VARCHAR(50),
    felt_calm_peaceful VARCHAR(50),
    had_energy VARCHAR(50),
    felt_downhearted VARCHAR(50),
    health_interfered_social VARCHAR(50),
    physical_health_compared VARCHAR(50),
    emotional_problems_compared VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(uid, survey_type)
);
CREATE TABLE survey_loneliness (
    id SERIAL PRIMARY KEY,
    uid VARCHAR(10) NOT NULL REFERENCES users(uid),
    survey_type VARCHAR(10) NOT NULL,
    q1_in_tune VARCHAR(50),
    q2_lack_companionship VARCHAR(50),
    q3_no_one_turn_to VARCHAR(50),
    q4_not_feel_alone VARCHAR(50),
    q5_part_of_group VARCHAR(50),
    q6_lot_in_common VARCHAR(50),
    q7_no_longer_close VARCHAR(50),
    q8_interests_not_shared VARCHAR(50),
    q9_outgoing_person VARCHAR(50),
    q10_people_feel_close VARCHAR(50),
    q11_feel_left_out VARCHAR(50),
    q12_social_relationships_superficial VARCHAR(50),
    q13_no_one_knows_well VARCHAR(50),
    q14_feel_isolated VARCHAR(50),
    q15_find_companionship VARCHAR(50),
    q16_people_understand VARCHAR(50),
    q17_unhappy_withdrawn VARCHAR(50),
    q18_people_around_not_with VARCHAR(50),
    q19_people_can_talk VARCHAR(50),
    q20_people_can_turn_to VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(uid, survey_type)
);
CREATE TABLE survey_panas (
    id SERIAL PRIMARY KEY,
    uid VARCHAR(10) NOT NULL REFERENCES users(uid),
    survey_type VARCHAR(10) NOT NULL,
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
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(uid, survey_type)
);
CREATE TABLE ema_qr_code (
    id SERIAL PRIMARY KEY,
    uid VARCHAR(10) NOT NULL REFERENCES users(uid),
    qr_code TEXT,
    response_time BIGINT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE ema_green_key (
    id SERIAL PRIMARY KEY,
    uid VARCHAR(10) NOT NULL REFERENCES users(uid),
    response_data JSONB,
    response_time BIGINT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE ema_responses (
    id SERIAL PRIMARY KEY,
    uid VARCHAR(10) NOT NULL REFERENCES users(uid),
    ema_type VARCHAR(100) NOT NULL,
    response_data JSONB,
    response_time BIGINT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
