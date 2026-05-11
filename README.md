# tessera: Genomic-driven biomarker validation for colorectal cancer

> *Each polygenic tile completes the mosaic of cancer risk.*

**Genomic-driven biomarker identification for colorectal cancer — a statistics-focused R package.**

This project demonstrates an end-to-end, reproducible, in-silico validation of a
candidate stratification biomarker on a UK-Biobank–like clinical cohort.

## Scientific question (project hypothesis)

> In a UK-Biobank–like clinical cohort, a colorectal-cancer polygenic risk
> score (CRC-PRS) is associated with circulating CEA levels independently
> of age, sex, BMI and smoking — supporting CEA as a genetically anchored,
> in-silico-validated stratification biomarker for CRC risk.

Disease area: **colorectal cancer (CRC)**, one of the most common cancers
worldwide. Study design: **clinical cohort** (cross-sectional read-out,
biobank-style).

## Package layout

```
tessera/
├── DESCRIPTION              # R package metadata
├── NAMESPACE
├── R/                       # Statistical functions
│   ├── simulate_data.R      #   simulate_crc_cohort()
│   ├── fit_models.R         #   linear / logistic / interaction LRT / tidy
│   ├── plots.R              #   ggplot2 helpers (scatter, forest, ROC)
│   └── tessera-package.R
├── data-raw/generate_cohort.R
├── analysis/                # Quarto site (the deliverable)
│   ├── _quarto.yml
│   ├── index.qmd
│   └── report.qmd
├── tests/testthat/          # unit tests
├── .devcontainer/devcontainer.json
└── .github/workflows/publish.yml   # GitHub Pages via GitHub Actions
```

## Getting started

Open the folder in VS Code and reopen in the dev container (Rocker
tidyverse 4.4 + Quarto). On first launch the container will install the
extra R deps and the package itself.

```r
# Simulate cohort (or use the bundled `crc_cohort` dataset)
library(tessera)
cohort <- simulate_crc_cohort(n = 5000, seed = 42)

# Primary analysis
fit <- fit_biomarker_lm(cohort)
tidy_effects(fit)
```

## Render the report locally

```bash
quarto render analysis
# or live preview:
quarto preview analysis/report.qmd
```

## Publishing the report on GitHub Pages

1. Push the repository to GitHub.
2. **Settings → Pages → Source: GitHub Actions**.
3. Push to `main` (or run the workflow manually) — `.github/workflows/publish.yml`
   builds the Quarto site and deploys it via `actions/deploy-pages`.

## Statistical methods

| Endpoint | Model | Effect of interest |
|---|---|---|
| `log(CEA)` | OLS, `lm()` | Beta of standardised CRC-PRS |
| Prevalent CRC | Logistic, `glm(binomial)` | Odds ratio of standardised CRC-PRS |
| Effect modification | Nested-model LRT | PRS × sex on `log(CEA)` |
| Discrimination | Empirical AUC | Logistic model on test cohort |

All effects are reported with 95% Wald confidence intervals via `broom::tidy()`.
