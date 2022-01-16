library(tidyverse)

authors <- c("あべさん", "ゆたにさん", "きのさだ", "まえださん")
authors

substr(x = authors, start = 1, stop = 2)

gsub(pattern = "さん", replacement = "", x = authors)

# str_c()による文字列の連結
names <- data.frame(
  family_name = c("Matsumura", "Yutani", "Kinosada", "Maeda"),
  first_name = c("Yuya", "Hiroaki", "Yasunori", "Kazuhiro")
)

names

names_join <- str_c(names$family_name, names$first_name, sep = " ")
names_join

# str_split()による文字列の分割
str_split(string = names_join, pattern = " ", n = 2)

# str_detect()による文字列の判定
str_detect(string = names_join, pattern = "hiro")

# 要素を含まないかを判定する場合
str_detect(string = names_join, pattern = "hiro", negate = TRUE)

# str_count()による検索対象の計上
str_count(string = names_join, pattern = "hiro")

# 大文字又は小文字で表記された「hiro」が含まれている個数を返す
str_count(string = names_join, pattern = coll(pattern = "hiro", ignore_case = TRUE))

# str_subset()/str_extract()による文字列の抽出
names <- names %>% 
  mutate(full_name = names_join)

names

names %>% 
  filter(
    str_detect(string = full_name, pattern = "hiro")
  )

# 検索条件に合致する要素を直接抽出する方法
str_subset(string = names_join, pattern = "hiro")

# 大文字、小文字の違いを無視する場合
str_subset(string = names_join, pattern = coll(pattern = "hiro", ignore_case = TRUE))

# 条件に合致しない要素を抽出する場合
str_subset(string = names_join,
           pattern = coll(pattern = "hiro", ignore_case = TRUE),
           negate = TRUE)

# str_replace()による文字列の置換

# 最初の3文字を「AAA」に置換する
tmp <- names_join
str_sub(tmp, start = 1, end = 3) <- "AAA"
tmp

# 名前に小文字の「y」が含まれていたら、その部分を「-」に置換
str_replace(names_join, pattern = "y", replacement = "-")

# 大文字と小文字の区別を無視する場合
str_replace(string = names_join,
            pattern = coll(pattern = "y", ignore_case = TRUE),
            replacement = "-")