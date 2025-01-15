#### Preamble ####
# Purpose: Models... [...UPDATE THIS...]
# Author: Rohan Alexander, Hannah Yu
# Date: 14 January 2025
# Contact: rohan.alexander@utoronto.ca, realhannah.yu@mail.utoronto.ca
# License: MIT
# Pre-requisites: 
# - 02-download_data.R must have been run
# - 03-clean_data.R must have been run



#### Workspace setup ####
library(tidyverse)
library(rstanarm)

#### Read data ####s
analysis_data <- read_csv("data/analysis_data/analysis_data.csv")

### Model data ####
first_model <-
  stan_glm(
    formula = flying_time ~ length + width,
    data = analysis_data,
    family = gaussian(),
    prior = normal(location = 0, scale = 2.5, autoscale = TRUE),
    prior_intercept = normal(location = 0, scale = 2.5, autoscale = TRUE),
    prior_aux = exponential(rate = 1, autoscale = TRUE),
    seed = 853
  )



# Assuming 'hansard_corpus' is already loaded
# Convert variables to factors
hansard_corpus <- hansard_corpus %>%
  mutate(
    interject = as.factor(interject),  # Ensure 'interject' is a factor for logistic regression
    gender = as.factor(gender),
    party = as.factor(party),
    in.gov = as.factor(in.gov),
    year = as.numeric(format(as.Date(date, format = "%Y-%m-%d"), "%Y"))  # Extract year from date
  )

# Check for any NA values and decide how to handle them
hansard_corpus1 <- na.omit(hansard_corpus)  # This line removes rows with any NA values


# Load the stats package for logistic regression
library(stats)

# Fit logistic regression model
logit_model <- glm(interject ~ gender + year + party + in.gov, data = hansard_corpus1, family = binomial())

# Display the summary of the model
summary(logit_model)

```

#### Save model ####
saveRDS(
  first_model,
  file = "models/first_model.rds"
)


