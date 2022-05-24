# code/002-excel_parsing
#
# Notes:
#
# This script demonstrates how to parse
# an excel file with multiple worksheets into a
# well-ordered tibble ready for use in tidyverse
# workflows.
#
# features: 
#  - map, map2
#  - list columns
#  - unnest



# Load libraries
library(readxl)    # read excel files
library(dplyr)     # manipulate tibbles
library(ggplot2)   # plotting
library(purrr)     # functional programming
library(tibble)    # enhanced dataframes
library(tidyr)     # tidy messy data


# Declare where expense reports are stored
expense_dir <- "data/xlsx"


# Create tibble with file paths to expense reports
expense_tbl <- tibble(
  path = dir(expense_dir, full.names = TRUE)
)


# View data structure
expense_tbl


# Add column with tab names
expense_tbl <- expense_tbl |> 
  mutate(sheet = map(path, excel_sheets)) |> 
  unnest(sheet)


# View data structure
expense_tbl


# Read expenses from each tab
expense_tbl <- expense_tbl |> 
  mutate(
    data = map2(path, sheet, read_excel)
  )


# Add date column to improve plotting
expense_tbl <- expense_tbl |> 
  mutate(
    report_date = as.Date(paste0(sheet, "-01"))
  ) |> 
  select(sheet, report_date, data)


# View data structure
expense_tbl


# Plot simple summary of total expenses per month
expense_tbl |> 
  unnest(data) |> 
  group_by(report_date) |> 
  summarize(
    amount = sum(amount)
  ) |> 
  ggplot(aes(x = report_date, y = amount)) +
  labs(
    title = "Monthly Expenses",
    x = NULL, y = NULL
  ) +
  geom_col()
