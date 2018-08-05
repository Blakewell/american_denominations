library(shiny)
library(ggplot2)
library(dplyr)

function(input, output) {
  
  full_dataset <- read_xlsx("data/church_stats.XLSX")
  
  #minimize dataset
  dataset <- full_dataset[c("YEAR", "STATEAB", "GRPCODE", "GRPNAME", "ADHERENT")] %>%
                group_by(GRPNAME, YEAR) %>% 
                summarize(TOTAL = sum(ADHERENT)) %>%
                mutate(FIRST_YEAR = first(YEAR), 
                       FIRST_YEAR_TOTAL = first(TOTAL), 
                       LAST_YEAR = last(YEAR),
                       LAST_YEAR_TOTAL = last(TOTAL),
                       DIFFERENCE_FROM_FIRST = TOTAL - FIRST_YEAR_TOTAL,
                       PERCENT_DIFFERENCE_FROM_FIRST = DIFFERENCE_FROM_FIRST / FIRST_YEAR_TOTAL * 100) %>%
                filter(FIRST_YEAR == 1980, FIRST_YEAR_TOTAL > 0, LAST_YEAR == 2010, LAST_YEAR_TOTAL > 0, PERCENT_DIFFERENCE_FROM_FIRST != -100)
            
  
  output$denomination_selector <- renderUI({
    selectInput("grpname", "Choose Denomination:", unique(dataset$GRPNAME))
  })
  
  denom_data <- reactive({
    filter(dataset, GRPNAME == input$grpname)
  })

  disp_cols <- c("GRPNAME", "FIRST_YEAR_TOTAL", "LAST_YEAR_TOTAL", "PERCENT_DIFFERENCE_FROM_FIRST")
  
  current_year_dataset <- dataset %>% filter(YEAR == max(dataset$YEAR))
  
  #create table based on shrinking denoms
  output$shrinking_denoms <- renderTable({
    head(current_year_dataset[disp_cols] %>% arrange(PERCENT_DIFFERENCE_FROM_FIRST), 10)
  })
  
  #create table based on growing denoms
  output$growing_denoms <- renderTable({
    
    head(current_year_dataset[disp_cols] %>% 
           filter(PERCENT_DIFFERENCE_FROM_FIRST > 0) %>% 
           arrange(desc(PERCENT_DIFFERENCE_FROM_FIRST)), 
         10)
    
  })
    
  #Create plot based off of input
  output$church_stats <- renderPlot({ 
      ggplot(denom_data(), aes(x=YEAR, y=TOTAL)) + geom_bar(stat="identity", fill="steelblue")
      
  })
}