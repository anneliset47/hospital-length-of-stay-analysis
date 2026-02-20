# Reproducibility Guide

This guide provides a clean, repeatable workflow to reproduce the analysis and report artifacts.

## 1) Environment Setup

### Prerequisites

- R 4.2+
- Pandoc + XeLaTeX (for PDF report generation)

## 2) Run Analysis

From repository root:

```bash
Rscript notebooks/ed_length_of_stay_analysis.R
```

## 3) Build Report PDF

```bash
make report
```

This generates:

- `report/ed_length_of_stay_report.pdf`

## 4) Run Project Checks

```bash
make verify
```

Checks currently include:

- R script parse/syntax validation
- Presence of core data and report source files

## 5) Capture Environment Snapshot (Recommended)

```bash
make env-info
```

This writes session metadata to:

- `report/session_info.txt`

## 6) Expected Core Artifacts

- `notebooks/ed_length_of_stay_analysis.R`
- `report/ed_length_of_stay_report.md`
- `report/ed_length_of_stay_report.pdf`
- `report/session_info.txt` (optional but recommended)
