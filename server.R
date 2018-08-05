library(shiny)
library(ggplot2)

function(input, output) {
  
  full_dataset <- read_xlsx("data/church_stats.XLSX")
  
  #minimize dataset
  cols <- c("YEAR", "STATEAB", "GRPCODE", "GRPNAME", "ADHERENT")
  dataset <- full_dataset[cols]
  
  #Group Data by Group Name
  grouped_data <- group_by(dataset, GRPNAME, YEAR)
  summary_by_grpname <- summarize(grouped_data, TOTAL = sum(ADHERENT))
  
  output$denomination_selector <- renderUI({
    selectInput("grpname", "Choose Denomination:", unique(dataset$GRPNAME))
  })
  
  #Create plot based off of input
  output$church_stats <- reactivePlot(function() { 
  
      denom_data <- filter(summary_by_grpname, GRPNAME == input$grpname)
    
      p <- ggplot(data=denom_data, aes(x=YEAR, y=TOTAL)) + geom_bar(stat="identity", fill="steelblue")
      
      print(p)
  })
  
}