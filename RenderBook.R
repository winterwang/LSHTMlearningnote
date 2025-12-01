# setwd("~/Downloads/LSHTMlearningnote")
library(rmarkdown)
library(bookdown)
render_book("index.Rmd")

# or serve book 
# serve_book()
 
Sys.setenv(PATH = paste("C:/Users/GQAEC/pandoc", 
            Sys.getenv("PATH"), sep = ";")) # need for pandoc path 

 

# Replace with the chapter you’re auditing
# Single chapter (standalone) – still needs manual source because before_chapter_script is a bookdown feature:


source("R/global_setup.R")
rmarkdown::render("01-Probability.Rmd",
                  output_format = "html_document",
                  output_file = "test-01.html",
                  clean = TRUE)
rmarkdown::render(
  "02-Inference.Rmd",
  output_format = "html_document",
  output_file = "test-02-Inference.html",
  clean = TRUE,
  quiet = FALSE
)

rmarkdown::render(
  "03-Analytic-Technique.Rmd",
  output_format = "html_document",
  output_file  = "test-03-Analytic-Technique.html",
  clean = TRUE,
  quiet = FALSE
)

rmarkdown::render(
  "04-Linear-Regression.Rmd",
  output_format = "html_document",
  output_file  = "test-04-Linear-Regression.html",
  clean = TRUE,
  quiet = FALSE
)


rmarkdown::render(
  "05-clinical-trials.Rmd",
  output_format = "html_document",
  output_file  = "test-05-clincal-trials.html",
  clean = TRUE,
  quiet = FALSE
)
rmarkdown::render(
  "06-RobustStatistic.Rmd",
  output_format = "html_document",
  output_file  = "test-06-RobustStatistics.html",
  clean = TRUE,
  quiet = FALSE
)
rmarkdown::render(
  "08-Intro-to-Bayes.Rmd",
  output_format = "html_document",
  output_file  = "test-08-Intro-to-Bayes.html",
  clean = TRUE,
  quiet = FALSE
)
rmarkdown::render(
  "08-Intro-to-Bayes/Session08.Rmd",
  output_format = "html_document",
  output_file = "test-Session08.html",
  clean = TRUE,
  quiet = FALSE
)

rmarkdown::render(
  "08-Intro-to-Bayes/Session05.Rmd",
  output_format = "html_document",
  output_file = "test-Session05.html",
  clean = TRUE,
  quiet = FALSE
)


clear_session08_cache <- function(){
  targets <- c("Session08_cache",
               "Session08_files",
               "figure",
               "_bookdown_files/Session08_cache",
               "_bookdown_files/Session08_*")
  for (t in targets){
    for (path in Sys.glob(t)){
      if (dir.exists(path)) {
        message("Removing: ", path)
        unlink(path, recursive = TRUE)
      }
    }
  }
  # 清理工作空間 (可選)
  rm(list = ls(envir = .GlobalEnv), envir = .GlobalEnv)
  invisible(TRUE)
}

# 使用：
clear_session08_cache()
rmarkdown::render(
  "08-Intro-to-Bayes/Session08.Rmd",
  output_format = "html_document",
  output_file = "test-Session08.html",
  clean = TRUE,
  quiet = FALSE
)



all_data <- data(package = .packages(all.available = TRUE))$results;

milk_pkgs <- unique(all_data[all_data[, 'Item'] == 'milk', 'Package']);
if (length(milk_pkgs) > 0) {
  cat(paste('Found \\'milk\\' dataset in:', paste(milk_pkgs, collapse=', '), '\\n\\n'));
  for (pkg in milk_pkgs) {
    cat(paste('--- str(milk) from package:', pkg, '---\\n'));
    if (exists('milk')) rm(milk);
    data('milk', package = pkg, envir = environment());
    print(str(milk));
    cat('\\n');
  }
} else {
  cat('No dataset named \\'milk\\' found.\\n');
}


rmarkdown::render(
  "08-Intro-to-Bayes/Session09.Rmd",
  output_format = "html_document",
  output_file = "test-Session09.html",
  clean = TRUE,
  quiet = FALSE
) 

rmarkdown::render(
  "08-Intro-to-Bayes/Session10.Rmd",
  output_format = "html_document",
  output_file = "test-Session10.html",
  clean = TRUE,
  quiet = FALSE
) 
rmarkdown::render(
  "08-Intro-to-Bayes/Session11.Rmd",
  output_format = "html_document",
  output_file = "test-Session11.html",
  clean = TRUE,
  quiet = FALSE
) 
rmarkdown::render(
  "08-Intro-to-Bayes/Session12.Rmd",
  output_format = "html_document",
  output_file = "test-Session12.html",
  clean = TRUE,
  quiet = FALSE
) 
rmarkdown::render(
  "08-Intro-to-Bayes/Session13.Rmd",
  output_format = "html_document",
  output_file = "test-Session13.html",
  clean = TRUE,
  quiet = FALSE
) 
rmarkdown::render(
  "08-Intro-to-Bayes/Session1401.Rmd",
  output_format = "html_document",
  output_file = "test-Session1401.html",
  clean = TRUE,
  quiet = FALSE
) 
