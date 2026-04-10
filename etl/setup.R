# ======================================================================
# setup.R
# Shared setup for FAMCare-Child-Documents ETL + Quarto reporting
# - Loads core libraries
# - Sets global options
# - Sources helper modules (helpers, fiscal_dates, cartography)
# ======================================================================

## 1. Core libraries used across modules --------------------------------
library(here)
library(kableExtra)
library(dplyr)
library(readr)
library(readxl)
library(tidyr)
library(tibble)
library(forcats)
library(stringr)
library(lubridate)
library(purrr)
library(ggplot2)
library(janitor)
library(sf)
library(tigris)

## 2. Global options -----------------------------------------------------
options(
  tigris_use_cache = TRUE,
  tigris_class = "sf"
)

## 3. Source internal helper modules ------------------------------------
# Assume this file lives in etl/ and helpers live in ../R/

root <- here::here()  # project root of FAMCare-Child-Documents

source(
  file.path(
    root,
    "R",
    "helpers.R"
  )
)
source(
  file.path(
    root,
    "R",
    "fiscal_dates.R"
  )
)
source(
  file.path(
    root,
    "R",
    "cartography.R"
  )
)

# ======================================================================
# END OF SETUP
# ======================================================================
