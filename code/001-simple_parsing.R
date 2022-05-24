# code/001-simple_parsing
#
# Notes:
#
# This script steps through a 



# Load libraries
library(dplyr)     # manipulate tibbles
library(ggplot2)   # plotting
library(purrr)     # functional programming
library(stringr)   # work with strings
library(tibble)    # enhanced dataframes
library(tidyr)     # tidy messy data


# Declare where expense reports are stored
expense_dir <- "data/csv"


# Create tibble with file paths to expense reports
expense_tbl <- tibble(
  path = dir(expense_dir, full.names = TRUE)
)


# Read individual expense reports
expense_tbl <- expense_tbl %>% 
  mutate(data = map(path, read.csv))


# Add convenience columns: 1) identifying reports and
# 2) adding date column to improve plotting
expense_tbl <- expense_tbl %>% 
  mutate(
    report = str_extract(path, "[0-9]{4}-[0-9]{2}"),
    report_date = as.Date(paste0(report, "-01"))
  ) %>% 
  select(report, report_date, data, path)


# View data structure
expense_tbl


# Plot simple summary of total expenses per month
expense_tbl %>% 
  unnest(data) %>% 
  group_by(report_date) %>% 
  summarize(
    amount = sum(amount)
  ) %>% 
  ggplot(aes(x = report_date, y = amount)) +
  labs(
    title = "Monthly Expenses",
    x = NULL, y = NULL
  ) +
  geom_col()
