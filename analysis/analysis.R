package_list <- c("readxl", "dplyr", "ggplot2")

new_package_list <- package_list[!(package_list %in% installed.packages()[,"Package"])]
if (length(new_package_list)) install.packages(new_package_list)

library(readxl)
library(dplyr)
library(ggplot2)

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
  filter(YEAR == 2010, FIRST_YEAR == 1980, FIRST_YEAR_TOTAL > 0, LAST_YEAR == 2010, LAST_YEAR_TOTAL > 0, PERCENT_DIFFERENCE_FROM_FIRST != -100) %>%
  arrange(PERCENT_DIFFERENCE_FROM_FIRST)

current_year_dataset <- dataset %>% filter(YEAR == max(dataset$YEAR))

View(head(current_year_dataset, 10))
