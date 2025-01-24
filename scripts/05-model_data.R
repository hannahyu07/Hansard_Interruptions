#### Preamble ####
# Purpose: Models
# Author: Rohan Alexander, Hannah Yu
# Date: 14 January 2025
# Contact: rohan.alexander@utoronto.ca, realhannah.yu@mail.utoronto.ca
# License: MIT
# Pre-requisites: 
# - 02-download_data.R must have been run
# - 03-clean_data.R must have been run



#### Workspace setup ####
library(dplyr)
library(rstanarm)

#### Read data ####s
analysis_data <- read_parquet("data/02-analysis_data/cleaned_data.parquet")

set.seed(853)

sample_data <- analysis_data %>%
  select(interject, gender, party, word_count) %>% # Select only the desired variables
  mutate(
    interject = as.numeric(interject),  # Ensure 'interject' is numeric (binary: 0 or 1)
    gender = as.factor(gender),         # Convert 'gender' to a factor
    party = as.factor(party),           # Convert 'party' to a factor
    word_count = as.numeric(word_count) # Ensure 'word_count' is numeric
  )

# Check the number of rows and columns in the original dataset
original_rows <- nrow(sample_data)
original_cols <- ncol(sample_data)


# Count the number of missing values in the original dataset
na_counts <- sample_data %>%
  summarise_all(~ sum(is.na(.))) %>%
  pivot_longer(everything(), names_to = "Column", values_to = "Missing_Values")

# Total missing values in the dataset
total_na <- sum(na_counts$Missing_Values)
print(total_na)

# Print the original dataset statistics
cat("Original Dataset:\n")
cat("Rows:", original_rows, "\n")
cat("Columns:", original_cols, "\n")
cat("Total Missing Values:", total_na, "\n")
print(na_counts)


# Create interaction variable
sample_data <- sample_data %>%
  mutate(word_count_gender = word_count * as.numeric(gender == "Female")) %>%
  drop_na()

# Check the state of the cleaned dataset
cleaned_rows <- nrow(sample_data)
cleaned_cols <- ncol(sample_data)

# Calculate the number of rows removed due to NA values
rows_removed <- original_rows - cleaned_rows

# Print the cleaned dataset statistics
cat("\nCleaned Dataset:\n")
cat("Rows:", cleaned_rows, "\n")
cat("Columns:", cleaned_cols, "\n")
cat("Rows Removed Due to Missing Values:", rows_removed, "\n")


# Randomly sample 1000 observations from your dataset
sample_data <- sample_data %>% sample_n(1000)

# Fit the logistic regression model using stan_glm
stan_model <- stan_glm(
  interject ~ gender + party + word_count + word_count_gender,  # Formula for the model
  data = sample_data,
  family = binomial(link = "logit"),        # Logistic regression
  prior = normal(0, 2.5),                  # Default prior for coefficients
  prior_intercept = normal(0, 5),          # Default prior for intercept
  chains = 4,                              # Number of Markov chains
  iter = 2000,                             # Number of iterations per chain
  seed = 853                              # Set seed for reproducibility
)


#### Save model ####
saveRDS(
  stan_model,
  file = "models/model1.rds"
)





#### Read data ####s
analysis_data1 <- read_parquet("data/02-analysis_data/cleaned_data.parquet")

set.seed(853)

sample_data1 <- analysis_data1 %>%
  select(interject, gender, word_count) %>% # Select only the desired variables
  mutate(
    interject = as.numeric(interject),  # Ensure 'interject' is numeric (binary: 0 or 1)
    gender = as.factor(gender),         # Convert 'gender' to a factor
    word_count = as.numeric(word_count) # Ensure 'word_count' is numeric
  )


# Count the number of missing values in the original dataset
na_counts <- sample_data1 %>%
  summarise_all(~ sum(is.na(.))) %>%
  pivot_longer(everything(), names_to = "Column", values_to = "Missing_Values")


# Print the original dataset statistics
cat("Original Dataset:\n")
cat("Rows:", original_rows, "\n")
cat("Columns:", original_cols, "\n")
cat("Total Missing Values:", total_na, "\n")
print(na_counts)


# Create interaction variable
sample_data1 <- sample_data1 %>%
  mutate(word_count_gender = word_count * as.numeric(gender == "Female")) %>%
  drop_na()


# Randomly sample 1000 observations from your dataset
sample_data1 <- sample_data1 %>% sample_n(1000)

# Fit the logistic regression model using stan_glm
stan_model1 <- stan_glm(
  interject ~ gender + word_count + word_count_gender,  # Formula for the model
  data = sample_data,
  family = binomial(link = "logit"),        # Logistic regression
  prior = normal(0, 2.5),                  # Default prior for coefficients
  prior_intercept = normal(0, 5),          # Default prior for intercept
  chains = 4,                              # Number of Markov chains
  iter = 2000,                             # Number of iterations per chain
  seed = 853                              # Set seed for reproducibility
)


#### Save model ####
saveRDS(
  stan_model1,
  file = "models/model2.rds"
)





