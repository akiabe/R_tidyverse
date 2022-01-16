library(tidyverse)

# separate()による値の分割
orders <- tibble(
  id = c(1, 2, 3),
  value = c("ラーメン_大", "ラーメン_並", "ラーメン_並")
)

orders

orders %>% 
  separate(value, into = c("item", "amount"), sep = "_")

orders <- tibble(
  id = c(1, 2, 3),
  value = c("ラーメン.大", "ラーメン.並", "ラーメン.並")
)

orders

orders %>% 
  separate(value, into = c("item", "amount"), sep = "\\.")

# extract()による値の抽出
orders <- tibble(
  id = c(1, 2, 3),
  value = c("ラーメン_大", "ラーメン_並", "ラーメン_並")
)

orders %>% 
  extract(value, into = c("item", "amount"), regex = "(.*)_(.*)")

tibble(x = c("beer (31)", "sushi (8)")) 
tibble(x = c("beer (31)", "sushi (8)")) %>% 
  extract(x, into = c("item", "num"), regex = "(.*) \\((\\d+)\\)") # ()は\\(\\)、数字は\\dと表す

# separate_rows()による値の分割（縦方向）
tibble(id = 1:3, x = c("1,2", "3,2", "1"))
tibble(id = 1:3, x = c("1,2", "3,2", "1")) %>% 
  separate_rows(x, sep = ",")

# 暗黙の欠損値

# ラーメンと半チャーハンを提供する飲食店のある2日間の注文集計データ
orders2 <- tibble(
  day = c(1, 1, 1, 2),
  item = c("ラーメン", "ラーメン", "半チャーハン", "ラーメン"),
  size = c("大", "並", "並", "並"),
  order = c(3, 10, 3, 30)
)

orders2 # 2日目のラーメン並以外の記録が欠損（暗黙の欠損）

# complete()による存在しない組み合わせ検出
orders2 %>% 
  complete(day, item, size) # day、item、sizeの組み合わせから暗黙の欠損値を探す

orders2 %>% 
  complete(day, nesting(item, size)) # nesting()で囲まれた列を、存在する組み合わせに絞る

# 欠損値をNでなく0で埋める
orders2 %>% 
  complete(day, nesting(item, size), fill = list(order = 0))

# 時系列データの補完
full_seq(c(1, 2, 4, 5, 10), period = 1)

tibble(
  day = c(1, 4, 5, 7),
  event = c(1, 1, 2, 1)
)

tibble(
  day = c(1, 4, 5, 7),
  event = c(1, 1, 2, 1)
) %>% 
  complete(
    day = full_seq(day, period = 1),
    fill = list(event = 0)
  )


# fill()による欠損値の補完

# 四半期ごとの売上データ
sales <- tibble(
  year = c(2000, NA, NA, NA, 2001, NA, NA, NA),
  quarter = c("Q1", "Q2", "Q3", "Q4", "Q1", "Q2", "Q3", "Q4"),
  sales = c(100, 200, 300, 400, 500, 100, 200, 300)
)

sales

sales %>% 
  fill(year)

# replace_na()による欠損値の置き換え
d_missing <- tibble(
  id = c("a", "b", NA),
  value = c(NA, 1, 2)
)

d_missing

d_missing %>% 
  replace_na(list(id = "?", value = 0))

d_missing %>% 
  mutate(
    id = coalesce(id, "?"),
    value = coalesce(value, 0)
  )

# 欠損値を置き換える対象の列が複数ある場合
d_missing %>% 
  mutate(
    across(where(is.character), coalesce, "?"),
    across(where(is.numeric), coalesce, 0)
  )
