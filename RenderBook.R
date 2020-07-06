library(rmarkdown)
library(bookdown)
render_book("index.Rmd")

# or serve book 
serve_book()

bookdown::render_book("index.Rmd", "bookdown::gitbook")
bookdown::render_book("index.Rmd", "bookdown::pdf_book")