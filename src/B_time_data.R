library(lubridate)

# 日付けデータの作成
d <- tibble(
  year = c(2020, 2021, 2022),
  month = c(12, 1, 8),
  day = c(1, 30, 19)
)

d

d %>% 
  mutate(date = make_date(year = year, month = month, day = day))

# 日付けから年、月、日を抽出
x <- ymd_hms("2020/07/18 12:34:56")
year(x)
month(x)
day(x)

# 1カ月後の日付を抽出
one_month <- months(1)
one_month

x <- ymd("2020-03-30", "2020-12-09")
x + one_month

# 結果がその月の日数を超えていれば月末の日付を返す
ymd("2020-01-30") %m+% months(1)

# 1ヶ月後を30日後とする場合
ymd("2020-01-30") + days(30)

# ある期間に日付が含まれているかを調べる 
d <- tibble(
  date = ymd("2021-01-01") + days(0:6),
  value = 1:7
)

d

# 2021年1月2日から2021年1月4日に絞り込む場合
d %>% 
  filter(
    date >= ymd("2021-01-02"),
    date <= ymd("2021-01-04")
  )

d %>% 
  filter(
    between(date, ymd("2021-01-02"), ymd("2021-01-04"))
  )

# interval()を使う場合
i <- interval(
  start = ymd("2021-01-02"),
  end = ymd("2021-01-04")
)

d %>% 
  filter(date %within% i)

# floor_date()を使った週ごとの集計
library(nycflights13)

head(flights, n = 3)

# 各週、各月の便数と平均遅延時間を計算
flights %>% 
  mutate(
    date = make_date(year, month, day),
    week = floor_date(date, unit = "week") # 週ごと
  ) %>% 
  group_by(week, origin) %>% 
  summarise(
    n = n(),
    avg_dep_delay = mean(dep_delay, na.rm = TRUE),
    .groups = "drop"
  )

flights %>% 
  mutate(
    date = make_date(year, month, day),
    week = floor_date(date, unit = "month") # 月ごと
  ) %>% 
  group_by(week, origin) %>% 
  summarise(
    n = n(),
    avg_dep_delay = mean(dep_delay, na.rm = TRUE),
    .groups = "drop"
  )
