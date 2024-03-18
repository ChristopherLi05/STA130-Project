library(tidyverse)
set.seed(69420)

gdp_data <- read_csv("data/country_gdps.csv") %>%
  mutate(log_recent = case_when(!is.na(`2022`) ~ log10(`2022`),
                                .default = log10(`2021`))
                                ) %>%
  mutate(country_code = `Country Code`) %>%
  select(country_code, log_recent) %>%
  filter(!is.na(log_recent))

# # Outliers 255 -> 243 observations
# median = median(gdp_data$log_recent)
# iqr = IQR(gdp_data$log_recent)
# 
# gdp_data <- gdp_data %>% filter(median - 1.5 * iqr < log_recent & log_recent < median + 1.5 * iqr)


# # Showing gdp_data
# gdp_data %>% ggplot(aes(x = log_recent)) + geom_histogram(bins=20)


# # Elbow method, 3 or 4 clusters is optimal
# explained_ss <- rep(NA, 10)
# for(k in 1:10){
#   # run k-means on the data
#   clustering <- kmeans(gdp_data$log_recent, k)
#   explained_ss[k] <- clustering$betweenss / clustering$totss
# }
# 
# ggplot() + 
#   aes(x=1:10, y=1-explained_ss) +
#   geom_line() + 
#   geom_point() +
#   labs(x="Number of Clusters", 
#        y="Remaining Variation",
#        title="K-Means Clustering Performance") +
#   theme(text=element_text(size=18)) +
#   scale_x_continuous(breaks=1:10) +
#   scale_x_continuous(breaks=1:10)


clustering <- kmeans(gdp_data$log_recent, 4)
gdp_data <- gdp_data %>% mutate(cluster = clustering$cluster) %>% mutate(cluster = case_when(cluster == 3 ~ 2, cluster == 4 ~ 3, cluster == 2 ~ 4, cluster == 1 ~ 1))

gdp_data %>% ggplot(aes(x=log_recent, group=cluster, fill=cluster)) + geom_histogram(bins = 10)

# write.csv(gdp_data, "data/clean_country_gdps.csv", row.names=FALSE)








