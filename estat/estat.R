library(estatapi)
appID='ddbfecf8400828ef145464e15a1a2499f431dc16'

pref=estat_getStatsList(appID,
                        searchWord = "都道府県")
saveRDS(pref,'pref.rds')

city=estat_getStatsList(appID,
                        searchWord = "市町村")
saveRDS(city,'city.rds')

popl=estat_getStatsList(appID,
                        searchWord = "人口")
saveRDS(popl,'popl.rds')


str(code) # ->tibble, use dplyr 

code %>% 
  select(STAT_NAME,MAIN_CATEGORY,SUB_CATEGORY) %>% 
  distinct(STAT_NAME, .keep_all=T) %>% 
  arrange(MAIN_CATEGORY) %>% 
  print(n=Inf)

code %>%
  filter(str_detect(STAT_NAME,'患者')) %>% 
  select(STATISTICS_NAME) %>% 
  distinct(STATISTICS_NAME, .keep_all=T) %>% 
  print(n=Inf)

code %>%
  filter(str_detect(STATISTICS_NAME,'令和２年患者調査') &
         str_detect(STATISTICS_NAME,'都道府県')) %>%
  select('@id',TITLE) %>% 
  print(n=Inf)



meta=estat_getMetaInfo(appID,
                       statsDataId = '0004002836')

str(meta) # ->list, use $

meta$.names[2]
nrow(meta$.names)-1 # ->no. of cat 

meta$cat01 # ->tibble level and its parent cord(row)
meta$cat02 # ->tibble
meta$cat03 # ->tibble
meta$cat04 # ->tibble


data0=estat_getStatsData(appID,
                        statsDataId = '0004002836',
                        lvCat01='1')

data=data0

str(data) # ->tibble, use dplyr


data[1,2] #表章項目

data[4]=trimws(data[[4]]) #cat1
data[4] %>% distinct()
data[6]=trimws(data[[6]]) #cat2
data[6] %>% distinct()
data[8]=trimws(data[[8]]) #cat3
data[8] %>% distinct()
data[10]=trimws(data[[10]]) #cat4
data[10] %>% distinct()
# ...

opts4=c('総数')

opts6=c('総数',
        '男')

opts8=c('全国',
       '東京',
       '大阪')

data=data[(data[[4]] %in% opts4),]
data=data[(data[[6]] %in% opts6),]
data=data[(data[[8]] %in% opts8),]

cols=c(4,6,8,10)
tb0=data %>% select(cols,value) 
print(tb0,n=Inf)  
