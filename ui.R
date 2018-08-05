library(shiny)
library(ggplot2)
library(readxl)
library(dplyr)


shinyUI(navbarPage("Church Stats", 
  tabPanel("All Churches", {
    
    fluidPage(
      mainPanel(
        tabsetPanel(
          tabPanel("Growing Denominations", {
            tableOutput("growing_denoms")  
          }),
          tabPanel("Shrinking Denominations", {
            tableOutput("shrinking_denoms")    
          })
        )
      )
    )
  })                   ,
  tabPanel("Individual Church", {

    fluidPage(
      
      sidebarPanel(
        uiOutput('denomination_selector')
      ),
      mainPanel(
        plotOutput('church_stats')
      )
    )
    
  })
))

