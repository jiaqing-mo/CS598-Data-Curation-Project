import os
import json
from pathlib import Path

import pandas as pd
from configs.config import BASE_PATH, PROCESSED_DATA_PATH, PROVENANCE_PATH


def process_dinning():
    # ensure output dirs exist
    os.makedirs(PROCESSED_DATA_PATH, exist_ok=True)
    os.makedirs(PROVENANCE_PATH, exist_ok=True)

    table_name = "dinning"
    source_folder = f"{BASE_PATH}/dinning/"
    processed_path = f"{PROCESSED_DATA_PATH}/{table_name}.csv"
    provenance_path = f"{PROVENANCE_PATH}/{table_name}_provenance.json"

    # load processed grades to filter valid uids
    grades_path = f"{PROCESSED_DATA_PATH}/grades.csv"
    grades_df = pd.read_csv(grades_path)
    grades_df["uid"] = grades_df["uid"].astype(str).str.strip()
    valid_uids = set(grades_df["uid"])

    all_dfs = []
    file_count = 0

    # --- build event-level dinning table by concatenating all TXT files ---
    for fpath in Path(source_folder).rglob("*.txt"):
        file_count += 1

        # original schema: DATE, RESTAURANT, TYPE
        df = pd.read_csv(fpath, names=["DATE", "RESTAURANT", "TYPE"])

        # parse DATE into a datetime column
        df["DATE_TIME"] = pd.to_datetime(df["DATE"])

        # infer uid from filename suffix
        uid = (
            str(fpath)
            .split("/")[-1]
            .split("_")[-1]
            .replace(".txt", "")
            .strip()
        )
        df["uid"] = uid

        all_dfs.append(df)

    if all_dfs:
        dinning_df = pd.concat(all_dfs, ignore_index=True)
    else:
        dinning_df = pd.DataFrame()

    # basic cleaning
    if not dinning_df.empty:
        dinning_df.columns = dinning_df.columns.str.strip()
        dinning_df["uid"] = dinning_df["uid"].astype(str).str.strip()

    row_count_before_filter = len(dinning_df)
    unique_uids_before = (
        dinning_df["uid"].nunique() if row_count_before_filter > 0 else 0
    )

    # --- filter to uids that exist in grades table ---
    if not dinning_df.empty:
        dinning_df = dinning_df[dinning_df["uid"].isin(valid_uids)].copy()

    row_count_after_filter = len(dinning_df)
    unique_uids_after = (
        dinning_df["uid"].nunique() if row_count_after_filter > 0 else 0
    )

    # save processed dinning events
    dinning_df.to_csv(processed_path, index=False)

    # provenance record for dinning table
    provenance_record = {
        "table": table_name,
        "source_folder": source_folder,
        "processed_file": processed_path,
        "depends_on": {
            "grades_table": grades_path,
        },
        "operations": [
            "discover all TXT files recursively under BASE_PATH/dinning/",
            "for each file: read as CSV with columns [DATE, RESTAURANT, TYPE]",
            "for each file: parse DATE into DATE_TIME (datetime)",
            "for each file: infer uid from filename suffix and add as 'uid' column",
            "concatenate all dinning TXT files into a single event-level table",
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

    return dinning_df


if __name__ == "__main__":
    process_dinning()