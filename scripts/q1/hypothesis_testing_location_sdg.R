library(tidyverse)
set.seed(69420)

country_locations <- read_csv("data/country_locations_cluster.csv")
sdr_goals <- read_csv("data/sdr_fd5e4b5a.csv") %>% mutate(country_code = `Country Code ISO3`, score = `2023 SDG Index Score`) %>% select(country_code, score) %>% filter(country_code %in% country_locations$country_code)

merged_data <- merge(sdr_goals, country_locations, by="country_code") %>% filter(!is.na(score))

merged_data %>% group_by(cluster) %>% summarize(m = mean(score))

merged_data %>% ggplot(aes(x = longitude, y = latitude, color=cluster)) + geom_point() + xlim(-180, 180) + ylim(-90, 90)
