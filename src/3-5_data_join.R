library(tidyverse)

# inner_join()によるデータ結合

# 売上データ
uriage

# 天候データ
tenko <- tibble(
  day = c(1, 2, 3, 4),
  rained = c(FALSE, FALSE, TRUE, TRUE)
)

tenko

# 共通のday列をキーとして結合
uriage %>% 
  inner_join(tenko, by = "day")

# 複数キーの指定方法
tenko2 <- tibble(
  DAY = c(1, 2, 3, 4),
  rained = c(FALSE, FALSE, TRUE, TRUE)
)

tenko2

uriage %>% 
  inner_join(tenko2, by = c("day" = "DAY"))

tenko3 <- tibble(
  DAY = c(1, 1, 2, 2, 3),
  store = c("a", "b", "a", "b", "b"),
  rained = c(FALSE, FALSE, TRUE, FALSE, TRUE)
)

tenko3

uriage %>% 
  inner_join(tenko3, by = c("day" = "DAY", "store"))

# inner_join()以外の関数によるデータの結合
uriage %>% 
  left_join(tenko3, by = c("day" = "DAY", "store"))

# rained列のNAをFALSEで置き換え
res <- uriage %>% 
  left_join(tenko3, by = c("day" = "DAY", "store"))

res %>% 
  mutate(rained = coalesce(rained, FALSE))

# semi_join()、anti_join()による絞り込み
tenko4 <- tibble(
  day = c(2, 3, 3),
  store = c("a", "a", "b"),
  rained = c(TRUE, TRUE, TRUE)
)

tenko4

# dayとstoreをキーとして、tenko4に売上列を結合
uriage %>% 
  semi_join(tenko4, by = c("day", "store"))

uriage %>% 
  inner_join(tenko4, by = c("day", "store"))

