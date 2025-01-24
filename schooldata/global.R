library(shiny)
library(tidyverse)
library(glue)
library(readxl)
library(bslib)

# read in school district data
# districts <- read_csv('data/districts.csv', show_col_types = FALSE) |> 
#   filter(system_name != 'State of Tennessee')

school_testing = read_excel('data/tn_state_data.xlsx', na="NA") |> 
  filter(subgroup == 'All Students' & grade == 'All Grades' & str_detect(school_name, "High School")) |> 
  filter(!str_detect(school_name, 'Junior'))
