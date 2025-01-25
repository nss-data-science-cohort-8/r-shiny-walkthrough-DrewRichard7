library(shiny)
library(tidyverse)
library(DT)
library(glue)
library(bslib)
library(plotly)
library(shinyjs)

# import data
gdp_le <- read_csv('data/gdp_le.csv')
