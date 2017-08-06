local({r <- getOption("repos")
       r["CRAN"] <- "http://cran.r-project.org" 
       options(repos=r)
})

install.packages('devtools')
devtools::install_github('IRkernel/IRkernel')
IRkernel::installspec(user = FALSE)
