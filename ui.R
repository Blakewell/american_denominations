library(shiny)
library(ggplot2)
library(readxl)
library(dplyr)

fluidPage(
  
  titlePanel("Church Denominations in Decline"),
  sidebarPanel(
    uiOutput('denomination_selector')
  ),
  mainPanel(
    plotOutput('church_stats')
  )
)
