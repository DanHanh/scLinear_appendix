

## First create/restore renv

#renv::init() ## choose 1: Restore the project from the lockfile.

## create a venv to beused for the project

#reticulate::conda_create(envname =  "./renv/reticulate", python_version = "3.9")

#renv::use_python(type = "conda", python = "./renv/reticulate/bin/python3.9", name = "./renv/reticulate") 
Sys.setenv(RETICULATE_PYTHON = "./renv/reticulate/bin/python")
Sys.unsetenv("RETICULATE_PYTHON")
reticulate::use_condaenv(condaenv = "./renv/reticulate/bin/python", required = TRUE)
#renv::restore()

## install scLinear (needs to be downloaded from github)
## donwload zip file from github
## extract zip file
## install with
remove.packages("scLinear")
library(devtools)
#devtools::install("./local/scLinear-main", dependencies = TRUE)
## directly install from github
devtools::install_github("DanHanh/scLinear")

## if some packages fail to install try to update the channles
# reticulate::conda_update()

library(scLinear)
reticulate::py_module_available("numpy")
reticulate::py_module_available("sklearn")
reticulate::py_module_available("joblib")
reticulate::py_module_available("anndata")
reticulate::py_module_available("torch")
reticulate::py_module_available("scanpy")

## print all functions of scLinear
print(ls("package:scLinear", all.names = TRUE))


pipe <- create_adt_predictor()
