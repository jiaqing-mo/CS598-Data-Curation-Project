import os
import json
from pathlib import Path

import pandas as pd
from configs.config import BASE_PATH, PROCESSED_DATA_PATH, PROVENANCE_PATH


def process_sms():
    # ensure output dirs exist
    os.makedirs(PROCESSED_DATA_PATH, exist_ok=True)
    os.makedirs(PROVENANCE_PATH, exist_ok=True)

    table_name = "sms"
    source_folder = f"{BASE_PATH}/sms/"
    processed_path = f"{PROCESSED_DATA_PATH}/{table_name}.csv"
    provenance_path = f"{PROVENANCE_PATH}/{table_name}_provenance.json"

    # load processed grades to filter valid uids
    grades_path = f"{PROCESSED_DATA_PATH}/grades.csv"
    grades_df = pd.read_csv(grades_path)
    grades_df["uid"] = grades_df["uid"].astype(str).str.strip()
    valid_uids = set(grades_df["uid"])

    all_dfs = []
    file_count = 0

    # --- build event-level SMS table by concatenating all CSV files ---
    for fpath in Path(source_folder).rglob("*.csv"):
        file_count += 1

        df = pd.read_csv(fpath)

        # normalize timestamp if present (StudentLife-style Unix seconds)
        if "timestamp" in df.columns:
            df["timestamp"] = pd.to_datetime(
                df["timestamp"], unit="s", errors="coerce"
            )

        # infer uid from filename suffix (same pattern as calendar/dinning)
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
        sms_df = pd.concat(all_dfs, ignore_index=True)
    else:
        sms_df = pd.DataFrame()

    # basic cleaning
    if not sms_df.empty:
        sms_df.columns = sms_df.columns.str.strip()
        sms_df["uid"] = sms_df["uid"].astype(str).str.strip()

    row_count_before_filter = len(sms_df)
    unique_uids_before = (
        sms_df["uid"].nunique() if row_count_before_filter > 0 else 0
    )

    # we’re not dropping nulls/etc., just normalizing + filtering by uid
    invalid_timestamps = 0
    if not sms_df.empty and "timestamp" in sms_df.columns:
        invalid_timestamps = int(sms_df["timestamp"].isna().sum())

    # --- filter to uids that exist in grades table ---
    if not sms_df.empty:
        sms_df = sms_df[sms_df["uid"].isin(valid_uids)].copy()

    row_count_after_filter = len(sms_df)
    unique_uids_after = (
        sms_df["uid"].nunique() if row_count_after_filter > 0 else 0
    )

    # save processed SMS events
    sms_df.to_csv(processed_path, index=False)

    # provenance record for sms table
    provenance_record = {
        "table": table_name,
        "source_folder": source_folder,
        "processed_file": processed_path,
        "depends_on": {
            "grades_table": grades_path,
        },
        "operations": [
            "discover all SMS CSV files recursively under BASE_PATH/sms/",
            "for each file: read CSV",
            "for each file: normalize 'timestamp' from Unix seconds to datetime (if present)",
            "for each file: infer uid from filename suffix and add as 'uid' column",
            "concatenate all SMS CSVs into a single event-level table",
            "standardize column names (strip whitespace) and 'uid' formatting",
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

    return sms_df


if __name__ == "__main__":
    process_sms()