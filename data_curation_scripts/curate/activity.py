# curate/activity.py

import os
import json
from pathlib import Path

import pandas as pd
from configs.config import BASE_PATH, PROCESSED_DATA_PATH, PROVENANCE_PATH


def process_activity():
    # ensure output dirs exist
    os.makedirs(PROCESSED_DATA_PATH, exist_ok=True)
    os.makedirs(PROVENANCE_PATH, exist_ok=True)

    table_name = "activity"
    source_folder = f"{BASE_PATH}/sensing/activity/"
    processed_path = f"{PROCESSED_DATA_PATH}/{table_name}.csv"
    provenance_path = f"{PROVENANCE_PATH}/{table_name}_provenance.json"

    # --- load processed grades to filter valid uids ---
    grades_path = f"{PROCESSED_DATA_PATH}/grades.csv"
    grades_df = pd.read_csv(grades_path)
    grades_df["uid"] = grades_df["uid"].astype(str).str.strip()
    valid_uids = set(grades_df["uid"])

    all_dfs = []
    file_count = 0

    # --- build event-level activity table by concatenating all CSV files ---
    for fpath in Path(source_folder).rglob("*.csv"):
        file_count += 1

        df = pd.read_csv(fpath)

        # standardize column names
        df.columns = df.columns.str.strip()

        # rename "activity inference" -> "activity_inference" if present
        if "activity inference" in df.columns:
            df = df.rename(columns={"activity inference": "activity_inference"})

        # normalize timestamp (Unix seconds -> datetime), if present
        if "timestamp" in df.columns:
            df["timestamp"] = pd.to_datetime(
                df["timestamp"], unit="s", errors="coerce"
            )

        # infer uid from filename suffix
        uid = (
            str(fpath)
            .split("/")[-1]
            .split("_")[-1]
            .replace(".csv", "")
            .strip()
        )
        df["uid"] = uid

        all_dfs.append(df)

    if all_dfs:
        activity_df = pd.concat(all_dfs, ignore_index=True)
    else:
        activity_df = pd.DataFrame()

    # basic cleaning
    if not activity_df.empty:
        activity_df.columns = activity_df.columns.str.strip()
        activity_df["uid"] = activity_df["uid"].astype(str).str.strip()

    row_count_before_filter = len(activity_df)
    unique_uids_before = (
        activity_df["uid"].nunique() if row_count_before_filter > 0 else 0
    )

    invalid_timestamps = 0
    if not activity_df.empty and "timestamp" in activity_df.columns:
        invalid_timestamps = int(activity_df["timestamp"].isna().sum())

    # --- filter to uids that exist in grades table ---
    if not activity_df.empty:
        activity_df = activity_df[activity_df["uid"].isin(valid_uids)].copy()

    row_count_after_filter = len(activity_df)
    unique_uids_after = (
        activity_df["uid"].nunique() if row_count_after_filter > 0 else 0
    )

    # save processed activity events
    activity_df.to_csv(processed_path, index=False)

    # provenance record for activity table
    provenance_record = {
        "table": table_name,
        "source_folder": source_folder,
        "processed_file": processed_path,
        "depends_on": {
            "grades_table": grades_path,
        },
        "operations": [
            "discover all activity CSV files recursively under BASE_PATH/sensing/activity/",
            "for each file: read CSV",
            "strip whitespace from column names",
            "rename 'activity inference' to 'activity_inference' (if present)",
            "normalize 'timestamp' from Unix seconds to datetime (if present)",
            "infer uid from filename suffix and add as 'uid' column",
            "concatenate all activity CSVs into a single event-level table",
            "standardize 'uid' formatting",
            "filter rows to keep only uids present in processed grades table",
        ],
        "stats": {
            "file_count": int(file_count),
            "row_count_before_filter": int(row_count_before_filter),
            "row_count_after_filter": int(row_count_after_filter),
            "unique_uids_before_filter": int(unique_uids_before),
            "unique_uids_after_filter": int(unique_uids_after),
            "invalid_timestamps_after_normalization": int(invalid_timestamps),
        },
    }

    with open(provenance_path, "w") as f:
        json.dump(provenance_record, f, indent=2)

    return activity_df


if __name__ == "__main__":
    process_activity()