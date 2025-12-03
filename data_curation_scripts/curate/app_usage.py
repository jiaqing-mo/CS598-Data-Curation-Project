import os
import json
from pathlib import Path

import pandas as pd
from configs.config import BASE_PATH, PROCESSED_DATA_PATH, PROVENANCE_PATH


def process_app_usage():
    # ensure output dirs exist
    os.makedirs(PROCESSED_DATA_PATH, exist_ok=True)
    os.makedirs(PROVENANCE_PATH, exist_ok=True)

    table_name = "app_usage"
    source_folder = f"{BASE_PATH}/app_usage/"
    processed_path = f"{PROCESSED_DATA_PATH}/{table_name}.csv"
    provenance_path = f"{PROVENANCE_PATH}/{table_name}_provenance.json"

    # load processed grades to filter valid uids
    grades_path = f"{PROCESSED_DATA_PATH}/grades.csv"
    grades_df = pd.read_csv(grades_path)
    grades_df["uid"] = grades_df["uid"].astype(str).str.strip()
    valid_uids = set(grades_df["uid"])

    all_dfs = []
    file_count = 0

    # --- build event-level app_usage table by concatenating all CSV files ---
    for fpath in Path(source_folder).rglob("*.csv"):
        file_count += 1

        df = pd.read_csv(fpath)

        # normalize timestamp if present (Unix seconds → datetime)
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
        app_usage_df = pd.concat(all_dfs, ignore_index=True)
    else:
        app_usage_df = pd.DataFrame()

    # basic cleaning
    if not app_usage_df.empty:
        app_usage_df.columns = app_usage_df.columns.str.strip()
        app_usage_df["uid"] = app_usage_df["uid"].astype(str).str.strip()

    row_count_before_filter = len(app_usage_df)
    unique_uids_before = (
        app_usage_df["uid"].nunique() if row_count_before_filter > 0 else 0
    )

    invalid_timestamps = 0
    if not app_usage_df.empty and "timestamp" in app_usage_df.columns:
        invalid_timestamps = int(app_usage_df["timestamp"].isna().sum())

    # --- filter to uids that exist in grades table ---
    if not app_usage_df.empty:
        app_usage_df = app_usage_df[app_usage_df["uid"].isin(valid_uids)].copy()

    row_count_after_filter = len(app_usage_df)
    unique_uids_after = (
        app_usage_df["uid"].nunique() if row_count_after_filter > 0 else 0
    )

    # save processed app usage events
    app_usage_df.to_csv(processed_path, index=False)

    # provenance record for app_usage table
    provenance_record = {
        "table": table_name,
        "source_folder": source_folder,
        "processed_file": processed_path,
        "depends_on": {
            "grades_table": grades_path,
        },
        "operations": [
            "discover all app usage CSV files recursively under BASE_PATH/app_usage/",
            "for each file: read CSV",
            "for each file: normalize 'timestamp' from Unix seconds to datetime (if present)",
            "for each file: infer uid from filename suffix and add as 'uid' column",
            "concatenate all app usage CSVs into a single event-level table",
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

    return app_usage_df


if __name__ == "__main__":
    process_app_usage()