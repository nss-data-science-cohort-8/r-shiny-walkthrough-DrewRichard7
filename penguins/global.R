library(shiny)
library(tidyverse)
library(glue)
library(DT)

penguins <- read_csv('data/penguins.csv')

numeric_variables <- penguins |> 
  select(where(is.numeric), -year) |>  #chooses columns in penguins that are numeric minus the year
  colnames() |> 
  sort()

# Fix titles of numeric variables - used in server output$distPlot
# varname = bill_depth_mm
prepare_title <- function(varname){
  str_split(varname, '_')[[1]][1:2] |> # split on the _ and select the first two (bill, depth)
    paste(collapse = ' ') |>  # puts strings together, collapse says to leave a space
    str_to_title() #capitalizes first letter in each word
}


prepare_x_label <- function(varname){
  paste(
    str_split(varname, "_")[[1]][1:2] |> paste(collapse = " "),
    paste0("(", str_split(varname, "_")[[1]][3], ")") # to get units to show as: (mm)
  )
}