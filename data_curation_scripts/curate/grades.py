import os
import json
import pandas as pd
from configs.config import BASE_PATH, PROCESSED_DATA_PATH, PROVENANCE_PATH


def process_grades():
    # ensure output dirs exist
    os.makedirs(PROCESSED_DATA_PATH, exist_ok=True)
    os.makedirs(PROVENANCE_PATH, exist_ok=True)

    table_name = "grades"
    source_path = f"{BASE_PATH}/education/{table_name}.csv"
    processed_path = f"{PROCESSED_DATA_PATH}/{table_name}.csv"
    provenance_path = f"{PROVENANCE_PATH}/{table_name}_provenance.json"

    grades_df = pd.read_csv(source_path)
    grades_df.columns = grades_df.columns.str.strip()
    grades_df["uid"] = grades_df["uid"].str.strip()

    print(grades_df.shape)
    print(grades_df.describe())

    # stats before validation
    row_count_before = len(grades_df)
    null_rows_before = grades_df.isna().any(axis=1).sum()

    # ensure no null values go in as it's the most important table:
    grades_df = grades_df.dropna()

    # GPA validation (no GPA < 0); just validation, do not modify data
    min_gpa = None
    max_gpa = None
    invalid_gpa_rows = 0
    if "gpa" in grades_df.columns:
        min_gpa = grades_df["gpa"].min()
        max_gpa = grades_df["gpa"].max()
        invalid_gpa_rows = int((grades_df["gpa"] < 0).sum())
        assert invalid_gpa_rows == 0, "Found GPA < 0 in grades table after dropna()"

    row_count_after = len(grades_df)
    uid_nunique = grades_df["uid"].nunique()

    print(grades_df.shape, uid_nunique)

    # save to processed_data
    grades_df.to_csv(processed_path, index=False)

    # provenance record for grades table
    provenance_record = {
        "table": table_name,
        "source_file": source_path,
        "processed_file": processed_path,
        "operations": [
            "read CSV",
            "strip whitespace from column names",
            "strip whitespace from 'uid'",
            "drop rows with any null values",
            "validate GPA column has no values < 0 (if present)",
        ],
        "stats": {
            "row_count_before": row_count_before,
            "row_count_after": row_count_after,
            "null_rows_before": int(null_rows_before),
            "uid_nunique_after": int(uid_nunique),
            "min_gpa_after": float(min_gpa) if min_gpa is not None else None,
            "max_gpa_after": float(max_gpa) if max_gpa is not None else None,
            "invalid_gpa_rows_after": invalid_gpa_rows,
        },
    }

    with open(provenance_path, "w") as f:
        json.dump(provenance_record, f, indent=2)

    return grades_df


if __name__ == "__main__":
    process_grades()