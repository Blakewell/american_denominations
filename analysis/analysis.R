package_list <- c("readxl", "dplyr", "ggplot2")

new_package_list <- package_list[!(package_list %in% installed.packages()[,"Package"])]
if (length(new_package_list)) install.packages(new_package_list)

library(readxl)
library(dplyr)
library(ggplot2)

all_data <- read_excel("data/church_stats.XLSX")

cols <- c("YEAR", "STATEAB", "GRPCODE", "GRPNAME", "ADHERENT")

all_state_data <- all_data[cols]

denom_data <- all_state_data %>% 
                group_by(GRPNAME, YEAR) %>% 
                summarize(TOTAL = sum(ADHERENT)) %>%
                mutate(FIRST_YEAR = first(YEAR), 
                       FIRST_YEAR_TOTAL = first(TOTAL), 
                       DIFFERENCE_FROM_FIRST = TOTAL - FIRST_YEAR_TOTAL,
                       PERCENT_DIFFERENCE_FROM_FIRST = DIFFERENCE_FROM_FIRST / FIRST_YEAR_TOTAL * 100) %>%
                filter(FIRST_YEAR == 1980, FIRST_YEAR_TOTAL > 0) %>%
                filter(YEAR == 2010, PERCENT_DIFFERENCE_FROM_FIRST != 0, PERCENT_DIFFERENCE_FROM_FIRST != -100) %>%
                arrange(PERCENT_DIFFERENCE_FROM_FIRST)
                
View(head(denom_data, 10))
