#### Preamble ####
# Purpose: Cleans the raw data 
# Author: Rohan Alexander, Hannah Yu
# Date: 2 October, 2024
# Contact: rohan.alexander@utoronto.ca, realhannah.yu@mail.utoronto.ca
# License: MIT
# Pre-requisites: [02-download_data]

#### Workspace setup ####
library(tidyverse)
library(dplyr)
library(tidyr)
library(lubridate)
#### Clean data ####
raw_data <- read_parquet("data/01-raw_data/hansard_corpus.parquet")

raw_data <- raw_data %>%
  mutate(
    gender = as.character(gender),  # Ensure it's a character
    gender = if_else(is.na(gender) | gender == "", "Unknown", gender),  # Replace NA and empty strings with "Unknown"
    gender = case_when(  # Capitalize the values
      str_to_lower(gender) == "male" ~ "Male",
      str_to_lower(gender) == "female" ~ "Female",
      str_to_lower(gender) == "unknown" ~ "Unknown",
      TRUE ~ gender  # Retain other values if present
    )
  )

raw_data <- raw_data %>%
  mutate(
    # Convert 'interject' to numeric without changing NA values
    interject = as.numeric(as.character(interject)),  # Ensure 'interject' is numeric, keep NA as is
    # Correct date format and handle potential date issues
    date = as.Date(date, format="%Y-%m-%d")
  )

# Correct Data Types
raw_data <- raw_data %>%
  mutate(
    interject = as.numeric(interject),
    year = year(date)  # Extract year from date for yearly analysis
  )

hansard_corpus$question <- as.numeric(as.character(hansard_corpus$question))

# Filter for only Chamber data and create word count
raw_data <- raw_data %>%
  filter(fedchamb_flag == 0) %>%
  mutate(word_count = str_count(body, "\\b\\w+\\b"))

# Error Checks
table(raw_data$gender)  # Should only contain known categories



#### Save data ####
write_parquet(raw_data, "data/02-analysis_data/cleaned_data.parquet")
