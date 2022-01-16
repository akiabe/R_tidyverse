library(tidyverse)

# グループ化

# manufacturer列とyear列でグループ化
mpg_grouped <- mpg %>% 
  group_by(manufacturer, year)

mpg_grouped

# 各行のdisplの値のグループ内での順位を計算
mpg_grouped %>% 
  transmute(displ_rank = rank(displ, ties.method = "max"))

# 各グループのdisplの最大値を計算
mpg_grouped %>% 
  summarise(displ_max = max(displ), .groups = "drop") # groups = "drop"でグループ化を解除

# 各グループの最大値と最小値を計算
mpg_grouped %>% 
  summarise(
    label = c("min", "max"),
    displ_range = range(displ), # range()で最小値、最大値を返す
    .groups = "drop"
  )

# a店とb店の売り上げデータを作成
uriage <- tibble(
  day = c(1, 1, 2, 2, 3, 3, 4, 4),
  store = c("a", "b", "a", "b", "a", "b", "a", "b"),
  sales = c(100, 500, 200, 500, 400, 500, 800, 500)
)

uriage

# 各店舗の売り上げ変化を計算
uriage %>% 
  group_by(store) %>% 
  mutate(sales_diff = sales - lag(sales)) %>% 
  arrange(store, day)

# 各店舗の平均売上と各日の売上と平均売上との差
uriage %>% 
  group_by(store) %>% 
  mutate(
    sales_mean = mean(sales),
    sales_err = sales - sales_mean
  )

# .dataを使った文字列での列指定

# cyl列の平方根をcyl2列として作成
mpg %>% 
  mutate(cyl2 = sqrt(.data[["cyl"]]), .after = cyl)

col <- "cyl"
mpg %>% 
  mutate(cyl2 = sqrt(.data[[col]]), .after = cyl)

#　複数の列への操作

# データ作成
set.seed(1)
d <- tibble(
  id = 1:10,
  test1 = runif(10, max = 100),
  test2 = runif(10, max = 100),
  test3 = runif(10, max = 100),
  test4 = runif(10, max = 100)
)

d

#　すべての列の値をround()で丸める

# 愚直な方法
d %>% 
  mutate(
    test1 = round(test1),
    test2 = round(test1),
    test3 = round(test1),
    test4 = round(test1)
  )

# tidyrによる方法
d_tidy <- d %>% 
  pivot_longer(
    cols = test1:test4,
    names_to = "test",
    values_to = "value")

d_tidy

d_tidy %>% 
  mutate(value = round(value))

d_tidy %>% 
  group_by(test) %>% 
  summarise(value_avg = mean(value), .groups = "drop")

# 元の横長形式に変換
d_tidy %>% 
  mutate(value = round(value)) %>% 
  pivot_wider(names_from = test, values_from = value)

# across()による複数列への操作

# test1からtest4列に絞り込み
d %>% 
  select(test1:test4)

d %>% 
  transmute(across(test1:test4))

# test1とtest2列を指定したい場合
d %>% 
  transmute(across(c(test1, test2)))

# test1からtest4列をround()で丸める
d %>% 
  mutate(across(test1:test4, round))

d %>% 
  mutate(across(test1:test4, ~ round(.x)))

# test1からtest4列のいずれかが90より大きい値の行のみに絞り込む
d %>% 
  filter(if_any(test1:test4, ~ .x > 90))

# 数値列は標準偏差を、文字列はユニークな値の数を集計し、グループごとの行数を計算
mpg %>% 
  group_by(cyl) %>% 
  summarise(
    across(where(is.numeric), sd),
    count = n(),
    across(where(is.character), n_distinct),
    .groups = "drop"
  )

# 上記に加え、平均と標準偏差も集計する場合
mpg %>% 
  group_by(cyl) %>% 
  summarise(
    across(where(is.numeric), mean, .names = "{.col}_mean"),
    across(where(is.numeric) & !ends_with("_mean"), sd, .names = "{.col}_sd"),
    .groups = "drop"
  )

fns <- list(mean = mean, sd = sd, q90 = ~ quantile(.x, 0.9))
mpg %>% 
  group_by(cyl) %>% 
  summarise(
    across(where(is.numeric), fns),
    .groups = "drop"
  )
