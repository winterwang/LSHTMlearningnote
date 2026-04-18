# install_deps.R — One-shot dependency installer for LSHTMlearningnote
#
# Run this ONCE before rendering the book:
#   source("R/install_deps.R")
#
# System prerequisites (install before running this script):
#   macOS:  brew install jags
#   Linux:  sudo apt-get install jags  OR  sudo dnf install JAGS
#
# This script uses {pak} for all package installation:
#   - Parallel resolver (faster than install.packages)
#   - Global binary cache (re-installs are instant)
#   - Unified API: CRAN / Bioconductor / GitHub in one call

message("=== LSHTMlearningnote dependency installer (pak-based) ===\n")
options(repos = c(CRAN = "https://cloud.r-project.org"))

# Step 0: bootstrap pak itself
if (!requireNamespace("pak", quietly = TRUE)) {
  message("[Step 0] Installing pak...")
  install.packages("pak")
}
library(pak)
message("[Step 0] pak ", as.character(packageVersion("pak")), " ready.\n")

# Step 1: CRAN packages
message("[Step 1] Installing core CRAN packages...")
pkg_install(c(
  "knitr", "kableExtra", "kfigr", "stargazer",
  "plyr", "tidyverse",
  "survival", "survminer", "Epi", "KMsurv", "flexsurv", "cmprsk", "mstate", "eha",
  "MASS", "lme4", "lmerTest", "nlme", "sandwich", "lmtest", "gnm", "margins",
  "clubSandwich", "car",
  "coda", "ggmcmc", "MCMCpack",
  "ggplot2", "ggthemes", "ggsci", "ggrepel", "patchwork", "scatterplot3d",
  "plotly", "ggdag", "ggfortify",
  "mvtnorm", "DescTools", "BSDA", "FSA", "exact2x2", "dagitty", "V8",
  "tableone", "Hmisc", "ROCR", "generalhoslem", "HLMdiag",
  "FactoMineR", "factoextra", "jtools",
  "epiR", "epiDisplay", "epitools", "psych", "TailRank",
  "splines", "gridExtra", "grid", "codetools", "tufte",
  "haven", "shiny", "ellipse", "gtools", "binom", "ATE",
  "mcmcplots"
), ask = FALSE)
message("[Step 1] CRAN packages done.\n")

# Step 2: GitHub packages (ggthemr — not on CRAN)
message("[Step 2] Installing GitHub packages...")
pkg_install("Mikata-Project/ggthemr", ask = FALSE)
message("[Step 2] GitHub packages done.\n")

# Step 3: Bioconductor
message("[Step 3] Installing Bioconductor packages...")
pkg_install("bioc::limma", ask = FALSE)
message("[Step 3] Bioconductor packages done.\n")

# Step 4: JAGS-dependent packages
jags_ok <- nzchar(Sys.which("jags"))
if (!jags_ok) {
  message("[Step 4] ⚠ JAGS CLI not found. Skipping rjags/R2jags/runjags.")
  message("          Install first:  brew install jags  (macOS)")
  message("          Then re-run this script.\n")
} else {
  message("[Step 4] JAGS found at ", Sys.which("jags"), ". Installing R packages...")
  pkg_install(c("rjags", "R2jags", "runjags"), ask = FALSE)
  message("[Step 4] JAGS R packages done.\n")
}

# Step 5: rstan (C++ compilation required, ~5-10 min first time)
message("[Step 5] Installing rstan (C++ compilation may take several minutes)...")
pkg_install("rstan", ask = FALSE)
message("[Step 5] rstan done.\n")

# Step 6: rethinking (McElreath SR2) — depends on rstan, not cmdstanr
message("[Step 6] Installing rethinking from GitHub (rstan backend)...")
# Install required deps first; build rethinking without pulling in optional cmdstanr
pkg_install(c("coda", "mvtnorm", "loo", "dagitty", "shape"), ask = FALSE)
pkg_install("rmcelreath/rethinking", dependencies = FALSE, ask = FALSE)
message("[Step 6] rethinking done.\n")

# Step 7: Archived packages (removed from CRAN; bundled in archived-packages/)
# See archived-packages/README.md for provenance and replacement notes.
message("[Step 7] Installing archived (removed-from-CRAN) packages from local tarballs...")
archive_dir <- file.path(getwd(), "archived-packages")
if (!dir.exists(archive_dir)) {
  message("  ⚠ archived-packages/ not found — are you running from the project root?")
  message("  Skipping. Run: setwd('/path/to/LSHTMlearningnote') first.\n")
} else {
  archived <- list(
    # pkg_name           = c(tarball, install_anyway_if_already_installed)
    epicalc              = "epicalc_2.15.1.0.tar.gz",   # Ch09 legacy; functionally replaced by epiDisplay
    LogisticDx           = "LogisticDx_0.3.tar.gz",     # Ch09 legacy; replaced by generalhoslem
    binomTools           = "binomTools_1.0-2.tar.gz",   # Ch09 legacy; replaced by binom
    ATE                  = "ATE_0.2.0.tar.gz",          # Ch11 causal inference
    uwIntroStats         = "uwIntroStats_0.0.7.tar.gz"  # Ch01 legacy; replaced by base R / Hmisc
  )
  for (pkg in names(archived)) {
    if (nzchar(system.file(package = pkg))) {
      message(sprintf("  ✓ %s already installed, skipping.", pkg))
    } else {
      tarball <- file.path(archive_dir, archived[[pkg]])
      if (file.exists(tarball)) {
        message(sprintf("  Installing %s from %s ...", pkg, archived[[pkg]]))
        tryCatch(
          install.packages(tarball, repos = NULL, type = "source"),
          error = function(e) message(sprintf("  ✗ Failed to install %s: %s", pkg, e$message))
        )
      } else {
        message(sprintf("  ✗ Tarball not found: %s", tarball))
      }
    }
  }
  message("[Step 7] Archived packages done.\n")
}

# Final: verification
message("=== Verification ===")
pkgs_check <- c("rjags", "R2jags", "runjags", "rstan", "rethinking", "limma", "ggthemr",
                "ATE", "epicalc", "LogisticDx", "binomTools", "uwIntroStats")
for (p in pkgs_check) {
  status <- if (nzchar(system.file(package = p))) "✓" else "✗ MISSING"
  message(sprintf("  %s  %s", status, p))
}
message("\nAll done. You can now run: bookdown::render_book()\n")
