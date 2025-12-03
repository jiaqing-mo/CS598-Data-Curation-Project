## Setup

This project requires python 3.9+

Run `pip install -r requirements.txt` to install the dependencies

It's better to run the scirpts on a linux machine.

## How to run 

1. Download the data (see `source_data.txt`)
2. Set the paths in configs/config.py
3. Run the script:

- Single script to process all the files

`bash curate/curate_all.sh`

- Process individual files:

`python -m curate.<<file name>>`

- Output files would be generated in `processed_data`.
- Provenance files would be in `provenance`.

## What it does

education/grades.csv:
- Read raw CSV.
- Stripped whitespace from column names and uid.
- Dropped any rows with null values.
- Validated that the gpa column (if present) has no values < 0.


education/piazza.csv
- Read CSV and stripped whitespace from column names.
- Standardized uid as stripped string.
- Coerced Piazza metric columns to numeric (with errors='coerce').
- Dropped rows with any nulls after coercion.
- Inner-joined with processed grades on uid to keep only valid students.


education/class.csv
- Read non-standard CSV line-by-line.
- Split each line on commas: first token as uid, remaining tokens as course codes.
- Created one row per (uid, course) pair with a course_index.
- Stripped whitespace from uid and course_raw.
- Filtered to uids present in the processed grades table.


education/deadlines.csv
- Read wide-format deadlines CSV.
- Stripped whitespace from column names and uid.
- Identified all date columns (all columns except uid).
- Melted wide table to long format: [uid, date_str, num_deadlines].
- Coerced num_deadlines to numeric and parsed date_str to datetime (date).
- Dropped rows with invalid dates or missing num_deadlines.
- Kept only rows with num_deadlines > 0.
- Standardized uid formatting and cast num_deadlines to int.
- Filtered to uids present in the processed grades table.


calendar/
- Discovered all calendar CSV files recursively under BASE_PATH/calendar/.
- Read each CSV file.
- Normalized DATE using normalize_dates() (if present).
- Inferred uid from filename suffix and added as uid column.
- Concatenated all files into a single event-level table.
- Standardized column names and uid formatting (strip).
- Filtered to uids present in the processed grades table.


dinning/
- Discovered all TXT files recursively under BASE_PATH/dinning/.
- Read each as CSV with columns [DATE, RESTAURANT, TYPE].
- Parsed DATE into DATE_TIME (datetime).
- Inferred uid from filename suffix and added as uid column.
- Concatenated into a single event-level dining table.
- Standardized column names and uid formatting (strip).
- Filtered to uids present in the processed grades table.


sms/
- Discovered all SMS CSV files recursively under BASE_PATH/sms/.
- Read each CSV file.
- Normalized timestamp from Unix seconds to datetime (if present).
- Inferred uid from filename suffix and added as uid column.
- Concatenated into a single event-level SMS table.
- Standardized column names and uid formatting (strip).
- Filtered to uids present in the processed grades table.


call_log/
- Discovered all call log CSV files recursively under BASE_PATH/call_log/.
- Read each CSV file.
- Normalized timestamp from Unix seconds to datetime (if present).
- Optionally normalized CALLS_date from ms to datetime (if present).
- Inferred uid from filename suffix and added as uid column.
- Concatenated into a single event-level call log table.
- Standardized column names and uid formatting (strip).
- Filtered to uids present in the processed grades table.


app_usage/
- Discovered all app usage CSV files recursively under BASE_PATH/app_usage/.
- Read each CSV file.
- Normalized timestamp from Unix seconds to datetime (if present).
- Inferred uid from filename suffix and added as uid column.
- Concatenated into a single event-level app usage table.
- Standardized column names and uid formatting (strip).
- Filtered to uids present in the processed grades table.


sensing/activity/
- Discovered all activity CSV files recursively under BASE_PATH/sensing/activity/.
- Read each CSV file.
- Stripped whitespace from column names.
- Renamed activity inference to activity_inference (if present).
- Normalized timestamp from Unix seconds to datetime (if present).
- Inferred uid from filename suffix and added as uid column.
- Concatenated into a single event-level activity table.
- Standardized uid formatting (strip).
- Filtered to uids present in the processed grades table.