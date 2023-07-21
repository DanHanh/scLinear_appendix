

## First create/restore renv

#renv::init() ## choose 1: Restore the project from the lockfile.

## create a venv to beused for the project

reticulate::virtualenv_create(envname = "./renv/virtualenvs/scLinear_code/bin/python")
renv::use_python(type = "virtualenv", python = "./renv/virtualenvs/scLinear_code/bin/python/bin/python3.9") ## chose the venv to use (path/scLinear_venv)
 Sys.setenv(RETICULATE_PYTHON = "./renv/virtualenvs/scLinear_code/bin/python")
 Sys.unsetenv("RETICULATE_PYTHON")
reticulate::use_virtualenv(virtualenv = "./renv/virtualenvs/scLinear_code/bin/python", required = TRUE)
#renv::restore()


## install scLinear (needs to be downloaded from github)
## donwload zip file from github
## extract zip file
## install with
remove.packages("scLinear")
library(devtools)
devtools::install("./local/scLinear-main", dependencies = TRUE)

library(scLinear)
reticulate::py_module_available("scanpy")
reticulate::py_module_available("numpy")
reticulate::py_module_available("sklearn")
reticulate::py_module_available("joblib")
reticulate::py_module_available("anndata")
reticulate::py_module_available("torch")


## print all functions of scLinear
print(ls("package:scLinear", all.names = TRUE))


pipe <- create_adt_predictor()