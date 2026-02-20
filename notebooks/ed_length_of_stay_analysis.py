"""Emergency Department Length of Stay Analysis (Python)

Python conversion of the notebook workflow in:
- notebooks/ed_length_of_stay_analysis.ipynb

Run from repository root:
    python notebooks/ed_length_of_stay_analysis.py
"""

from __future__ import annotations

from pathlib import Path

import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import statsmodels.api as sm
import statsmodels.formula.api as smf
from scipy import stats
from sklearn.metrics import mean_squared_error
from sklearn.model_selection import train_test_split


ROOT = Path(__file__).resolve().parents[1]
DATA_PATH = ROOT / "data" / "raw" / "ed_length_of_stay_100k.csv"
FIGURES_DIR = ROOT / "figures"
RANDOM_STATE = 123


def load_and_clean_data(file_path: Path) -> pd.DataFrame:
    df = pd.read_csv(file_path)

    df["vdate"] = pd.to_datetime(df["vdate"], format="%m/%d/%Y", errors="coerce")
    df["discharged"] = pd.to_datetime(df["discharged"], format="%m/%d/%Y", errors="coerce")

    df["gender"] = df["gender"].astype("category")
    rcount_levels = ["0", "1", "2", "3", "4", "5+"]
    df["rcount"] = pd.Categorical(df["rcount"].astype(str), categories=rcount_levels, ordered=True)
    df["facid"] = df["facid"].astype("category")
    df["lengthofstay"] = pd.to_numeric(df["lengthofstay"], errors="coerce")

    df = df[(df["sodium"] >= 110) & (df["sodium"] <= 170)]
    df = df[(df["neutrophils"] >= 0) & (df["neutrophils"] <= 100)]
    df = df[df["glucose"] >= 0]
    df = df[(df["bloodureanitro"] >= 0) & (df["bloodureanitro"] <= 200)]
    df = df[(df["respiration"] >= 4) & (df["respiration"] <= 40)]
    df = df[(df["hematocrit"] >= 5) & (df["hematocrit"] <= 60)]
    df = df[df["lengthofstay"] > 0]

    return df.dropna(subset=["lengthofstay"]).copy()


def run_eda(df: pd.DataFrame) -> None:
    FIGURES_DIR.mkdir(parents=True, exist_ok=True)

    print("\n=== EDA ===")
    print(df.describe(include="all").T.head(20))

    plt.figure(figsize=(8, 5))
    plt.hist(df["lengthofstay"], bins=20, edgecolor="black")
    plt.title("Histogram of Length of Stay")
    plt.xlabel("Length of Stay")
    plt.ylabel("Count")
    plt.tight_layout()
    plt.savefig(FIGURES_DIR / "los_histogram_python.png", dpi=140)
    plt.close()

    plt.figure(figsize=(6, 4))
    df["gender"].value_counts(dropna=False).plot(kind="bar")
    plt.title("Gender Distribution")
    plt.xlabel("Gender")
    plt.ylabel("Count")
    plt.tight_layout()
    plt.savefig(FIGURES_DIR / "gender_distribution_python.png", dpi=140)
    plt.close()

    plt.figure(figsize=(9, 4))
    df["facid"].value_counts(dropna=False).sort_index().plot(kind="bar")
    plt.title("Facility Distribution")
    plt.xlabel("Facility ID")
    plt.ylabel("Count")
    plt.tight_layout()
    plt.savefig(FIGURES_DIR / "facility_distribution_python.png", dpi=140)
    plt.close()


def run_inference(df: pd.DataFrame) -> None:
    print("\n=== Inference ===")

    male_los = df.loc[df["gender"] == "M", "lengthofstay"].dropna()
    female_los = df.loc[df["gender"] == "F", "lengthofstay"].dropna()
    t_stat, p_value = stats.ttest_ind(male_los, female_los, equal_var=False)
    print(f"Two-sample t-test (Gender): t = {t_stat:.4f}, p = {p_value:.6g}")

    anova_model = smf.ols("lengthofstay ~ C(facid)", data=df).fit()
    anova_table = sm.stats.anova_lm(anova_model, typ=2)
    print("\nOne-way ANOVA (Facility):")
    print(anova_table)


def get_formulas() -> dict[str, str]:
    full_formula = (
        "lengthofstay ~ C(gender) + C(rcount) + C(facid) + "
        "dialysisrenalendstage + asthma + irondef + pneum + "
        "substancedependence + psychologicaldisordermajor + depress + psychother + "
        "fibrosisandother + malnutrition + hemo + hematocrit + neutrophils + sodium + "
        "glucose + bloodureanitro + creatinine + bmi + pulse + respiration + "
        "secondarydiagnosisnonicd9"
    )

    clinical_formula = (
        "lengthofstay ~ C(rcount) + dialysisrenalendstage + pneum + "
        "psychologicaldisordermajor + depress + malnutrition + hematocrit + "
        "neutrophils + sodium + glucose + bloodureanitro + creatinine + bmi + "
        "pulse + respiration"
    )

    minimal_formula = "lengthofstay ~ C(rcount) + hematocrit + bloodureanitro + creatinine"

    return {
        "full": full_formula,
        "clinical": clinical_formula,
        "minimal": minimal_formula,
    }


def run_regression_workflow(df: pd.DataFrame) -> None:
    formulas = get_formulas()

    print("\n=== Baseline Regression (MLR) ===")
    mlr = smf.ols(formulas["full"], data=df).fit()
    print(mlr.summary().tables[0])
    print(mlr.summary().tables[1])

    print("\nAIC / BIC (nested models)")
    m_full = smf.ols(formulas["full"], data=df).fit()
    m_clinical = smf.ols(formulas["clinical"], data=df).fit()
    m_minimal = smf.ols(formulas["minimal"], data=df).fit()
    print(
        pd.DataFrame(
            {
                "Model": ["Full", "Clinical", "Minimal"],
                "AIC": [m_full.aic, m_clinical.aic, m_minimal.aic],
                "BIC": [m_full.bic, m_clinical.bic, m_minimal.bic],
            }
        )
    )

    train, test = train_test_split(df, test_size=0.30, random_state=RANDOM_STATE)

    m_full_tr = smf.ols(formulas["full"], data=train).fit()
    m_clinical_tr = smf.ols(formulas["clinical"], data=train).fit()
    m_minimal_tr = smf.ols(formulas["minimal"], data=train).fit()

    y_test = test["lengthofstay"]
    pred_full = m_full_tr.predict(test)
    pred_clinical = m_clinical_tr.predict(test)
    pred_minimal = m_minimal_tr.predict(test)

    mspe_results = pd.DataFrame(
        {
            "Model": ["Full", "Clinical", "Minimal"],
            "MSPE": [
                mean_squared_error(y_test, pred_full),
                mean_squared_error(y_test, pred_clinical),
                mean_squared_error(y_test, pred_minimal),
            ],
        }
    )

    print("\nMSPE Comparison")
    print(mspe_results)

    run_gamma_glm(df, train, test, formulas["clinical"], mspe_results)
    plot_mlr_diagnostics(mlr)


def run_gamma_glm(
    df: pd.DataFrame,
    train: pd.DataFrame,
    test: pd.DataFrame,
    glm_formula: str,
    mspe_results: pd.DataFrame,
) -> None:
    print("\n=== Gamma GLM (Improved Model) ===")

    gamma_family = sm.families.Gamma(sm.families.links.Log())
    glm_improved = smf.glm(glm_formula, data=df, family=gamma_family).fit()

    print(glm_improved.summary().tables[0])
    print(glm_improved.summary().tables[1])

    pseudo_r2 = 1 - (glm_improved.deviance / glm_improved.null_deviance)
    print(f"Pseudo R^2: {pseudo_r2:.4f}")
    print(f"AIC: {glm_improved.aic:.2f}")

    glm_improved_tr = smf.glm(glm_formula, data=train, family=gamma_family).fit()
    pred_glm = glm_improved_tr.predict(test)
    mspe_glm = mean_squared_error(test["lengthofstay"], pred_glm)

    mspe_all = pd.concat(
        [
            mspe_results,
            pd.DataFrame({"Model": ["Gamma GLM (improved)"], "MSPE": [mspe_glm]}),
        ],
        ignore_index=True,
    )

    print("\nMSPE Including Gamma GLM")
    print(mspe_all)

    plot_glm_diagnostics(glm_improved)


def plot_mlr_diagnostics(model: sm.regression.linear_model.RegressionResultsWrapper) -> None:
    FIGURES_DIR.mkdir(parents=True, exist_ok=True)

    residuals = model.resid
    fitted = model.fittedvalues

    plt.figure(figsize=(8, 5))
    plt.scatter(fitted, residuals, alpha=0.2)
    plt.axhline(0, linestyle="--")
    plt.title("MLR Residuals vs Fitted")
    plt.xlabel("Fitted values")
    plt.ylabel("Residuals")
    plt.tight_layout()
    plt.savefig(FIGURES_DIR / "mlr_residuals_vs_fitted_python.png", dpi=140)
    plt.close()

    plt.figure(figsize=(8, 5))
    stats.probplot(residuals, dist="norm", plot=plt)
    plt.title("MLR Normal Q-Q")
    plt.tight_layout()
    plt.savefig(FIGURES_DIR / "mlr_qq_python.png", dpi=140)
    plt.close()


def plot_glm_diagnostics(model: sm.genmod.generalized_linear_model.GLMResultsWrapper) -> None:
    FIGURES_DIR.mkdir(parents=True, exist_ok=True)

    fitted = model.fittedvalues
    resid = model.resid_pearson

    sample_size = min(10_000, len(resid))
    rng = np.random.default_rng(RANDOM_STATE)
    idx = rng.choice(np.arange(len(resid)), size=sample_size, replace=False)

    fitted_sample = fitted.iloc[idx]
    resid_sample = resid.iloc[idx]

    plt.figure(figsize=(8, 5))
    plt.scatter(fitted_sample, resid_sample, alpha=0.2)
    plt.axhline(0, linestyle="--")
    plt.title("Gamma GLM Residuals vs Fitted")
    plt.xlabel("Fitted values")
    plt.ylabel("Pearson residuals")
    plt.tight_layout()
    plt.savefig(FIGURES_DIR / "glm_residuals_vs_fitted_python.png", dpi=140)
    plt.close()

    plt.figure(figsize=(8, 5))
    stats.probplot(resid_sample, dist="norm", plot=plt)
    plt.title("Gamma GLM Normal Q-Q")
    plt.tight_layout()
    plt.savefig(FIGURES_DIR / "glm_qq_python.png", dpi=140)
    plt.close()


def main() -> None:
    print("Loading data from:", DATA_PATH)
    df = load_and_clean_data(DATA_PATH)

    print("\nRows, Columns:", df.shape)
    print("Missing values per column (top 10):")
    print(df.isna().sum().sort_values(ascending=False).head(10))
    print("Duplicate rows:", df.duplicated().sum())

    run_eda(df)
    run_inference(df)
    run_regression_workflow(df)

    print("\nDone. Figures saved in:", FIGURES_DIR)


if __name__ == "__main__":
    main()
