input_file = 'class_raw.txt'   # Your raw data file (with lines like you posted)
output_file = 'class_normalized.csv'

with open(input_file, 'r') as f_in, open(output_file, 'w') as f_out:
    f_out.write('uid,course\n')  # write header
    for line in f_in:
        parts = line.strip().split(',')
        uid = parts[0]
        courses = parts[1:]
        for course in courses:
            course = course.strip()
            if course:  # skip empty
                f_out.write(f'{uid},"{course}"\n')
