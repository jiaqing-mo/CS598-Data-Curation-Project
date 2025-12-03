# curate/classes.py

import os
import json
import pandas as pd
from configs.config import BASE_PATH, PROCESSED_DATA_PATH, PROVENANCE_PATH


def process_classes():
    # ensure output dirs exist
    os.makedirs(PROCESSED_DATA_PATH, exist_ok=True)
    os.makedirs(PROVENANCE_PATH, exist_ok=True)

    table_name = "class"
    source_path = f"{BASE_PATH}/education/{table_name}.csv"
    processed_path = f"{PROCESSED_DATA_PATH}/{table_name}.csv"
    provenance_path = f"{PROVENANCE_PATH}/{table_name}_provenance.json"

    # --- load grades to filter valid uids ---
    grades_path = f"{PROCESSED_DATA_PATH}/grades.csv"
    grades_df = pd.read_csv(grades_path)
    grades_df["uid"] = grades_df["uid"].astype(str).str.strip()
    valid_uids = set(grades_df["uid"])

    # --- parse non-standard class.csv ---
    rows = []
    with open(source_path, "r") as f:
        for line in f:
            line = line.strip()
            if not line:
                continue

            parts = [p.strip() for p in line.split(",") if p.strip() != ""]
            if not parts:
                continue

            uid = parts[0]
            courses = parts[1:]

            # Option A: skip students with no courses
            if not courses:
                continue

            for idx, course in enumerate(courses, start=1):
                rows.append(
                    {
                        "uid": uid,
                        "course_index": idx,
                        "course_raw": course,
                    }
                )

    if rows:
        class_df = pd.DataFrame(rows)
    else:
        class_df = pd.DataFrame(columns=["uid", "course_index", "course_raw"])

    # basic cleaning
    if not class_df.empty:
        class_df["uid"] = class_df["uid"].astype(str).str.strip()
        class_df["course_raw"] = class_df["course_raw"].astype(str).str.strip()

    row_count_before_filter = len(class_df)
    unique_uids_before_filter = (
        class_df["uid"].nunique() if row_count_before_filter > 0 else 0
    )

    # --- filter to uids present in grades ---
    if not class_df.empty:
        class_df = class_df[class_df["uid"].isin(valid_uids)].copy()

    row_count_after_filter = len(class_df)
    unique_uids_after_filter = (
        class_df["uid"].nunique() if row_count_after_filter > 0 else 0
    )

    # save processed table
    class_df.to_csv(processed_path, index=False)

    # provenance record
    provenance_record = {
        "table": table_name,
        "source_file": source_path,
        "processed_file": processed_path,
        "depends_on": {
            "grades_table": grades_path,
        },
        "operations": [
            "read raw non-standard CSV file line-by-line",
            "for each line: split on commas, first token is uid, remaining tokens are course codes",
            "create one row per (uid, course) pair with course_index",
            "strip whitespace from uid and course_raw",
            "filter rows to keep only uids present in processed grades table",
        ],
        "stats": {
            "row_count_before_filter": int(row_count_before_filter),
            "row_count_after_filter": int(row_count_after_filter),
            "unique_uids_before_filter": int(unique_uids_before_filter),
            "unique_uids_after_filter": int(unique_uids_after_filter),
        },
    }

    with open(provenance_path, "w") as f:
        json.dump(provenance_record, f, indent=2)

    return class_df


if __name__ == "__main__":
    process_classes()