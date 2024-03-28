library(tidyverse)
set.seed(69420)

country_locations <- read_csv("data/country_locations.csv") %>% select(-name)
country_codes <- read_csv("data/country_codes.csv") %>% filter(`Alpha-2 Code` %in% country_locations$country) %>% mutate(alpha_2 = `Alpha-2 Code`, alpha_3 = `Alpha-3 Code`) %>% select(-`Alpha-2 Code`, -`Alpha-3 Code`, -Country) 
country_locations <- country_locations %>% filter(country %in% country_codes$alpha_2) %>% mutate(alpha_2 = country) %>% select(-country)

merged_data <- merge(country_locations, country_codes, by="alpha_2") %>% mutate(country_code = alpha_3) %>% select(country_code, latitude, longitude)

write.csv(merged_data, "data/clean_country_locations.csv", row.names=FALSE)
