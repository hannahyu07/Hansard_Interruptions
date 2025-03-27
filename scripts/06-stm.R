#### Preamble ####
# Purpose: Models
# Author: Rohan Alexander, Hannah Yu
# Date: 5 Febuary 2025
# Contact: rohan.alexander@utoronto.ca, realhannah.yu@mail.utoronto.ca
# License: MIT
# Pre-requisites: 
# - 02-download_data.R must have been run
# - 03-clean_data.R must have been run

+++
#### Workspace setup ####
library(tidyverse)
library(quanteda)
library(stm)
library(lubridate)
library(reticulate)

#### Read data ####
hansard_corpus <- read_parquet("data/02-analysis_data/cleaned_data.parquet")


# Filter by year (2020) and remove missing party values
hansard_subset <- hansard_corpus %>%
  filter(year == 2020) %>%   # Select only 2020 speeches
  filter(!is.na(party)) %>%  # Remove rows where `party` is NA
  select(name, body, gender, party)  # Keep only relevant columns

# Ensure text is character format
hansard_subset$body <- as.character(hansard_subset$body)

# Remove empty speeches
hansard_subset <- hansard_subset[nchar(hansard_subset$body) > 0, ]

# Check final dataset size
cat("Final rows in hansard_subset:", nrow(hansard_subset), "\n")


# Convert text column to character format
hansard_subset$body <- as.character(hansard_subset$body)

# Create a corpus from the filtered dataset
hansard_corpus <- corpus(hansard_subset, text_field = "body")

# Ensure sizes match before tokenization
cat("Rows in hansard_subset:", nrow(hansard_subset), "\n")
cat("Texts in corpus:", length(as.character(hansard_corpus)), "\n")

# Tokenization
hansard_tokens <- tokens(hansard_corpus, remove_punct = TRUE, remove_numbers = TRUE) %>%
  tokens_remove(stopwords("en"))

# Create document-feature matrix (DFM)
dfm_hansard <- dfm(hansard_tokens)

# Check document count in the matrix
cat("Documents in dfm_hansard:", nrow(dfm_hansard), "\n")

# Identify non-empty documents
valid_docs <- rowSums(dfm_hansard) > 0  # TRUE for valid, FALSE for empty

# Apply filtering to both `dfm_hansard` and `hansard_subset`
dfm_hansard <- dfm_hansard[valid_docs, ]
hansard_subset <- hansard_subset[valid_docs, ]

# Final check
cat("Filtered hansard_subset:", nrow(hansard_subset), "\n")
cat("Filtered dfm_hansard:", nrow(dfm_hansard), "\n")
# Convert to STM format
hansard_stm <- convert(dfm_hansard, to = "stm")

# Run STM Model
stm_model <- stm(documents = hansard_stm$documents, 
                 vocab = hansard_stm$vocab, 
                 K = 10,  
                 prevalence = ~ gender + party,  
                 data = hansard_subset,  
                 max.em.its = 50)


# Save the STM model to an RDS file
saveRDS(stm_model, file = "models/hansard_topics.rda")




# Create hansard subset dataset 

hansard_subset <- hansard_corpus %>%
  filter(year == 2020) %>%
  filter(!is.na(party)) %>%
  filter(!is.na(gender)) %>%
  filter(body != "")  # Remove empty speeches

# Save hansard subset
saveRDS(hansard_subset, file = here::here("C:/Users/35911/Downloads/Hansard_Interruptions/models/hansard_subset.rds"))





# BERTopic 

bertopic <- import("bertopic")
# Ensure 'body' column is character format
documents <- as.character(hansard_subset$body)


# Create BERTopic model
topic_model <- bertopic$BERTopic()

# Fit BERTopic model and store results in a list
results <- topic_model$fit_transform(documents)

# Extract topics and probabilities separately
topics <- results[[1]]  # First value: Topic assignments
probs <- results[[2]]   # Second value: Topic probabilities



# Save the full BERTopic model
saveRDS(topic_model, file = "models/bertopic_model.rds")





#### Read full dataset ####
hansard_corpus <- read_parquet("data/02-analysis_data/cleaned_data.parquet")

# Define years to loop through
years <- unique(hansard_corpus$year)  # Get all available years

# Loop over each year
for (yr in years) {
  
  cat("Processing Year:", yr, "\n")  # Print progress
  
  # Filter speeches for the specific year
  hansard_subset <- hansard_corpus %>%
    filter(year == yr) %>%   
    filter(!is.na(party)) %>%  
    select(name, body, gender, party)  
  
  # Ensure text is character format
  hansard_subset$body <- as.character(hansard_subset$body)
  
  # Remove empty speeches
  hansard_subset <- hansard_subset[nchar(hansard_subset$body) > 0, ]
  
  # Create a corpus
  hansard_corpus_year <- corpus(hansard_subset, text_field = "body")
  
  # Tokenization
  hansard_tokens <- tokens(hansard_corpus_year, remove_punct = TRUE, remove_numbers = TRUE) %>%
    tokens_remove(stopwords("en"))
  
  # Create document-feature matrix (DFM)
  dfm_hansard <- dfm(hansard_tokens)
  
  # Filter out empty documents
  valid_docs <- rowSums(dfm_hansard) > 0
  dfm_hansard <- dfm_hansard[valid_docs, ]
  hansard_subset <- hansard_subset[valid_docs, ]
  
  # Convert to STM format
  hansard_stm <- convert(dfm_hansard, to = "stm")
  
  # Run STM Model for the current year
  stm_model <- stm(documents = hansard_stm$documents, 
                   vocab = hansard_stm$vocab, 
                   K = 10,  
                   prevalence = ~ gender + party,  
                   data = hansard_subset,  
                   max.em.its = 50)
  
  # Save each model separately
  saveRDS(stm_model, file = paste0("models/hansard_topics_", yr, ".rda"))
}

cat("All models processed and saved.\n")

