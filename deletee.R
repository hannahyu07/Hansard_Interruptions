```{r}
#| echo: false
#| warning: false
#| message: false
#| label: fig-compare
#| fig-cap: "Yearly Interruptions Proportions in Australian Parliament by Gender"

# Original dataset, no condition on fedchamb_flag
interruptions_original <- hansard_corpus %>%
  filter(gender %in% c("Male", "Female")) %>%
  mutate(
    date = as.Date(date, format = "%Y-%m-%d"),
    year = if_else(is.na(date), NA_integer_, year(date))
  ) %>%
  group_by(year, gender) %>%
  summarise(
    total_interruptions = sum(interject, na.rm = TRUE),
    total_speeches = n(),
    .groups = 'drop'
  ) %>%
  mutate(
    interruption_proportion = total_interruptions / total_speeches,
    condition = "All Data"
  )

# Dataset with fedchamb_flag == 0
interruptions_fedchamb_flag_0 <- hansard_corpus %>%
  filter(gender %in% c("Male", "Female"), fedchamb_flag == 0) %>%
  mutate(
    date = as.Date(date, format = "%Y-%m-%d"),
    year = if_else(is.na(date), NA_integer_, year(date))
  ) %>%
  group_by(year, gender) %>%
  summarise(
    total_interruptions = sum(interject, na.rm = TRUE),
    total_speeches = n(),
    .groups = 'drop'
  ) %>%
  mutate(
    interruption_proportion = total_interruptions / total_speeches,
    condition = "fedchamb_flag = 0"
  )

# Combine the datasets
final_data3 <- bind_rows(interruptions_original, interruptions_fedchamb_flag_0)

# Adjust labels for condition and linetype
ggplot(final_data3, aes(x = year, y = interruption_proportion, color = gender, linetype = condition)) +
  geom_line(size = 1.2) +
  geom_point(size = 2) +
  labs(
    title = "Yearly Interruptions Proportions in\nAustralian Parliament by Gender",
    subtitle = "Comparing All Data vs. Chamber Data Only",
    x = "Year",
    y = "Interruption Proportion",
    color = "Gender",
    linetype = "Dataset Type"
  ) +
  scale_color_brewer(palette = "Set2") +
  scale_linetype_manual(values = c("solid", "dotted"), 
                        labels = c("All", "Chamber")) +
  theme_minimal(base_size = 14) +
  theme(
    legend.position = "top",
    legend.title = element_text(size = 10, face = "bold"),
    legend.text = element_text(size = 8),
    plot.title = element_text(size = 14, face = "bold", hjust = 0.5),
    plot.subtitle = element_text(size = 12, face = "italic", hjust = 0.5),
    axis.title = element_text(size = 12),
    axis.text = element_text(size = 11)
  ) +
  scale_x_continuous(breaks = seq(min(final_data3$year), max(final_data3$year), by = 5))  # Adjust x-axis breaks





```

5. Boxplot of Interruption Frequency by Speaker

```{r}
# Load required library
library(dplyr)
library(ggplot2)

# Filter top 20 speakers with the most speeches and calculate interruption rate
top_speakers <- analysis_data %>%
  group_by(name, gender) %>%
  summarise(
    speech_count = n(),                    # Count the total number of speeches
    interruption_rate = mean(interject)   # Calculate the interruption rate
  ) %>%
  arrange(desc(speech_count)) %>%          # Sort by the number of speeches
  slice_head(n = 20)                       # Select the top 20 speakers


# Plotting the interruption rate for the top 20 speakers
ggplot(top_speakers, aes(x = reorder(name, interruption_rate), y = interruption_rate, fill = gender)) +
  geom_col() +
  coord_flip() +
  scale_fill_manual(values = c("Female" = "pink", "Male" = "blue")) +
  labs(
    title = "Interruption Rate by Speaker (Top 20 Speakers)",
    x = "Speaker",
    y = "Interruption Rate",
    fill = "Gender"
  ) +
  theme_minimal()

```


Only analyzing Chamber members, @fig-2_chamber again illustrates interruptions in the Australian Parliament from 1998 to 2022, categorized by gender. To distinguish the differences across the two figures, @fig-compare contains both the interruptions for all data and Chamber member data. While the interruption patterns in the chamber-only data in @fig-2_chamber largely mirror those observed in the comprehensive dataset @fig-2, there are slight increases in the interruption proportions for women, indicating a potentially heightened level of disruption experienced by female members in non-federal chambers.


```{r}
#| echo: false
#| warning: false
#| message: false
#| label: fig-gov5
#| fig-cap: "Gender-Based Interruptions and Word Count"
# Bar plot for total speeches with real numbers on the y-axis
ggplot(summary_table, aes(x = gender, y = average_words, fill = factor(interject))) +
  geom_bar(stat = "identity", position = "dodge") +
  scale_fill_manual(values = c("steelblue", "salmon"), labels = c("No", "Yes")) +
  scale_y_continuous(labels = scales::comma) +  # Display real numbers on the y-axis
  labs(
    title = "Gender-Based Interruptions and Word Count",
    x = "Gender",
    y = "Total Speeches",
    fill = "Interruption"
  ) +
  theme_minimal(base_size = 14) +
  theme(
    legend.position = "top",
    plot.title = element_text(size = 14, face = "bold", hjust = 0.5),
    axis.title = element_text(size = 12),
    axis.text = element_text(size = 10)
  )

```
