#### Preamble ####
# Purpose: Tests the analysis data
# Author: Rohan Alexander, Hannah Yu
# Date: 14 January 2025
# Contact: rohan.alexander@utoronto.ca, realhannah.yu@mail.utoronto.ca
# License: MIT
# Pre-requisites: 
  # - 00-simulate_data.R must have been run
  # - 01-test_simulated.R must have been run
  # - 02-download_data.R must have been run
  # - 03-clean_data.R must have been run


#### Workspace setup ####
library(testthat)
library(dplyr)
library(readr)
library(lubridate)
library(arrow)


# Load the cleaned data
analysis_data <- read_parquet("data/02-analysis_data/cleaned_data.parquet")

### Define Tests Using testthat ###

# Test for expected number of rows and columns
test_that("dataset has the expected number of rows and columns", {
  expect_true(nrow(analysis_data) > 0)
  expect_true(ncol(analysis_data) >= 5)  # Adjust based on your actual dataset structure
})

# Test for valid gender categories
test_that("gender column contains only valid categories", {
  valid_genders <- c("Male", "Female", "Unknown")
  expect_setequal(unique(analysis_data$gender), valid_genders)
})


# Test for all dates being valid and no future dates
test_that("all dates are valid and no future dates are present", {
  expect_true(all(analysis_data$date <= Sys.Date()))
})

# Test for handling missing values in 'gender' column
test_that("no missing values in the 'gender' column", {
  expect_false(any(is.na(analysis_data$gender)))
})

# Test for data types correctness after mutation
test_that("data types are correct for each column", {
  expect_type(analysis_data$interject, "double")
  expect_type(analysis_data$year, "double")  
  expect_type(analysis_data$gender, "character")  
})


# Test for 'interject' column to ensure numeric conversion
test_that("interject column is numeric", {
  expect_type(analysis_data$interject, "double")  # Checking if interject is double which includes numeric
})



