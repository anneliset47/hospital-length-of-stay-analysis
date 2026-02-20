# Portfolio Summary: ED Length of Stay Analysis

## One-Line Value Proposition

Applied statistical modeling project that identifies operational and clinical drivers of emergency department length of stay and demonstrates model selection for skewed healthcare outcomes.

## Business Question

What factors drive ED length of stay, and which model best predicts LOS for operational planning?

## What I Did

- Cleaned and validated 100,000-row encounter-level dataset.
- Performed exploratory analysis to characterize LOS distribution and variability.
- Ran inferential tests (gender t-test, facility ANOVA).
- Built and compared nested MLR models using AIC/BIC and out-of-sample MSPE.
- Implemented Gamma GLM with log link to address positive skew and heteroscedasticity.
- Interpreted model diagnostics and translated findings into operational insights.

## Key Takeaways

- Clinical severity indicators explain LOS variation more than basic demographics.
- Facility-level differences suggest operational process effects.
- Gamma GLM is more appropriate than standard linear regression for LOS-like targets.

## Tools and Methods

- R, Jupyter Notebook, statistical inference, regression diagnostics, cross-validation style train/test evaluation.

## Recruiter Talking Points

- Demonstrates end-to-end project ownership: question framing → analysis → modeling → communication.
- Uses methodologically appropriate modeling choices based on outcome distribution.
- Translates technical findings into healthcare operations context.