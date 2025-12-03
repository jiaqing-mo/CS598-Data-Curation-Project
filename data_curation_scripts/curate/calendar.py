import os
import json
from pathlib import Path

import pandas as pd
from configs.config import BASE_PATH, PROCESSED_DATA_PATH, PROVENANCE_PATH

def normalize_dates(date_series):
    # Try m/d/y first
    dates = pd.to_datetime(date_series, format='%m/%d/%Y', errors='coerce')
    
    mask = dates.isna()
    dates[mask] = pd.to_datetime(date_series[mask], format='%Y/%m/%d', errors='coerce')
    
    return dates

def process_calendar():
    # ensure output dirs exist
    os.makedirs(PROCESSED_DATA_PATH, exist_ok=True)
    os.makedirs(PROVENANCE_PATH, exist_ok=True)

    table_name = "calendar"
    source_folder = f"{BASE_PATH}/calendar/"
    processed_path = f"{PROCESSED_DATA_PATH}/{table_name}.csv"
    provenance_path = f"{PROVENANCE_PATH}/{table_name}_provenance.json"

    # load processed grades to filter valid uids
    grades_path = f"{PROCESSED_DATA_PATH}/grades.csv"
    grades_df = pd.read_csv(grades_path)
    grades_df["uid"] = grades_df["uid"].astype(str).str.strip()
    valid_uids = set(grades_df["uid"])

    # --- build event-level calendar table by concatenating all CSVs ---
    all_dfs = []
    file_count = 0

    for fpath in Path(source_folder).rglob("*.csv"):
        file_count += 1
        df = pd.read_csv(fpath)

        # normalize DATE if present
        if "DATE" in df.columns:
            df["DATE"] = normalize_dates(df["DATE"])

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
        calendar_df = pd.concat(all_dfs, ignore_index=True)
    else:
        calendar_df = pd.DataFrame()

    # basic cleaning
    if not calendar_df.empty:
        calendar_df.columns = calendar_df.columns.str.strip()
        calendar_df["uid"] = calendar_df["uid"].astype(str).str.strip()

    row_count_before_filter = len(calendar_df)
    unique_uids_before = (
        calendar_df["uid"].nunique() if row_count_before_filter > 0 else 0
    )

    # --- filter to uids that exist in grades table ---
    if not calendar_df.empty:
        calendar_df = calendar_df[calendar_df["uid"].isin(valid_uids)].copy()

    row_count_after_filter = len(calendar_df)
    unique_uids_after = (
        calendar_df["uid"].nunique() if row_count_after_filter > 0 else 0
    )

    # save processed calendar events
    calendar_df.to_csv(processed_path, index=False)

    # provenance record for calendar table
    provenance_record = {
        "table": table_name,
        "source_folder": source_folder,
        "processed_file": processed_path,
        "depends_on": {
            "grades_table": grades_path,
        },
        "operations": [
            "discover all calendar CSV files recursively under BASE_PATH/calendar/",
            "for each file: read CSV",
            "for each file: normalize DATE column using normalize_dates() (if present)",
            "for each file: infer uid from filename suffix and add as 'uid' column",
            "concatenate all calendar CSVs into a single event-level table",
            "standardize column names (strip whitespace) and 'uid' formatting",
            "filter rows to keep only uids present in processed grades table",
        ],
        "stats": {
            "file_count": int(file_count),
            "row_count_before_filter": int(row_count_before_filter),
            "row_count_after_filter": int(row_count_after_filter),
            "unique_uids_before_filter": int(unique_uids_before),
            "unique_uids_after_filter": int(unique_uids_after),
        },
    }

    with open(provenance_path, "w") as f:
        json.dump(provenance_record, f, indent=2)

    return calendar_df


if __name__ == "__main__":
    process_calendar()