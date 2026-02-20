# Data Documentation

## Dataset

- **Name:** Hospital Length of Stay Dataset (Microsoft)
- **Source:** Kaggle
- **File in repo:** `data/raw/ed_length_of_stay_100k.csv`
- **Rows / columns:** 100,000 rows, 28 variables

## Data Characteristics

- Synthetic patient-encounter style records.
- Includes demographics, comorbidity flags, labs, vitals, facility ID, and LOS.
- Target variable: `lengthofstay`.

## Data Quality Steps Used in Analysis

- Converted date fields to date type.
- Converted key categorical fields to factors.
- Removed physiologically implausible values in selected labs/vitals.
- Verified missingness and duplicate records.

## Notes for Reviewers

- Data is synthetic and intended for educational/statistical demonstration.
- This project does not include protected health information (PHI).
- If you replace this file with another version, keep column names unchanged to run the notebook without edits.