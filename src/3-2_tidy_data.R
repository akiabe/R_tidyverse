library(tidyverse)

scores_messy <- data.frame(
  name = c("A", "B"),
  math = c(100, 100),
  language = c(80, 100),
  science = c(60, 100),
  social = c(40, 20)
)

scores_messy

# pivot_longer()で縦長データへ変形
scores_tidy <- pivot_longer(
  scores_messy,
  cols = c(math, language, science, social),
  names_to = "class",
  values_to = "points"
)

scores_tidy

# pivot_wider()で横長データへ変形
pivot_wider(
  scores_tidy,
  names_from = class,
  values_from = points
)
