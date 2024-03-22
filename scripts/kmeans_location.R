library(tidyverse)
set.seed(69420)

country_locations = read_csv("data/clean_country_locations.csv")
gdp_data = read_csv("data/clean_country_gdps.csv") %>% filter(cluster==1 & country_code %in% country_locations$country_code) %>% select(-cluster)

merged_data = merge(gdp_data, country_locations, by="country_code")

# Elbow method, 3,4 clusters is optimal
# explained_ss <- rep(NA, 10)
# for(k in 1:10){
#   # run k-means on the data
#   clustering <- kmeans(merged_data %>% select(longitude, latitude), k)
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

clustering <- kmeans(merged_data %>% select(longitude, latitude), 4)
merged_data <- merged_data %>% mutate(cluster = clustering$cluster)

merged_data %>% ggplot(aes(x = longitude, y = latitude, color=cluster)) + geom_point() + xlim(-180, 180) + ylim(-90, 90)

# write.csv(merged_data, "data/country_locations_cluster.csv", row.names=FALSE)