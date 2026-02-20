# Emergency Department Length of Stay: A Statistical Modeling Analysis
# Annelise Thorn
# STAT 5010: Statistical Methods and Applications II
# December 10, 2025

# ======================================================
# 1. Introduction, Research Question, and Techniques Used
# ======================================================

# This script is a direct R conversion of:
# notebooks/ed_length_of_stay_analysis.ipynb

# ========
# 2. Data
# ========

# 2.1 Data Import & Source
# Source: https://www.kaggle.com/datasets/aayushchou/hospital-length-of-stay-dataset-microsoft?resource=download

# load the dataset
df <- read.csv("data/raw/ed_length_of_stay_100k.csv")

# preview the dataset
head(df)

# 2.2 Data Description

# find number of rows and columns
dim(df)

# find names of columns
names(df)

# # summary statistics of the data
# summary(data)

# 2.3 Data Cleaning / Pre-processing

# check for missing values
colSums(is.na(df))

# check for duplicate rows
sum(duplicated(df))

# # check initial data types of each column
# str(df)

# # give the 5 number summary of numeric columns
# summary(df)

# convert date columns to Date type
df$vdate      <- as.Date(df$vdate, format = "%m/%d/%Y")
df$discharged <- as.Date(df$discharged, format = "%m/%d/%Y")

# convert gender to a factor
df$gender <- as.factor(df$gender)

# convert rcount to a factor and make ordered
df$rcount <- factor(
  df$rcount,
  levels  = c("0", "1", "2", "3", "4", "5+"),
  ordered = TRUE
)

# make facility ID a factor
df$facid <- as.factor(df$facid)

# make length of stay numeric
df$lengthofstay <- as.numeric(df$lengthofstay)

# remove impossible physiologic values
df <- df[df$sodium >= 110 & df$sodium <= 170, ]
df <- df[df$neutrophils >= 0 & df$neutrophils <= 100, ]
df <- df[df$glucose >= 0, ]
df <- df[df$bloodureanitro >= 0 & df$bloodureanitro <= 200, ]
df <- df[df$respiration >= 4 & df$respiration <= 40, ]
df <- df[df$hematocrit >= 5 & df$hematocrit <= 60, ]

# check for changes
str(df)

# ================================
# 3. Exploratory Data Analysis
# ================================

# check the 5 number summary of numeric columns
summary(df)

# # make boxplots for numeric columns to check for outliers
# numeric_columns <- sapply(df, is.numeric)
# for (col in names(df)[numeric_columns]) {
#   boxplot(df[[col]], main = paste("Boxplot of", col))
# }

# # make histograms of numeric / continuous variables
# hist(df$hemo,           breaks = 20, main = "Histogram of Hemoglobin")
# hist(df$hematocrit,     breaks = 20, main = "Histogram of Hematocrit")
# hist(df$neutrophils,    breaks = 20, main = "Histogram of Neutrophils")
# hist(df$sodium,         breaks = 20, main = "Histogram of Sodium")
# hist(df$glucose,        breaks = 20, main = "Histogram of Glucose")
# hist(df$bloodureanitro, breaks = 20, main = "Histogram of Blood Urea Nitrogen")
# hist(df$creatinine,     breaks = 20, main = "Histogram of Creatinine")
# hist(df$bmi,            breaks = 20, main = "Histogram of BMI")
# hist(df$pulse,          breaks = 20, main = "Histogram of Pulse Rate")
# hist(df$respiration,    breaks = 20, main = "Histogram of Respiration Rate")
hist(df$lengthofstay, breaks = 20, main = "Histogram of Length of Stay")

# # make barplots of binary / indicator INT variables
# barplot(table(df$dialysisrenalendstage), main = "Dialysis / Renal End-Stage")
# barplot(table(df$asthma),                main = "Asthma")
# barplot(table(df$irondef),               main = "Iron Deficiency")
# barplot(table(df$pneum),                 main = "Pneumonia")
# barplot(table(df$substancedependence),   main = "Substance Dependence")
# barplot(table(df$psychologicaldisordermajor), main = "Major Psychological Disorder")
# barplot(table(df$depress),               main = "Depression")
# barplot(table(df$psychother),            main = "Other Psychological Disorder")
# barplot(table(df$fibrosisandother),      main = "Fibrosis and Other")
# barplot(table(df$malnutrition),          main = "Malnutrition")

# # make barplot for other discrete INT variables
# barplot(table(df$secondarydiagnosisnonicd9),
#         main = "Secondary Diagnosis (non-ICD9) Count")

# # make barplots for categorical / factor variables
barplot(table(df$gender), main = "Gender Distribution")
# barplot(table(df$rcount), main = "Readmission Count")
barplot(table(df$facid),  main = "Facility Distribution")

# # make histograms for date variables
# hist(df$vdate,      breaks = "months", main = "Histogram of Visit Dates")
# hist(df$discharged, breaks = "months", main = "Histogram of Discharge Dates")

# =======================
# 4. Modeling & Inference
# =======================

# 4.1 Hypothesis Tests/Confidence Intervals

# t-test: Does LOS differ by gender?
# h0: There is no difference in the mean length of stay between male and female patients.
# h1: There is a difference in mean length of stay between males and females.

# two-sample t-test (two-sided)
ttest_gender <- t.test(lengthofstay ~ gender, data = df)

ttest_gender

# ANOVA: Does LOS differ across facilities?
# h0: All facilities have the same population mean length of stay.
# h1: At least one facility has a mean LOS that is different from the others.

# fit ANOVA model
anova_fac <- aov(lengthofstay ~ facid, data = df)

# ANOVA table
summary(anova_fac)

# Tukey test
TukeyHSD(anova_fac)

# 4.2 Baseline Regression Model (MLR)

# model with clinically relevant predictors
lm_mlr <- lm(
  lengthofstay ~ gender + rcount + facid +
    dialysisrenalendstage + asthma + irondef + pneum +
    substancedependence + psychologicaldisordermajor +
    depress + psychother + fibrosisandother +
    malnutrition + hemo +
    hematocrit + neutrophils + sodium + glucose +
    bloodureanitro + creatinine + bmi + pulse +
    respiration + secondarydiagnosisnonicd9,
  data = df
)

# model summary
summary(lm_mlr)

# 95% CIs for key coefficients
confint(lm_mlr)

# R-squared
summary(lm_mlr)$r.squared

# 4.3 Diagnostics for Baseline Model

# residual standard error
sigma(lm_mlr)

# information criteria for model comparison
AIC(lm_mlr)
BIC(lm_mlr)

par(mfrow = c(1, 1))

# residuals vs fitted
plot(lm_mlr, which = 1)

# normal Q-Q
plot(lm_mlr, which = 2)

# 4.4 Model Selection (AIC, BIC, MSPE)

# use the model as "full" model
form_full <- formula(lm_mlr)

# make more clinically-focused (drop some less important variables)
form_clinical <- lengthofstay ~
  rcount +
  dialysisrenalendstage + pneum +
  psychologicaldisordermajor + depress + malnutrition +
  hematocrit + neutrophils + sodium + glucose +
  bloodureanitro + creatinine + bmi + pulse + respiration

# "minimal" model using just a few strong predictors
form_minimal <- lengthofstay ~
  rcount + hematocrit + bloodureanitro + creatinine

# fit the three models on the full dataset
m_full     <- lm(form_full, data = df)
m_clinical <- lm(form_clinical, data = df)
m_minimal  <- lm(form_minimal, data = df)

# compare AIC and BIC
AIC(m_full, m_clinical, m_minimal)
BIC(m_full, m_clinical, m_minimal)

# train/test split and MSPE for the models
set.seed(123)

n <- nrow(df)
idx_train <- sample(seq_len(n), size = floor(0.7 * n))
train <- df[idx_train, ]
test  <- df[-idx_train, ]

# refit on training data
m_full_tr     <- lm(form_full, data = train)
m_clinical_tr <- lm(form_clinical, data = train)
m_minimal_tr  <- lm(form_minimal, data = train)

# true outcomes in test set
y_test <- test$lengthofstay

# predictions
pred_full     <- predict(m_full_tr, newdata = test)
pred_clinical <- predict(m_clinical_tr, newdata = test)
pred_minimal  <- predict(m_minimal_tr, newdata = test)

# MSPE for each model
mspe_results <- data.frame(
  Model = c("Full", "Clinical", "Minimal"),
  MSPE  = c(
    mean((y_test - pred_full)^2),
    mean((y_test - pred_clinical)^2),
    mean((y_test - pred_minimal)^2)
  )
)

mspe_results

# 4.5 Improved Model (GLM)

# use the clinically-motivated predictor set from 4.4
form_glm <- form_clinical

# fit Gamma GLM on the full dataset
glm_improved <- glm(
  formula = form_glm,
  family  = Gamma(link = "log"),
  data    = df
)

# model summary, AIC, and BIC
summary(glm_improved)
AIC(glm_improved)
BIC(glm_improved)

# Pseudo R^2 = 1 - (residual deviance / null deviance)
pseudo_R2_glm <- 1 - glm_improved$deviance / glm_improved$null.deviance
pseudo_R2_glm

# MSPE for the Gamma GLM

# fit the Gamma GLM on the training data
glm_improved_tr <- glm(
  formula = form_glm,
  family  = Gamma(link = "log"),
  data    = train
)

# predict LOS on the test set
pred_glm_improved <- predict(
  glm_improved_tr,
  newdata = test,
  type   = "response"
)

# MSPE
mspe_glm_improved <- mean((y_test - pred_glm_improved)^2)
mspe_glm_improved

# Add to the MSPE comparison table from 4.4
mspe_results_4_5 <- rbind(
  mspe_results,
  data.frame(
    Model = "Gamma GLM (improved)",
    MSPE  = mspe_glm_improved
  )
)

mspe_results_4_5

# 4.6 Final Model Diagnostics

# using the improved Gamma GLM as the final model
final_model <- glm_improved

# get fitted values and Pearson residuals
fitted_full <- fitted(final_model)
resid_full  <- residuals(final_model, type = "pearson")

# downsample residuals for plotting (large plots were causing the kernel to restart)
set.seed(123)
n       <- length(resid_full)
n_plot  <- min(10000, n)  # keep plots manageable
idx     <- sample(seq_len(n), size = n_plot)

fitted_resid <- fitted_full[idx]
resid_resid  <- resid_full[idx]

# basic summaries (full residuals)
summary(fitted_full)
summary(resid_full)

# diagnostic plots
op <- par(mfrow = c(2, 2))

# 1) Residuals vs fitted
plot(
  fitted_resid,
  resid_resid,
  xlab = "Fitted values",
  ylab = "Pearson residuals",
  main = "Residuals vs Fitted (Gamma GLM)"
)
abline(h = 0, lty = 2)

# 2) Normal Q-Q plot
qqnorm(resid_resid, main = "Normal Q-Q Plot (Gamma GLM)")
qqline(resid_resid, lty = 2)

# 3) Scale–location plot
plot(
  fitted_resid,
  sqrt(abs(resid_resid)),
  xlab = "Fitted values",
  ylab = "√|Pearson residuals|",
  main = "Scale–Location Plot"
)

# 4) Residuals vs index
plot(
  seq_along(resid_resid),
  resid_resid,
  xlab = "Index",
  ylab = "Pearson residuals",
  main = "Residuals vs Index"
)
abline(h = 0, lty = 2)

par(op)

# ============
# 5. Conclusion
# ============
# See notebook markdown for full narrative conclusion.

# ============
# 6. References
# ============
# https://www.kaggle.com/datasets/aayushchou/hospital-length-of-stay-dataset-microsoft?resource=download
# https://www.sciencedirect.com/science/article/pii/S1755599X20301026
