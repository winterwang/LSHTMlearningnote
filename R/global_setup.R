# Global setup for LSHTMlearningnote bookdown project
# Centralizes package loading and shared options so chapters can knit standalone.

# 1. Core options
options(
  htmltools.dir.version = FALSE,
  formatR.indent = 2,
  width = 100,
  digits = 4,
  rgl.useNULL = TRUE
)

# 2. Packages (grouped):
.pkgs <- c(
  # authoring / formatting
  "knitr", "kableExtra", "kfigr", "stargazer",
  # data wrangling & tidyverse (plyr MUST load before tidyverse to avoid dplyr masking)
  "plyr", "tidyverse",
  # survival / clinical
  "survival", "survminer", "Epi", "KMsurv", "flexsurv", "cmprsk", "mstate", "eha",
  # modeling & regression
  "MASS", "lme4", "lmerTest", "nlme", "sandwich", "lmtest", "gnm", "margins", "clubSandwich", "car",
  # Bayesian / MCMC (CRAN-only subset)
  "coda", "ggmcmc", "MCMCpack",
  # visualization
  "ggplot2", "ggthemes", "ggsci", "ggrepel", "patchwork", "scatterplot3d", "plotly", "ggdag",
  "ggfortify",
  # stats & misc
  "mvtnorm", "DescTools", "BSDA", "FSA", "exact2x2", "dagitty",
  "tableone", "Hmisc", "ROCR", "generalhoslem", "HLMdiag", "FactoMineR", "factoextra", "jtools",
  "epiR", "epiDisplay", "epitools", "psych", "TailRank", "splines", "gridExtra",
  "grid", "codetools", "tufte", "haven", "shiny", "ellipse", "gtools", "binom", "ATE"
)

# Packages needing special toolchains — load if available, do NOT auto-install
# rjags/R2jags/runjags need JAGS CLI (brew install jags)
# brms/tidybayes need rstan + C++ toolchain
# rethinking needs install_github("rmcelreath/rethinking") + rstan
# limma is Bioconductor: BiocManager::install("limma")
.pkgs_optional <- c("rjags", "R2jags", "runjags", "brms", "tidybayes", "rethinking", "limma", "mcmcplots", "ggthemr")
# NOTE: Removed deprecated/archived packages:
#   binomTools  -> replaced by binom
#   LogisticDx  -> replaced by generalhoslem (Hosmer-Lemeshow test)
#   uwIntroStats -> removed (use base R / Hmisc)

# 3. Install missing (quiet)
pkg_available <- function(p) {
  nzchar(system.file(package = p))
}

.install_missing <- function(pkgs) {
  status <- vapply(pkgs, pkg_available, logical(1))
  missing <- pkgs[!status]
  if (length(missing)) {
    message("Installing missing packages: ", paste(missing, collapse = ", "))
    install.packages(missing)
  }
  invisible(status)
}

pkg_status <- .install_missing(.pkgs)

# Ensure V8 dependency for dagitty and other JS-backed packages
if (!pkg_available("V8")) {
  try(install.packages("V8"))
  if (!pkg_available("V8")) warning("V8 still missing after attempted install; 'dagitty' may fail to load.")
}

# 4. Load packages (safely)
loaded_pkgs <- vapply(.pkgs, function(p) {
  suppressWarnings(suppressPackageStartupMessages(require(p, character.only = TRUE)))
}, logical(1))

if (any(!loaded_pkgs)) {
  warning("Packages failed to load: ", paste(names(loaded_pkgs)[!loaded_pkgs], collapse = ", "))
}

# 4b. Load optional packages (no auto-install, warning only)
loaded_opt <- vapply(.pkgs_optional, function(p) {
  suppressWarnings(suppressPackageStartupMessages(require(p, character.only = TRUE, quietly = TRUE)))
}, logical(1))

if (any(!loaded_opt)) {
  message("Optional packages not available (install manually): ",
          paste(names(loaded_opt)[!loaded_opt], collapse = ", "))
}

# 5. Shared hooks / global objects
if (exists("hook_webgl")) knit_hooks$set(webgl = hook_webgl)

# 5b. Ensure bookdown loaded for theorem handling
if (!pkg_available("bookdown")) {
  try(install.packages("bookdown"))
}
suppressWarnings(suppressPackageStartupMessages(require(bookdown)))

# 5c. Register a lightweight knitr engine for 'theorem' chunks used historically like ```{theorem label}
knitr::knit_engines$set(theorem = function(options) {
  # options$label carries chunk label, options$name may hold a display name if provided via name=.
  lab <- options$label
  name <- options$name %||% lab
  # Treat content inside chunk as markdown (if any). Most of your theorem chunks appear empty with text right inside.
  body <- options$code
  # Wrap as a bookdown theorem block using fenced div syntax.
  # If empty body, return placeholder.
  if (length(body) == 0) body <- c("(內容缺失)")
  c(sprintf("::: {.theorem #%s}", lab), sprintf("**%s.**", name), body, ":::")
})

# 6. Engine paths (wrap platform detection)
set_stata_path <- function() {
  paths <- c(
    # Windows 64 typical
    "C:/Program Files/Stata17/StataSE-64.exe",
    "C:/Program Files/Stata16/StataSE-64.exe",
    "C:/Program Files (x86)/Stata15/Stata-64.exe",
    # macOS bundle
    "/Applications/Stata/StataSE.app/Contents/MacOS/stata-se",
    # Linux examples
    "/usr/local/stata17/stata-se",
    "/usr/local/stata16/stata-se"
  )
  existing <- paths[file.exists(paths)]
  if (length(existing)) return(existing[1])
  return(NA_character_)
}

.statapath <- set_stata_path()
if (!is.na(.statapath)) {
  knitr::opts_chunk$set(engine.path = list(stata = .statapath))
}

# 7. Define bugpath (project root) consistently
if (!exists("bugpath", inherits = FALSE)) {
  bugpath <- normalizePath(getwd(), winslash = "/", mustWork = FALSE)
}

# 8. Helper to build absolute path inside project
proj_path <- function(...) file.path(bugpath, ...)

# 9. Quiet confirmation message for standalone chapter renders
if (interactive()) message("[global_setup] Loaded packages: ", sum(loaded_pkgs), " / ", length(loaded_pkgs))

# Export key status objects for downstream diagnostic use (into user global env)
try(list2env(list(pkg_status = pkg_status,
         loaded_pkgs = loaded_pkgs,
         bugpath = bugpath),
       envir = globalenv()), silent = TRUE)

invisible(TRUE)
