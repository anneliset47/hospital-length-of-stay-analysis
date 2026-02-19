# Emergency Department Length of Stay: Statistical Modeling Analysis

## Overview

This project investigates the factors that influence Emergency Department (ED) Length of Stay (LOS) and evaluates predictive modeling approaches to estimate LOS.

Using the Kaggle “Hospital Length of Stay” dataset (100,000 encounters, 28 variables), this analysis combines classical inference and predictive modeling to determine which demographic, facility, and clinical characteristics drive LOS variation.

The primary research question:

> What factors drive emergency department length of stay, and how well can LOS be predicted?

---

## Dataset

Source: Kaggle – Hospital Length of Stay Dataset (Microsoft)

- 100,000 observations
- 28 variables
- Includes demographics, comorbidities, lab values, facility ID, and discharge information
- Outcome variable: `lengthofstay`

Data preprocessing included:
- Date conversion
- Factor encoding of categorical variables
- Removal of physiologically impossible lab values
- Type correction for modeling compatibility

---

## Exploratory Data Analysis

Key findings from EDA:

- LOS is strongly right-skewed
- Most patients have short stays
- A small subset has prolonged stays
- LOS varies across facilities
- Clinical variables show stronger variation than demographic variables

Visualizations:
- Histogram of LOS
- Facility distribution
- Gender distribution
- Numeric variable summaries

---

## Statistical Inference

### 1. Two-Sample t-Test (Gender)

Hypothesis:
- H₀: Mean LOS does not differ by gender
- H₁: Mean LOS differs by gender

Result:
- No meaningful gender difference in LOS

---

### 2. One-Way ANOVA (Facility)

Hypothesis:
- H₀: All facilities have equal mean LOS
- H₁: At least one facility differs

Result:
- Facility significantly impacts LOS
- Suggests operational or workflow differences

---

## Regression Modeling

### 1. Multiple Linear Regression (MLR)

Model included:
- Demographics
- Facility ID
- Comorbidities
- Lab values
- Vital signs
- Readmission count

Model evaluation:
- R²
- Residual diagnostics
- AIC and BIC
- MSPE (train/test split)

Findings:
- Clinical complexity variables were strong predictors
- Assumptions of normality and homoscedasticity were violated
- Residual patterns reflected skewed outcome structure

---

## Model Selection

Three nested models were compared:

- Full model
- Clinically motivated model
- Minimal predictor model

Criteria:
- AIC
- BIC
- Mean Squared Prediction Error (MSPE)

The clinically motivated model achieved a strong balance between interpretability and predictive performance.

---

## Improved Model: Gamma GLM

Because LOS is:
- Strictly positive
- Right-skewed
- Heteroscedastic

A Gamma GLM with log link was fitted.

Evaluation:
- AIC
- BIC
- Pseudo R²
- MSPE (outperformed MLR)
- Residual diagnostics

The Gamma GLM demonstrated:
- Improved predictive stability
- Better alignment with outcome distribution
- Lower MSPE compared to linear models

---

## Key Conclusions

- Clinical severity and complexity drive LOS more than demographics
- Facility differences meaningfully impact LOS
- Standard linear regression is not ideal for skewed, positive outcomes
- Gamma GLM provides a statistically appropriate and more accurate framework for LOS prediction

This analysis demonstrates how classical inference and generalized modeling approaches can be combined to analyze healthcare operational data effectively.

---

## Repository Structure

```
ed-length-of-stay-statistical-modeling/
│
├── README.md
├── LICENSE
├── requirements.txt
│
├── data/
│   ├── raw/
│   │   └── LengthOfStay.csv
│   └── processed/
│
├── notebooks/
│   └── ed_length_of_stay_analysis.ipynb
│
├── figures/
│
└── report/
    └── final_project_report.pdf
```

---

## Methods Demonstrated

- Hypothesis Testing
- ANOVA
- Multiple Linear Regression
- Model Diagnostics
- AIC / BIC Model Selection
- Train/Test Validation
- Mean Squared Prediction Error
- Gamma Generalized Linear Model
- Pseudo R²
- Residual Analysis

---

## Reproducibility

Install dependencies:

```
pip install -r requirements.txt
```

Run the notebook from the `notebooks/` directory.

---

## References

- Kaggle: Hospital Length of Stay Dataset
- Peer-reviewed literature on ED throughput and LOS modeling
