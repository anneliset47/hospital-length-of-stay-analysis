# Emergency Department Length of Stay Analysis

Portfolio-ready statistical analysis of emergency department (ED) throughput using inferential statistics and predictive modeling in R.

![Project Type](https://img.shields.io/badge/Project-Healthcare%20Analytics-blue)
![Methods](https://img.shields.io/badge/Methods-EDA%20%7C%20Inference%20%7C%20GLM-success)
![Status](https://img.shields.io/badge/Status-Portfolio%20Ready-brightgreen)

## Quick Links

- Notebook (R): [notebooks/ed_length_of_stay_analysis.ipynb](notebooks/ed_length_of_stay_analysis.ipynb)
- Script (R): [notebooks/ed_length_of_stay_analysis.R](notebooks/ed_length_of_stay_analysis.R)
- Report (PDF): [report/ed_length_of_stay_report.pdf](report/ed_length_of_stay_report.pdf)
- Portfolio Summary: [PORTFOLIO_SUMMARY.md](PORTFOLIO_SUMMARY.md)
- Resume Bullets: [RESUME_BULLETS.md](RESUME_BULLETS.md)

## Project Snapshot

- **Goal:** Identify key drivers of ED length of stay (LOS) and compare model families for accurate LOS prediction.
- **Data:** 100,000 synthetic encounters, 28 variables (Kaggle “Hospital Length of Stay Dataset - Microsoft”).
- **Approach:** EDA → inference (t-test, ANOVA) → model comparison (MLR vs Gamma GLM).
- **Outcome:** Gamma GLM (log link) provides better fit for strictly positive, right-skewed LOS outcomes.

## Why This Project Is Relevant

ED length of stay is a critical operational metric tied to crowding, patient experience, and care flow efficiency. This project demonstrates an end-to-end analytics workflow suitable for healthcare operations and data science roles:

- framing an operational business question,
- preparing and quality-checking real-world style data,
- selecting statistically appropriate models,
- validating and communicating results clearly.

## Core Skills Demonstrated

- Statistical inference (two-sample t-test, one-way ANOVA)
- Regression modeling (Multiple Linear Regression, Gamma GLM)
- Model diagnostics and assumptions checking
- Model selection using AIC, BIC, and out-of-sample MSPE
- Data cleaning and feature typing in R
- Reproducible notebook-based analysis workflow

## Methods and Results

### 1) Exploratory Analysis

- LOS is strongly right-skewed with a long tail.
- Most encounters have shorter stays; a smaller subgroup has prolonged stays.
- Facility-level variation in LOS appears substantial.

### 2) Inferential Statistics

- **Gender comparison (two-sample t-test):** no practically meaningful mean LOS difference.
- **Facility comparison (one-way ANOVA):** significant between-facility differences in LOS.

### 3) Predictive Modeling

- Built nested multiple linear regression (MLR) models.
- Compared full, clinically motivated, and minimal specifications using AIC/BIC/MSPE.
- Diagnosed MLR residual violations (normality/constant variance) consistent with skewed positive outcomes.

### 4) Improved Model

- Fitted **Gamma GLM with log link**, aligned with LOS distribution properties.
- Evaluated with AIC, BIC, pseudo-$R^2$, and test-set MSPE.
- Gamma GLM showed stronger predictive stability and better distributional fit than baseline linear models.

## Tech Stack

- **Language:** R
- **Interface:** Jupyter Notebook (`.ipynb`) with R kernel
- **Analysis:** Base R statistical functions (`lm`, `glm`, `aov`, `t.test`, diagnostics)
- **Automation:** Makefile + GitHub Actions CI

## Report

- Full report (Markdown): [report/ed_length_of_stay_report.md](report/ed_length_of_stay_report.md)
- Full report (PDF): [report/ed_length_of_stay_report.pdf](report/ed_length_of_stay_report.pdf)

## Repository Structure

```
hospital-length-of-stay-analysis/
├── README.md
├── LICENSE
├── CONTRIBUTING.md
├── CODE_OF_CONDUCT.md
├── requirements-r.txt
├── .gitignore
├── data/
│   ├── README.md
│   ├── raw/
│   │   └── ed_length_of_stay_100k.csv
│   └── processed/
├── figures/
├── notebooks/
│   ├── README.md
│   ├── ed_length_of_stay_analysis.ipynb
│   └── ed_length_of_stay_analysis.R
├── report/
│   ├── ed_length_of_stay_report.md
│   └── ed_length_of_stay_report.pdf
├── PORTFOLIO_SUMMARY.md
├── RESUME_BULLETS.md
├── Makefile
└── .github/
    └── workflows/
    └── r-check.yml
```

## Reproducibility

1. Install R and Jupyter.
2. Install required R package(s):

    ```bash
    Rscript -e "install.packages('IRkernel', repos='https://cloud.r-project.org')"
    ```

3. Register R kernel (if needed):

    ```bash
    Rscript -e "IRkernel::installspec(user = TRUE)"
    ```

4. Open and run:

    - `notebooks/ed_length_of_stay_analysis.ipynb`

Detailed notes are in:

- `notebooks/README.md`
- `data/README.md`

For R script execution:

```bash
Rscript notebooks/ed_length_of_stay_analysis.R
```

## Limitations and Next Steps

- Data is synthetic and may not reflect full complexity of production EHR/ED systems.
- Additional operational predictors (arrival hour, staffing, bed occupancy) could improve performance.
- Future work could evaluate alternative distributions (e.g., log-normal, Tweedie), interaction effects, and fairness diagnostics.

## Data Source

- Kaggle: *Hospital Length of Stay Dataset – Microsoft*  
  https://www.kaggle.com/datasets/aayushchou/hospital-length-of-stay-dataset-microsoft?resource=download

## Author

**Annelise Thorn**  
This repository is maintained as a portfolio project demonstrating applied statistical modeling for healthcare operations.
