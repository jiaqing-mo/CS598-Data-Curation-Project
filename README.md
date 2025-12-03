This is the code base of the CS 598 Data Curation Course Project

**Team members:**

- Hasham Ul Haq (huhaq2@illinois.edu)
- Jiaqing Mo jiaqing7@illinois.edu
- Usman Asghar (uasgh2@illinois.edu)


**Repo structure:**

This repo contains the codebase to process and clean the base dataset to generate a more refined version, with complete provenance and data modeling.
- `setup_inspection` contains the schema details.
- `metadata` contains supplementary information about the dataset.
- `data_cleaning` contains the full code base with provenance and output files.

**Dataset:**

The base dataset can be obtained from the university of dartmouth's website: https://studentlife.cs.dartmouth.edu/dataset.html

Please obtain it directly from their website.

**References:**
```
@inproceedings{10.1145/2632048.2632054,
author = {Wang, Rui and Chen, Fanglin and Chen, Zhenyu and Li, Tianxing and Harari, Gabriella and Tignor, Stefanie and Zhou, Xia and Ben-Zeev, Dror and Campbell, Andrew T.},
title = {StudentLife: assessing mental health, academic performance and behavioral trends of college students using smartphones},
year = {2014},
isbn = {9781450329682},
publisher = {Association for Computing Machinery},
address = {New York, NY, USA},
url = {https://doi.org/10.1145/2632048.2632054},
doi = {10.1145/2632048.2632054},
abstract = {Much of the stress and strain of student life remains hidden. The StudentLife continuous sensing app assesses the day-to-day and week-by-week impact of workload on stress, sleep, activity, mood, sociability, mental well-being and academic performance of a single class of 48 students across a 10 week term at Dartmouth College using Android phones. Results from the StudentLife study show a number of significant correlations between the automatic objective sensor data from smartphones and mental health and educational outcomes of the student body. We also identify a Dartmouth term lifecycle in the data that shows students start the term with high positive affect and conversation levels, low stress, and healthy sleep and daily activity patterns. As the term progresses and the workload increases, stress appreciably rises while positive affect, sleep, conversation and activity drops off. The StudentLife dataset is publicly available on the web.},
booktitle = {Proceedings of the 2014 ACM International Joint Conference on Pervasive and Ubiquitous Computing},
pages = {3–14},
numpages = {12},
keywords = {smartphone sensing, mental health, data analysis, behavioral trends, academic performance},
location = {Seattle, Washington},
series = {UbiComp '14}
}
```