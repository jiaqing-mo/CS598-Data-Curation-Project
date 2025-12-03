CS598 Dataset Processing Pipeline
Overview

This project provides a fully automated pipeline for cleaning, integrating, and preparing the CS598 dataset for analysis. The pipeline processes multiple data sources including:

Class grades

Activity inference data (smartphone accelerometer)

Sleep questionnaire (PSQI) data

Custom sleep survey data

The processed outputs can be directly imported into a database for analysis or used in data science workflows.

Folder Structure
CS598_Dataset/
├─ dataset/
│  ├─ sensing/activity/       # Raw activity CSV files
│  ├─ education/              # Class and grades CSV files
│  ├─ psqi.csv                # Original sleep survey data
│  └─ processed/              # Folder for cleaned CSV outputs
├─ full_pipeline.py           # Unified Python pipeline
└─ README.md                  # Project documentation

Requirements

Python 3.10+

pandas

glob

re

PostgreSQL (optional, for database import)

Install dependencies:

pip install pandas

Usage

Place all raw CSV files in the appropriate folders:

dataset/sensing/activity/ → activity files (activity_u00.csv, etc.)

dataset/education/ → class and grades CSV files

dataset/ → psqi.csv

Run the full pipeline:

python full_pipeline.py


Outputs will be saved in dataset/processed/:

class_cleaned.csv → cleaned class information

activity_summary_all.csv → filtered and summarized activity data

survey.csv → cleaned custom survey data

grades_cleaned.csv → imported grades data

Data Cleaning Details

Class and grades CSVs: Standardized column names and formats.

Activity CSVs: Removed stationary activities (activity_id = 0), summarized activity counts per user.

Survey CSV: OpenRefine-style cleaning applied:

Normalized text entries (mins, hours, etc.)

Converted sleep quality to numeric scores (1–4)

Removed unnecessary columns

Standardized column names for bedtime, wake-up time, hours of sleep, and time to fall asleep

Database Integration

Processed CSVs can be imported into a PostgreSQL database using the \COPY command:

\COPY participants(uid) FROM 'dataset/processed/participants.csv' CSV HEADER;
\COPY class(uid, course, grade) FROM 'dataset/processed/class_cleaned.csv' CSV HEADER;
\COPY activity_summary(uid, activity_id, activity_count) FROM 'dataset/processed/activity_summary_all.csv' CSV HEADER;
\COPY survey(uid, bedtime, time_to_fall_sleep, wake_up_time, hour_sleep, sleep_quality_score) FROM 'dataset/processed/survey_data_cleaned.csv' CSV HEADER;
\COPY grades(uid, gpa_all, gpa_13s, cs_65) FROM 'dataset/processed/grades_cleaned.csv' CSV HEADER;




Reproducibility & Workflow

All data cleaning and integration steps are fully reproducible through full_pipeline.py.

Any updates to raw CSV files can be re-processed by rerunning the script.

The pipeline maintains consistent naming, formatting, and numeric conversion for all data sources.

Data Dictionary / Metadata

A data dictionary and detailed metadata (DataCite schema) should be maintained for each table, describing columns, types, and meanings.

Example tables: participants, class, activity_summary, psqi, survey_data, grades.

License

This project is for educational use. Please cite appropriately when using this dataset or pipeline.