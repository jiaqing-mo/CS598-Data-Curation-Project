import os
import json
from pathlib import Path

import pandas as pd
from configs.config import BASE_PATH, PROCESSED_DATA_PATH, PROVENANCE_PATH


def process_call_log():
    # ensure output dirs exist
    os.makedirs(PROCESSED_DATA_PATH, exist_ok=True)
    os.makedirs(PROVENANCE_PATH, exist_ok=True)

    table_name = "call_log"
    source_folder = f"{BASE_PATH}/call_log/"
    processed_path = f"{PROCESSED_DATA_PATH}/{table_name}.csv"
    provenance_path = f"{PROVENANCE_PATH}/{table_name}_provenance.json"

    # load processed grades to filter valid uids
    grades_path = f"{PROCESSED_DATA_PATH}/grades.csv"
    grades_df = pd.read_csv(grades_path)
    grades_df["uid"] = grades_df["uid"].astype(str).str.strip()
    valid_uids = set(grades_df["uid"])

    all_dfs = []
    file_count = 0

    # --- build event-level call log table by concatenating all CSV files ---
    for fpath in Path(source_folder).rglob("*.csv"):
        file_count += 1

        df = pd.read_csv(fpath)

        # normalize timestamp if present (Unix seconds → datetime)
        if "timestamp" in df.columns:
            df["timestamp"] = pd.to_datetime(
                df["timestamp"], unit="s", errors="coerce"
            )

        # (optional) normalize CALLS_date if you want it too
        if "CALLS_date" in df.columns:
            df["CALLS_date"] = pd.to_datetime(
                df["CALLS_date"], unit="ms", errors="coerce"
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
        call_log_df = pd.concat(all_dfs, ignore_index=True)
    else:
        call_log_df = pd.DataFrame()

    # basic cleaning
    if not call_log_df.empty:
        call_log_df.columns = call_log_df.columns.str.strip()
        call_log_df["uid"] = call_log_df["uid"].astype(str).str.strip()

    row_count_before_filter = len(call_log_df)
    unique_uids_before = (
        call_log_df["uid"].nunique() if row_count_before_filter > 0 else 0
    )

    invalid_timestamps = 0
    if not call_log_df.empty and "timestamp" in call_log_df.columns:
        invalid_timestamps = int(call_log_df["timestamp"].isna().sum())

    # --- filter to uids that exist in grades table ---
    if not call_log_df.empty:
        call_log_df = call_log_df[call_log_df["uid"].isin(valid_uids)].copy()

    row_count_after_filter = len(call_log_df)
    unique_uids_after = (
        call_log_df["uid"].nunique() if row_count_after_filter > 0 else 0
    )

    # save processed call log events
    call_log_df.to_csv(processed_path, index=False)

    # provenance record for call_log table
    provenance_record = {
        "table": table_name,
        "source_folder": source_folder,
        "processed_file": processed_path,
        "depends_on": {
            "grades_table": grades_path,
        },
        "operations": [
            "discover all call log CSV files recursively under BASE_PATH/call_log/",
            "for each file: read CSV",
            "for each file: normalize 'timestamp' from Unix seconds to datetime (if present)",
            "optionally normalize 'CALLS_date' from ms to datetime (if present)",
            "for each file: infer uid from filename suffix and add as 'uid' column",
            "concatenate all call log CSVs into a single event-level table",
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

    return call_log_df


if __name__ == "__main__":
    process_call_log()