#### Preamble ####
# Purpose: Cleans the raw data 
# Author: Rohan Alexander Hannah Yu
# Date: 2 12, 2024
# Contact: rohan.alexander@utoronto.ca realhannah.yu@mail.utoronto.ca
# License: MIT
# Pre-requisites: [02-download_data]

#### Workspace setup ####
library(tidyverse)

#### Clean data ####
raw_data <- read_parquet("data/01-raw_data/hansard_corpus_1998_to_2022.parquet")

library(dplyr)
library(tidyr)
library(lubridate)


# Explore the Data
summary(raw_data)
str(raw_data)

# Assuming 'raw_data' is already loaded

# Ensure that 'gender' is treated as a character if it's not already, especially if it's a factor
raw_data <- raw_data %>%
  mutate(
    gender = as.character(gender),  # Convert factor to character to handle empty strings correctly
    gender = if_else(is.na(gender) | gender == "", "Unknown", gender)  # Replace NA and empty strings
  )

raw_data <- raw_data %>%
  mutate(
    # Convert 'interject' to numeric without changing NA values
    interject = as.numeric(as.character(interject)),  # Ensure 'interject' is numeric, keep NA as is
    # Correct date format and handle potential date issues
    date = as.Date(date, format="%Y-%m-%d")
  )


# Correct Data Types
# Convert interject from factor/character to numeric if it's not already
raw_data <- raw_data %>%
  mutate(
    interject = as.numeric(interject),
    year = year(date)  # Extract year from date for yearly analysis
  )

hansard_corpus$question <- as.numeric(as.character(hansard_corpus$question))


# Error Checks
# Example: Check for any anomalous entries in 'gender' or other crucial fields
table(raw_data$gender)  # Should only contain known categories



#### Save data ####
write_parquet(raw_data, "data/02-analysis_data/cleaned_data.parquet")
