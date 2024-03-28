library(tidyverse)
set.seed(69420)

sdr_goals <- read_csv("data/sdr_fd5e4b5a.csv") %>% mutate(goal_1 = `Goal 1 Score`, goal_3 = `Goal 3 Score`) %>% select(goal_1, goal_3) %>% filter(!is.na(goal_1) & !is.na(goal_3))

# cor(x = sdr_goals$goal_1, y = sdr_goals$goal_3)
sdr_goals %>% ggplot(aes(x=goal_1, y=goal_3)) + geom_point() + geom_smooth(method="lm", se=FALSE)

model <- lm(goal_3 ~ goal_1, data = sdr_goals)
summary(model)$coefficients

df <- fortify(model)
df %>% ggplot(aes(x = goal_1, y = .resid)) + geom_point() + geom_smooth(method="lm", se=FALSE)