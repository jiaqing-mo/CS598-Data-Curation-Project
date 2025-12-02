# full_pipeline.py
import os
import pandas as pd
import glob
import re

# --- CONFIGURATION ---
base_path = r"dataset"
activity_path = os.path.join(base_path, "sensing", "activity")
class_file = os.path.join(base_path, "education", "class_normalized.csv")
psqi_file = os.path.join(base_path, "psqi.csv")
grades_file = os.path.join(base_path, "education", "grades.csv")
output_dir = os.path.join(base_path, "processed")
os.makedirs(output_dir, exist_ok=True)

# --- STEP 1: IMPORT CLASS CSV ---
print("Importing class data...")
class_df = pd.read_csv(class_file)
class_df.to_csv(os.path.join(output_dir, "class_cleaned.csv"), index=False)
print(f"Class data saved to {output_dir}/class_cleaned.csv")

# --- STEP 2: PROCESS ACTIVITY FILES ---
print("Processing activity files...")
activity_files = glob.glob(os.path.join(activity_path, "activity_u*.csv"))
summary_list = []

for file in activity_files:
    uid = os.path.basename(file).split("_")[1].split(".")[0]
    print(f"Processing {file}...")
    try:
        df = pd.read_csv(file)
    except Exception as e:
        print(f"Error reading {file}: {e}")
        continue

    if "activity inference" not in df.columns:
        df.columns = ["timestamp", "activity inference"]

    # Filter out stationary (0)
    df = df[df["activity inference"] != 0]

    # Count frequency per activity
    counts = df["activity inference"].value_counts().reset_index()
    counts.columns = ["activity_id", "activity_count"]
    counts["uid"] = uid
    summary_list.append(counts)

if summary_list:
    activity_summary = pd.concat(summary_list, ignore_index=True)
    activity_summary = activity_summary[["uid", "activity_id", "activity_count"]]
    activity_summary.to_csv(os.path.join(output_dir, "activity_summary_all.csv"), index=False)
    print(f"Activity summary saved to {output_dir}/activity_summary_all.csv")
else:
    print("No activity data processed.")

# --- STEP 3: IMPORT PSQI (SURVEY) DATA ---
if os.path.exists(psqi_file):
    print("Cleaning survey data...")
    survey_df = pd.read_csv(psqi_file)

    col_time_to_sleep = "During the past month, how long (in minutes) has it usually taken you to fall asleep each night?"
    col_hour_sleep = "During the past month, how many hours of actual sleep did you get at night? (This may be different than the number of hours you spent in bed.)"
    col_quality = "During the past month, how would you rate your sleep quality overall?"

    # 1. Mass edits
    mass_edit_map = {
        "30": ["30  minutes", "30 minutes"],
        "60": ["1 Hour", "1 hour", "1 hr"],
        "15": ["15 Minutes", "15 minutes"]
    }
    for to_value, from_values in mass_edit_map.items():
        survey_df[col_time_to_sleep] = survey_df[col_time_to_sleep].replace(from_values, to_value)

    # 2. Remove noise words
    patterns_to_remove = ["mins", "min", "utes", "Min", "Hour"]
    for p in patterns_to_remove:
        survey_df[col_time_to_sleep] = survey_df[col_time_to_sleep].astype(str).str.replace(p, "", regex=False)

    # 3. Drop unwanted columns
    columns_to_remove = [
        "b. Wake up in the middle of the night or early morning",
        "a. Cannot get to sleep within 30 minutes",
        "c. Have to get up to use the bathroom",
        "d. Cannot breathe comfortably",
        "e. Cough or snore loudly",
        "f. Feel too cold",
        "During the past month, how often have you taken medicine (prescribed or over the counter) to help you sleep?",
        "During the past month, how often have you had trouble staying awake while driving, eating meals, or engaging in social activity?",
        "Other reason(s), please describe, including how often you have had trouble sleeping because of this reason(s):",
        "j. Other reason(s)",
        "i. Have pain",
        "h. Have bad dreams",
        "g. Feel too hot",
        "During the past month, how much of a problem has it been for you to keep up enthusiasm to get things done?"
    ]
    survey_df.drop(columns=[c for c in columns_to_remove if c in survey_df.columns], inplace=True)

    # 4. Clean hour sleep column
    if col_hour_sleep in survey_df.columns:
        survey_df[col_hour_sleep] = (
            survey_df[col_hour_sleep]
            .astype(str)
            .str.replace("hours", "", regex=False)
            .str.replace("hrs", "", regex=False)
        )

    # 5. Sleep quality mapping
    if col_quality in survey_df.columns:
        survey_df[col_quality] = survey_df[col_quality].replace({
            "Very good": 4,
            "Fairly good": 3,
            "Fairly bad": 2,
            "Very bad": 1
        })
        survey_df.rename(columns={col_quality: "sleep quality score"}, inplace=True)

    # 6. Rename columns
    survey_df.rename(columns={
        col_hour_sleep: "hour sleep",
        col_time_to_sleep: "time to fall sleep",
        "During the past month, what time have you usually gone to bed at night?": "bedtime",
        "When have you usually gotten up in the morning?": "wake up time"
    }, inplace=True)

    # 7. Convert numeric columns
    survey_df["hour sleep"] = pd.to_numeric(survey_df["hour sleep"], errors="coerce")
    survey_df["time to fall sleep"] = pd.to_numeric(survey_df["time to fall sleep"], errors="coerce")

    survey_df.to_csv(os.path.join(output_dir, "survey_data_cleaned.csv"), index=False)
    print(f"Survey cleaned data saved to {output_dir}/survey_data_cleaned.csv")
else:
    print("Survey file not found, skipping...")

# --- STEP 5: IMPORT GRADES ---
if os.path.exists(grades_file):
    grades_df = pd.read_csv(grades_file)
    grades_df.to_csv(os.path.join(output_dir, "grades_cleaned.csv"), index=False)
    print(f"Grades data saved to {output_dir}/grades_cleaned.csv")
else:
    print("Grades file not found, skipping...")

print("Pipeline complete! All processed data saved to 'processed' folder.")
