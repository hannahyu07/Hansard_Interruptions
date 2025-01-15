#### Preamble ####
# Purpose: Simulates a dataset of Australian parliament speakers' speeches. 
# Author: Hannah Yu
# Date: 13 January 2025
# Contact: realhannah.yu@mail.utoronto.ca
# License: MIT
# Pre-requisites: The `tidyverse` package must be installed
# Any other information needed? Make sure you are in the `starter_folder` rproj

#### Workspace setup ####
library(tidyverse)
library(dplyr)
set.seed(853)


#### Simulate data ####
# Create a simulated dataset
data <- tibble(
  speaker_id = 1:100,  # Speaker numbers from 1 to 100
  interject = rbinom(100, 1, 0.3),  # Dummy variable for interjection (30% probability)
  gender = sample(c("Male", "Female"), 100, replace = TRUE),  # Randomly assign gender
  chamber = sample(c("House of Representatives", "Federation Chamber"), 100, replace = TRUE),  # Randomly assign chamber
  first_speech = rbinom(100, 1, 0.2),  # Dummy for first speech (20% probability)
  date = sample(seq(as.Date('1998-01-01'), as.Date('2022-12-31'), by="day"), 100, replace = TRUE),  # Random dates between 1998 and 2022
  party = sample(c("ALP", "LP", "Nats", "NP", "Other"), 100, replace = TRUE),  # Randomly assign party
  year = sample(1998:2022, 100, replace = TRUE)  # Randomly assign year from 1998 to 2022
)

#### Save data ####
write_csv(data, "data/00-simulated_data/simulated_data.csv")
