library(RMeCab)

tx=read_csv('sampleText.txt',col_names=F)

wakachi=tibble(nouns='')
for(i in 1:nrow(tx)){
  a=RMeCabC(tx[i,]) %>% unlist()
  
  
  b=str_c(a[names(a)=='名詞'] %>% as.character(),collapse=' ')
  wakachi=bind_rows(wakachi,c(nouns=b))
}
wakachi=wakachi[-1,]
wakachi
