# Archived R Packages

This directory contains source tarballs of R packages that have been **removed from CRAN**
or are **no longer actively maintained**, but are required for historical code in this bookdown project.

These files are version-controlled so anyone cloning the repo can install them without
hunting for the originals. Use `R/install_deps.R` to install everything automatically.

---

## Package Inventory

| File | Package | CRAN Version | Removed From CRAN | Used In | Replacement |
|------|---------|-------------|-------------------|---------|-------------|
| `epicalc_2.15.1.0.tar.gz` | epicalc | 2.15.1.0 (last: 2012-09-19) | ~2013 | Ch09 GLM | `epiDisplay` (active fork, already in CRAN) |
| `LogisticDx_0.3.tar.gz` | LogisticDx | 0.3 | ~2022 | Ch09 GLM | `generalhoslem` (Hosmer-Lemeshow test) |
| `binomTools_1.0-2.tar.gz` | binomTools | 1.0-2 | unknown | Ch09 GLM | `binom` package |
| `ATE_0.2.0.tar.gz` | ATE | 0.2.0 | maintained ~2015 | Ch11 Causal | No full drop-in; keep for reference |
| `uwIntroStats_0.0.7.tar.gz` | uwIntroStats | 0.0.7 | 2020 | Ch01 intro | `Hmisc` / base R |

---

## Archive Sources

- **epicalc**: Last archived at https://cran.r-project.org/src/contrib/Archive/epicalc/epicalc_2.15.1.0.tar.gz  
  (Note: `epiDisplay` by the same author supersedes this and is on CRAN)
- **LogisticDx**: Removed from CRAN; no official archive mirror available
- **binomTools**: Not in CRAN archive; copy preserved from original author
- **ATE**: https://cran.r-project.org/src/contrib/Archive/ATE/ (last: 0.2.0)
- **uwIntroStats**: Archived at https://cran.r-project.org/src/contrib/Archive/uwIntroStats/

---

## Installation

Run from the project root:

```r
source("R/install_deps.R")
```

Or install individually:

```r
install.packages("archived-packages/epicalc_2.15.1.0.tar.gz", repos = NULL, type = "source")
install.packages("archived-packages/ATE_0.2.0.tar.gz",        repos = NULL, type = "source")
```

---

## Notes

- These packages are kept for **historical code preservation only**. New code should use the replacement packages listed above.
- `epicalc` is functionally superseded by `epiDisplay`, which is loaded by `global_setup.R` instead.
- Chapters that were migrated away from these packages are noted with `# [LEGACY - replaced by X]` comments in the Rmd source.
