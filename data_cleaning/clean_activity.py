import pandas as pd
import os

input_folder = r"C:\Users\AnnieMo\Downloads\CS598_Dataset\dataset\sensing\activity"
output_file = r"C:\Users\AnnieMo\Downloads\activity_summary_all.csv"

summary_list = []

# All activity file names
files = [f for f in os.listdir(input_folder) if f.startswith("activity_u") and f.endswith(".csv")]
print("Found", len(files), "files")

for filename in files:
    uid = filename.replace("activity_", "").replace(".csv", "")
    file_path = os.path.join(input_folder, filename)

    print("Processing:", filename)

    # count dictionary for this user
    counts = {}

    # Stream through file in chunks to avoid memory blowup
    for chunk in pd.read_csv(
        file_path,
        chunksize=200000,
        dtype={" activity inference": "int64"},
    ):
        # Remove stationary rows
        chunk = chunk[chunk[" activity inference"] != 0]

        # Nothing to count in this chunk
        if chunk.empty:
            continue

        # Count frequencies
        value_counts = chunk[" activity inference"].value_counts()

        # Merge into this user's count dict
        for activity_id, count in value_counts.items():
            counts[activity_id] = counts.get(activity_id, 0) + count

    # Skip users with no non-zero data
    if not counts:
        print("No non-zero activities for", uid)
        continue

    # Build dataframe for this UID
    df_counts = pd.DataFrame({
        "uid": [uid] * len(counts),
        "activity_id": list(counts.keys()),
        "activity_count": list(counts.values())
    })

    summary_list.append(df_counts)

# Combine all users
summary_all = pd.concat(summary_list, ignore_index=True)

# Save the summary CSV
summary_all.to_csv(output_file, index=False)

print("✅ Done! Summary saved to:", output_file)
