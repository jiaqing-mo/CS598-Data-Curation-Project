# curate/piazza.py

import os
import json
import pandas as pd
from configs.config import BASE_PATH, PROCESSED_DATA_PATH, PROVENANCE_PATH


def process_piazza():
    # ensure output dirs exist
    os.makedirs(PROCESSED_DATA_PATH, exist_ok=True)
    os.makedirs(PROVENANCE_PATH, exist_ok=True)

    table_name = "piazza"
    source_path = f"{BASE_PATH}/education/{table_name}.csv"
    processed_path = f"{PROCESSED_DATA_PATH}/{table_name}.csv"
    provenance_path = f"{PROVENANCE_PATH}/{table_name}_provenance.json"

    # --- load source piazza table ---
    piazza_df = pd.read_csv(source_path)

    # standardize column names
    piazza_df.columns = piazza_df.columns.str.strip()
    if "uid" not in piazza_df.columns:
        raise ValueError("Expected 'uid' column in piazza table")

    piazza_df["uid"] = piazza_df["uid"].astype(str).str.strip()

    # columns we expect to be numeric
    numeric_cols = [
        "days online",
        "views",
        "contributions",
        "questions",
        "notes",
        "answers",
    ]

    # keep only numeric columns that actually exist (defensive)
    numeric_cols = [c for c in numeric_cols if c in piazza_df.columns]

    row_count_before = len(piazza_df)
    null_rows_before = int(piazza_df.isna().any(axis=1).sum())

    # --- validate / enforce numeric dtypes ---
    for col in numeric_cols:
        piazza_df[col] = pd.to_numeric(piazza_df[col], errors="coerce")

    # drop any rows with nulls (after coercion)
    piazza_df = piazza_df.dropna()
    row_count_after_dropna = len(piazza_df)
    null_rows_after = int(piazza_df.isna().any(axis=1).sum())

    # --- merge/filter with grades table (keep only uids in grades) ---
    grades_path = f"{PROCESSED_DATA_PATH}/grades.csv"
    grades_df = pd.read_csv(grades_path)
    grades_df["uid"] = grades_df["uid"].astype(str).str.strip()

    unique_uids_before_merge = piazza_df["uid"].nunique()

    merged_df = piazza_df.merge(
        grades_df[["uid"]].drop_duplicates(),
        on="uid",
        how="inner",
    )

    row_count_after_merge = len(merged_df)
    unique_uids_after_merge = merged_df["uid"].nunique()

    # save processed piazza table
    merged_df.to_csv(processed_path, index=False)

    # provenance record
    provenance_record = {
        "table": table_name,
        "source_file": source_path,
        "processed_file": processed_path,
        "depends_on": {
            "grades_table": grades_path,
        },
        "operations": [
            "read CSV",
            "strip whitespace from column names",
            "standardize 'uid' formatting (string, stripped)",
            "coerce piazza metric columns to numeric (errors='coerce')",
            "drop rows with any null values after type coercion",
            "inner-join with processed grades table on 'uid' to keep only valid students",
        ],
        "stats": {
            "row_count_before": int(row_count_before),
            "null_rows_before": null_rows_before,
            "row_count_after_dropna": int(row_count_after_dropna),
            "null_rows_after_dropna": null_rows_after,
            "unique_uids_before_merge": int(unique_uids_before_merge),
            "row_count_after_merge": int(row_count_after_merge),
            "unique_uids_after_merge": int(unique_uids_after_merge),
        },
    }

    with open(provenance_path, "w") as f:
        json.dump(provenance_record, f, indent=2)

    return merged_df


if __name__ == "__main__":
    process_piazza()