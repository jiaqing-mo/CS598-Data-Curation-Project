# curate/deadlines.py

import os
import json
import pandas as pd
from configs.config import BASE_PATH, PROCESSED_DATA_PATH, PROVENANCE_PATH


def process_deadlines():
    # ensure output dirs exist
    os.makedirs(PROCESSED_DATA_PATH, exist_ok=True)
    os.makedirs(PROVENANCE_PATH, exist_ok=True)

    table_name = "deadlines"
    source_path = f"{BASE_PATH}/education/{table_name}.csv"
    processed_path = f"{PROCESSED_DATA_PATH}/{table_name}.csv"
    provenance_path = f"{PROVENANCE_PATH}/{table_name}_provenance.json"

    # --- load source deadlines table (wide format) ---
    wide_df = pd.read_csv(source_path)
    wide_df.columns = wide_df.columns.str.strip()

    if "uid" not in wide_df.columns:
        raise ValueError("Expected 'uid' column in deadlines table")

    wide_df["uid"] = wide_df["uid"].astype(str).str.strip()

    # identify date columns (everything except uid)
    date_cols = [c for c in wide_df.columns if c != "uid"]

    row_count_wide = len(wide_df)
    num_date_cols = len(date_cols)

    # --- melt to long format: one row per (uid, date) ---
    long_df = wide_df.melt(
        id_vars=["uid"],
        value_vars=date_cols,
        var_name="date_str",
        value_name="num_deadlines",
    )

    row_count_long_before_clean = len(long_df)

    # coerce counts to numeric
    long_df["num_deadlines"] = pd.to_numeric(
        long_df["num_deadlines"], errors="coerce"
    )

    # parse dates
    long_df["date"] = pd.to_datetime(
        long_df["date_str"], format="%Y-%m-%d", errors="coerce"
    )

    # basic cleaning: drop rows with invalid date or missing count
    long_df = long_df.dropna(subset=["date", "num_deadlines"])

    # keep only rows with at least one deadline
    long_df = long_df[long_df["num_deadlines"] > 0].copy()

    # standardize columns
    long_df["uid"] = long_df["uid"].astype(str).str.strip()
    long_df["num_deadlines"] = long_df["num_deadlines"].astype(int)

    # --- filter to uids present in grades ---
    grades_path = f"{PROCESSED_DATA_PATH}/grades.csv"
    grades_df = pd.read_csv(grades_path)
    grades_df["uid"] = grades_df["uid"].astype(str).str.strip()
    valid_uids = set(grades_df["uid"])

    unique_uids_before_filter = long_df["uid"].nunique()

    long_df = long_df[long_df["uid"].isin(valid_uids)].copy()

    row_count_after_filter = len(long_df)
    unique_uids_after_filter = (
        long_df["uid"].nunique() if row_count_after_filter > 0 else 0
    )

    # final column order
    long_df = long_df[["uid", "date", "num_deadlines"]].sort_values(
        ["uid", "date"]
    )

    # save processed deadlines table
    long_df.to_csv(processed_path, index=False)

    # provenance record
    provenance_record = {
        "table": table_name,
        "source_file": source_path,
        "processed_file": processed_path,
        "depends_on": {
            "grades_table": grades_path,
        },
        "operations": [
            "read wide-format deadlines CSV",
            "strip whitespace from column names and 'uid'",
            "identify all date columns (all columns except 'uid')",
            "melt wide table into long format with columns [uid, date_str, num_deadlines]",
            "coerce num_deadlines to numeric (errors='coerce')",
            "parse date_str into datetime 'date' (format '%Y-%m-%d')",
            "drop rows with invalid date or missing num_deadlines",
            "keep only rows with num_deadlines > 0 (days that actually have deadlines)",
            "standardize 'uid' formatting and num_deadlines as int",
            "filter rows to keep only uids present in processed grades table",
        ],
        "stats": {
            "row_count_wide": int(row_count_wide),
            "num_date_columns": int(num_date_cols),
            "row_count_long_before_clean": int(row_count_long_before_clean),
            "row_count_after_filter": int(row_count_after_filter),
            "unique_uids_before_filter": int(unique_uids_before_filter),
            "unique_uids_after_filter": int(unique_uids_after_filter),
        },
    }

    with open(provenance_path, "w") as f:
        json.dump(provenance_record, f, indent=2)

    return long_df


if __name__ == "__main__":
    process_deadlines()