# Notebook Execution Guide

## Notebook

- `ed_length_of_stay_analysis.ipynb`
- `ed_length_of_stay_analysis.py` (Python script conversion)

## Requirements

- R (recommended 4.2+)
- Jupyter Notebook or VS Code with Jupyter extension
- R kernel for Jupyter (`IRkernel`)

## Quick Start

1. Install IRkernel:

   ```bash
   Rscript -e "install.packages('IRkernel', repos='https://cloud.r-project.org')"
   ```

2. Register kernel (if not already registered):

   ```bash
   Rscript -e "IRkernel::installspec(user = TRUE)"
   ```

3. Open `ed_length_of_stay_analysis.ipynb` and select the **R** kernel.
4. Run cells top-to-bottom.

## Python Script Alternative

Run the converted Python analysis script from repo root:

```bash
pip install -r requirements.txt
python notebooks/ed_length_of_stay_analysis.py
```

## Data Path Assumption

The notebook currently reads the CSV by filename only. To avoid path issues, run from repo root or update the load statement to `data/raw/ed_length_of_stay_100k.csv`.