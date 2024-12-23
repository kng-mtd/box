# install.packages('jsonlite')
library(jsonlite)

tb=penguins
#tb=read_csv('test_json.csv')

json1=toJSON(tb)
str(json1)

tb1=fromJSON(json1)
str(tb1)


write_json(tb,'test_json.json')
write_json(tb,'test_json_pretty.json', pretty=T)


json2=fromJSON('test_json.json')
str(json2)

write_csv(json2,'test_json.csv')

json3=read_json('test_json.json')
str(json3)




read_file('https://jsonplaceholder.typicode.com/users')

read_lines('https://jsonplaceholder.typicode.com/users')

read_json('https://jsonplaceholder.typicode.com/users')

read_json('https://jsonplaceholder.typicode.com/users', simplifyVector=T)

fromJSON('https://jsonplaceholder.typicode.com/users')




json=fromJSON("http://radioactivity.nsr.go.jp/data/ja/real/area_24000/2401_trend.json")

as_tibble(json) %>%
  glimpse()

as_tibble(json) %>%
  select(where(is.list)) %>%
  glimpse()






library(tidyjson)

json=c('{"age": 32, "name": {"first": "Bob",   "last": "Smith"}}',
       '{"age": 54, "name": {"first": "Susan", "last": "Doe"}}',
       '{"age": 18, "name": {"first": "Ann",   "last": "Jones"}}')


json %>%
  spread_all() %>% # for character vector
  as_tibble() %>% 
  select(-1)


json=read_json("http://radioactivity.nsr.go.jp/data/ja/real/area_24000/2401_trend.json")

as_tibble(json) %>% 
  glimpse()






GET('https://geoapi.heartrails.com/api/json?method=getPrefectures')

arg0=list(method='getPrefectures')
GET('https://geoapi.heartrails.com/api/json', query=arg0)

fromJSON('https://geoapi.heartrails.com/api/json?method=getPrefectures')




GET('https://geoapi.heartrails.com/api/json?method=getCities&prefecture=北海道')

arg0=list(method='getCities',
          prefecture='北海道')
GET('https://geoapi.heartrails.com/api/json', query=arg0)

fromJSON('https://geoapi.heartrails.com/api/json?method=getCities&prefecture=北海道')




GET('https://geoapi.heartrails.com/api/json?method=getTowns&prefecture=北海道&city=札幌市')

fromJSON('https://geoapi.heartrails.com/api/json?method=getTowns&prefecture=北海道&city=札幌市')




#https://www.post.japanpost.jp/zipcode/dl/utf-zip.html

download.file('https://www.post.japanpost.jp/zipcode/dl/utf/zip/utf_ken_all.zip','utf_ken_all.zip')
unzip('utf_ken_all.zip',list=T)
unzip('utf_ken_all.zip')
read_csv('utf_ken_all.csv')





