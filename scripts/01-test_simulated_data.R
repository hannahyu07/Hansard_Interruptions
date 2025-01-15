#### Preamble ####
# Purpose: Tests the structure and validity of the simulated Australian 
  #electoral divisions dataset.
# Author: Hannah Yu
# Date: 14 January 2025
# Contact: realhannah.yu@mail.utoronto.ca
# License: MIT
# Pre-requisites: 
  # - The `tidyverse` package must be installed and loaded
  # - 00-simulate_data.R must have been run
# Any other information needed? Make sure you are in the `starter_folder` rproj


#### Workspace setup ####
library(tidyverse)


#### Load data for testing ####
analysis_data <- read_csv("data/00-simulated_data/simulated_data.csv")

# Test if the data was successfully loaded
if (exists("analysis_data")) {
  message("Test Passed: The dataset was successfully loaded.")
} else {
  stop("Test Failed: The dataset could not be loaded.")
}

# Check if the dataset has 100 rows
if (nrow(analysis_data) == 100) {
  message("Test Passed: The dataset has 100 rows.")
} else {
  stop("Test Failed: The dataset does not have 100 rows.")
}

# Check if the dataset has 8 columns
if (ncol(analysis_data) == 8) {
  message("Test Passed: The dataset has 8 columns.")
} else {
  stop("Test Failed: The dataset does not have 8 columns.")
}

# Since there's no 'division' or 'state' column in your dataset, we'll skip those tests

# Check if there are no missing values in the dataset
if (all(complete.cases(analysis_data))) {
  message("Test Passed: The dataset contains no missing values.")
} else {
  stop("Test Failed: The dataset contains missing values.")
}

# Check if there are no empty strings in 'party' and 'chamber' columns
if (all(analysis_data$party != "" & analysis_data$chamber != "")) {
  message("Test Passed: There are no empty strings in 'party' or 'chamber'.")
} else {
  stop("Test Failed: There are empty strings in one or more columns.")
}

# Check if the 'party' column has at least two unique values
if (n_distinct(analysis_data$party) >= 2) {
  message("Test Passed: The 'party' column contains at least two unique values.")
} else {
  stop("Test Failed: The 'party' column contains less than two unique values.")
}