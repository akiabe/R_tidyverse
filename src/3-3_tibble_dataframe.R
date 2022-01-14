library(tidyverse)

# データの読み込み
mpg

# 列の絞り込み
mpg %>% 
  select(model, displ, year, cyl)

mpg %>% 
  select(manufacturer, model, displ, year, cyl) %>% 
  filter(manufacturer == "audi") %>% 
  mutate(century = ceiling(year / 100))

# filter()による行の絞り込み
mpg %>% 
  filter(manufacturer == "audi")

# どちらの条件も満たす場合
mpg %>% 
  filter(manufacturer == "audi", cyl >= 6)

mpg %>% 
  filter(manufacturer == "audi" & cyl >= 6)

# いずれかの条件を満たす場合
mpg %>% 
  filter(manufacturer == "audi" | cyl >= 6)

# いずれの条件も満たさない場合
mpg %>% 
  filter(!(manufacturer == "audi" | cyl >= 6))

# arrange()によるデータの並び替え

# cty列で並び替え（昇順）
mpg %>% 
  arrange(cty)

# cty列、hwy列で並び替え
mpg %>% 
  arrange(cty, hwy)

# 降順で並び替え
mpg %>% 
  arrange(desc(manufacturer))

mpg %>% 
  arrange(desc(cty, hwy))

# select()による列の絞り込み

# model列のみ抽出
mpg %>% 
  select(model)

# 複数列を抽出
mpg %>% 
  select(model, trans)

# 指定した列の間にある列すべてを抽出
mpg %>% 
  select(manufacturer:year)

# 指定した列を除外する
mpg %>% 
  select(!manufacturer)

# 列を絞り込み、絞り込んだ列名を変更
mpg %>% 
  select(MODEL = model, TRANS = trans)

# 列は絞り込まず、列名のみ変更
mpg %>% 
  rename(MODEL = model, TRANS = trans)

# 列名がcから始まる列だけを抽出
mpg %>% 
  select(starts_with("c"))

# 文字列を含む列のみ抽出
mpg %>% 
  select(where(is.character))

# 文字列、かつ値の種類が6個以下の条件を満たす列を抽出
mpg %>% 
  select(where(~is.character(.x) && n_distinct(.x) <= 6))

# 2つの指定に共通する列のみ抽出
mpg %>% 
  select(where(is.character) & !starts_with("m"))

# relocate()による並び替え

# 指定した列を一番前に並び替え
mpg %>% 
  relocate(class, cyl)

# .before引数で指定した列の前に列を置く
mpg %>% 
  relocate(class, cyl, .before = model)

# .after引数で指定した列の後ろに列を置く
mpg %>% 
  relocate(class, cyl, .after = model)

# mutate()による列の追加

# cyl列が「6以上」か「6未満」かを示す新しいcyl_6列を作成
mpg %>% 
  mutate(cyl_6 = if_else(cyl >= 6, ">=6", "=<6"))

# cyl列の後ろに追加
mpg %>% 
  mutate(cyl_6 = if_else(cyl >= 6, ">=6", "=<6"), .after = cyl)

# 新しい列と既存の列を抽出
mpg %>% 
  transmute(cyl_6 = if_else(cyl >= 6, ">=6", "=<6"), year)

mpg %>% 
  mutate(
    century = ceiling(year / 100),    # ceiling()で値を切り上げる
    century_int = as.integer(century) # ceiling()の結果は数値型なので、整数型に変換
  )

# summarise()によるデータ集計計算

# displ列の最大値を計算
mpg %>% 
  summarise(displ_max = max(displ))
