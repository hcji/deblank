# DeBlank
  This is a package for remove baseline ions from samples based on the blank sampe 
  
## Useage

### Install Depends: 

    options("repos" = c(CRAN="https://mirrors.tuna.tsinghua.edu.cn/CRAN/"))
    options("BioC_mirror" = "http://mirrors.ustc.edu.cn/bioc/")

    install.packages(c("devtools", "plotly", "shiny"))
    source("https://bioconductor.org/biocLite.R")
    biocLite("mzR")

### Install DeBlank:  

    library(devtools);  
    install_github("hcji/deblank")
    
### Run
    
    runApp()
		
