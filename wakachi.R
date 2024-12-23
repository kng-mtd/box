library(RMeCab)


tx=read_csv('sampleText.txt',col_names=F)
tx=read_csv('viyon.txt',col_names=F)

head(tx,10)
tail(tx,10)
tx=tx[1]

wakachi=tibble(nouns='')
for(i in 1:(nrow(tx)-0)){
  a=RMeCabC(tx[i,],dic='C:\\users\\s14422\\neologd.dic') %>% unlist()
  #a=RMeCabC(tx[i,]) %>% unlist()
  b=str_c(a[names(a)=='名詞'] %>% as.character(),collapse=' ')
  wakachi=bind_rows(wakachi,c(nouns=b))
}
wakachi=wakachi[-1,]
wakachi
