parent_dir <- dir("../", full.names = TRUE)
package <- parent_dir[grepl("mlflow_", parent_dir)]
install.packages(package)

mlflow:::mlflow_maybe_create_conda_env(python_version = "3.6")
library(reticulate)
use_condaenv(mlflow:::mlflow_conda_env_name())
# pinning tensorflow version to 1.14 until test_keras_model.R is fixed
keras::install_keras(method = "conda", envname = mlflow:::mlflow_conda_env_name(), tensorflow="1.15.2")
reticulate::conda_install(Sys.getenv("MLFLOW_HOME", "../../../../."), envname = mlflow:::mlflow_conda_env_name(), pip = TRUE)
reticulate::conda_install("xgboost", envname = mlflow:::mlflow_conda_env_name())

# TODO(harupy): Add `error_on = "note"` once the issue below has been fixed:
# https://stackoverflow.com/questions/63613301/r-cmd-check-note-unable-to-verify-current-time/63616156#63616156
devtools::check_built(path = package, args = "--no-tests")
source("testthat.R")
