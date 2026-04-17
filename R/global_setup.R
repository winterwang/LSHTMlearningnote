# Global setup for LSHTMlearningnote bookdown project
# Centralizes package loading and shared options so chapters can knit standalone.
#
# Package management strategy (updated 2026-04-16):
#   Uses {pak} for all installation — parallel resolver, global cache, unified API
#   for CRAN / Bioconductor / GitHub packages.
#   Manual prerequisites:  brew install jags   (for Ch12 rjags/R2jags/runjags)
#   To install ALL deps from scratch, run: source("R/install_deps.R")

# 1. Core options
options(
  htmltools.dir.version = FALSE,
  formatR.indent = 2,
  width = 100,
  digits = 4,
  rgl.useNULL = TRUE
)

# 2. Package lists
# ---- 2a. Core CRAN packages (auto-installed via pak if missing) ----
.pkgs_cran <- c(
  # authoring / formatting
  "knitr", "kableExtra", "kfigr", "stargazer",
  # data wrangling (plyr MUST load before tidyverse to avoid dplyr masking)
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
# NOTE: Removed deprecated/archived packages:
#   binomTools  -> replaced by binom
#   LogisticDx  -> replaced by generalhoslem (Hosmer-Lemeshow test)
#   uwIntroStats -> removed (use base R / Hmisc)

# ---- 2b. Optional packages (toolchain-dependent; skip gracefully if missing) ----
# Prerequisites:  brew install jags     (for rjags/R2jags/runjags)
#                 rstan + C++ toolchain  (for rethinking)
#                 install_github("rmcelreath/rethinking") after rstan
#                 BiocManager / pak bioc:: prefix for limma
.pkgs_optional <- c(
  "rjags", "R2jags", "runjags",   # Ch12: JAGS models (requires: brew install jags)
  "rethinking",                    # Ch08: McElreath SR2 (requires: rstan)
  "mcmcplots", "ggthemr",          # visualization extras
  "limma"                          # Ch10: PCA (Bioconductor)
)

# 3. Install missing CRAN packages via pak
pkg_available <- function(p) nzchar(system.file(package = p))

if (!pkg_available("pak")) {
  install.packages("pak", repos = "https://cloud.r-project.org")
}

.install_missing_pak <- function(pkgs) {
  missing <- pkgs[!vapply(pkgs, pkg_available, logical(1))]
  if (length(missing)) {
    message("Installing missing CRAN packages via pak: ", paste(missing, collapse = ", "))
    pak::pkg_install(missing, ask = FALSE)
  }
}

.install_missing_pak(.pkgs_cran)

# Ensure V8 dependency for dagitty
if (!pkg_available("V8")) {
  try(pak::pkg_install("V8", ask = FALSE))
  if (!pkg_available("V8")) warning("V8 still missing; 'dagitty' may fail to load.")
}

# 4. Load core packages (safely)
loaded_pkgs <- vapply(.pkgs_cran, function(p) {
  suppressWarnings(suppressPackageStartupMessages(require(p, character.only = TRUE)))
}, logical(1))

if (any(!loaded_pkgs)) {
  warning("Packages failed to load: ", paste(names(loaded_pkgs)[!loaded_pkgs], collapse = ", "))
}

# 4b. Load optional packages (no auto-install, warn only)
loaded_opt <- vapply(.pkgs_optional, function(p) {
  suppressWarnings(suppressPackageStartupMessages(require(p, character.only = TRUE, quietly = TRUE)))
}, logical(1))

if (any(!loaded_opt)) {
  message("Optional packages not available: ",
          paste(names(loaded_opt)[!loaded_opt], collapse = ", "))
}

# ── 4c. brms / Bayesian modelling ecosystem ──
# Required for Ch06–Ch16 (Statistical Rethinking migration to brms)
.pkgs_bayes <- c("brms", "tidybayes", "posterior", "bayesplot")
.install_missing_pak(.pkgs_bayes)
loaded_bayes <- vapply(.pkgs_bayes, function(p) {
  suppressWarnings(suppressPackageStartupMessages(require(p, character.only = TRUE)))
}, logical(1))
if (any(!loaded_bayes)) {
  message("Bayesian packages not available: ",
          paste(names(loaded_bayes)[!loaded_bayes], collapse = ", "))
}

# SDK workaround for macOS 26 beta (Stan C++ compilation needs cmath)
if (Sys.info()[["sysname"]] == "Darwin") {
  .sdk <- "/Library/Developer/CommandLineTools/SDKs/MacOSX15.4.sdk"
  if (dir.exists(.sdk)) Sys.setenv(SDKROOT = .sdk)
}

# ── 4d. rethinking compatibility shims ──
# Lightweight base-R replacements for rethinking plotting helpers.
# Defined once here; per-chapter guard (`if (!exists("PI"))`) prevents duplication.
if (!exists("PI", mode = "function")) {
  rangi2    <- "#4e79a7"
  col.alpha <- function(col, alpha = 0.5) adjustcolor(col, alpha.f = alpha)
  dens      <- function(x, adj = 0.5, ...) {
    args <- list(...)
    add  <- isTRUE(args$add); args$add <- NULL
    d    <- density(x, adjust = adj)
    if (add) {
      line_args <- args[!names(args) %in%
        c("xlab","ylab","main","bty","xlim","ylim","axes","frame.plot")]
      do.call(lines, c(list(d$x, d$y), line_args))
    } else {
      if (!"main" %in% names(args)) args$main <- ""
      do.call(plot, c(list(d), args))
    }
    invisible(d)
  }
  PI        <- function(x, prob = 0.89) {
    a <- (1 - prob) / 2; quantile(x, probs = c(a, 1 - a), na.rm = TRUE)
  }
  shade     <- function(object, lim, col = col.alpha("black", 0.15), ...) {
    if (is.matrix(object)) {
      polygon(c(lim, rev(lim)), c(object[1, ], rev(object[2, ])),
              col = col, border = NA, ...)
    } else {
      polygon(c(lim[1], lim[1], lim[2], lim[2]),
              c(object[1], object[2], object[2], object[1]),
              col = col, border = NA, ...)
    }
  }
  concat    <- paste0
  inv_logit <- plogis
  logit     <- qlogis
  dbern     <- function(x, prob, log = FALSE) dbinom(x, size = 1, prob = prob, log = log)
  grau      <- function(alpha = 0.3) col.alpha("black", alpha)
  normalize <- function(x) (x - min(x)) / (max(x) - min(x))
  standardize <- function(x) (x - mean(x, na.rm = TRUE)) / sd(x, na.rm = TRUE)
  rbern     <- function(n, prob = 0.5) rbinom(n, size = 1, prob = prob)
  logistic  <- plogis
  dbeta2    <- function(x, prob, theta, log = FALSE)
    dbeta(x, shape1 = prob * theta, shape2 = (1 - prob) * theta, log = log)
  simplehist <- function(x, lwd = 4, ...) {
    tab <- table(x)
    plot(as.numeric(names(tab)), as.numeric(tab), type = "h",
         lwd = lwd, ylab = "Frequency", ...)
  }
  dordlogit <- function(x, phi = 0, a, log = FALSE) {
    a_ext <- c(-Inf, as.numeric(a), Inf)
    p <- plogis(a_ext[x + 1] - phi) - plogis(a_ext[x] - phi)
    if (log) return(log(p))
    p
  }
  pordlogit <- function(x, phi = 0, a, log = FALSE) {
    a <- c(as.numeric(a), Inf)
    out <- sapply(x, function(k) plogis(a[k] - phi))
    if (!is.matrix(out)) out <- matrix(out, nrow = length(phi))
    if (log) return(log(out))
    out
  }
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
  # Walk up from cwd to find project root (where _bookdown.yml lives)
  .find_root <- function(start = getwd()) {
    d <- normalizePath(start, winslash = "/", mustWork = FALSE)
    while (d != dirname(d)) {
      if (file.exists(file.path(d, "_bookdown.yml"))) return(d)
      d <- dirname(d)
    }
    normalizePath(start, winslash = "/", mustWork = FALSE)
  }
  bugpath <- .find_root()
}

# 8. Helper to build absolute path inside project
proj_path <- function(...) file.path(bugpath, ...)

# 9. DAG plotting helper — adds circles for latent/unobserved nodes
#    (dagitty::plot.dagitty does not draw circles for latent variables)
plot_dag <- function(dag, ...) {
  plot(dag, ...)
  lat <- dagitty::latents(dag)
  if (length(lat) > 0) {
    coords <- dagitty::coordinates(dag)
    for (v in lat) {
      x <- coords$x[v]
      y <- -coords$y[v]  # plot.dagitty negates y
      w <- strwidth(v) + strwidth("xx")
      h <- strheight(v) + strheight("\n")
      r <- max(w, h) / 2
      symbols(x, y, circles = r, add = TRUE, inches = FALSE,
              fg = "black", bg = "white", lwd = 1.5)
      text(x, y, v)
    }
  }
}

# 10. Quiet confirmation message for standalone chapter renders
if (interactive()) message("[global_setup] Loaded packages: ", sum(loaded_pkgs), " / ", length(loaded_pkgs))

# Export key status objects for downstream diagnostic use (into user global env)
try(list2env(list(pkg_status = pkg_status,
         loaded_pkgs = loaded_pkgs,
         bugpath = bugpath),
       envir = globalenv()), silent = TRUE)

invisible(TRUE)
