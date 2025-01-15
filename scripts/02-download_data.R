#### Preamble ####
# Purpose: Downloads and saves the data from Zenodo
# Author: Hannah Yu, Rohan Alexander
# Date: 11 November 2024
# Contact: realhannah.yu@mail.utoronto.ca
# License: MIT


#### Workspace setup ####
library(tidyverse)
library(arrow)  # For handling Parquet files

#### Download data ####


# Install and load necessary package
if (!require("curl")) install.packages("curl")
library(curl)

# URL of the data file
url <- "https://zenodo.org/records/8121950/files/hansard-corpus.zip?download=1"

# Define the destination file name
destfile <- "data/01-raw_data/Hansard_Corpus_1998_to_2022.zip"

# Set options for a longer timeout (e.g., 10 minutes)
options(timeout = 3000) 

# Use curl_download for more robust handling of large files
curl_download(url, destfile)

# Check if the file has been downloaded and then unzip
if (file.exists(destfile)) {
  unzip(destfile)
  # Assuming the unzip contains files in a format to be converted to parquet
  # You would need additional steps here if your data needs processing before saving it as parquet
  # Assuming 'the_raw_data' is a dataframe loaded from the unzipped files
  write_parquet(hansard_corpus, "data/01-raw_data/hansard_corpus.parquet") 
} else {
  message("File download failed, please check the URL or network settings.")
}





