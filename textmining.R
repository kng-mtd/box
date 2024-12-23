source("http://rmecab.jp/R/Aozora.R")
file=Aozora("https://www.aozora.gr.jp/cards/000035/files/2253_ruby_1031.zip")
tx=read.table(file,header=F,fileEncoding = "UTF-8")


install.packages("RMeCab", repos = "http://rmecab.jp/R")
library(RMeCab)


rst=RMeCabText('viyon.txt')
mx=matrix(ncol=10)
colnames(mx)=c('term','cat0','cat1','cat2','cat3','conjugate0','conjugate1','prototype','kana0','kana1')
for(i in 1:length(rst)) mx=rbind(mx,(rst[[i]] |> t()))
mx


mcbRst=RMeCabDF(tx,1,1)

tb=mcbRst %>% 
  imap_dfr(~data.frame(term=.,
                       class=names(.),
                       sentences=.y,
                       stringsAsFactors = F)) %>% 
  as_tibble()

write_csv(tb,'./dat.csv')


tb1=tb %>%
  filter(class=='名詞') %>% 
  group_by(term,sentences) %>% 
  mutate(n=n()) %>%
  select(-class) %>% 
  distinct()

tb1

bow=tb1 %>% 
  pivot_wider(names_from = term,
              values_from = n,
              values_fill = list(n=0))

bow
word=colnames(bow)
bow=as.tibble(bow)





library(wordcloud2)

tb %>%
  filter(class=='名詞') %>% 
  select(term) %>% 
  table() %>% 
  wordcloud2()



bigram=NgramDF(file,type=1,N=2,pos=c('名詞','動詞','形容詞'))

library(igraph)

bigram %>% 
  filter(Ngram1 %in% c('大谷','夫','奥さん')) %>% 
  graph.data.frame(directed=F) %>% 
  plot(vertex.label=V(.)$name)






library(topicmodels)

ldamdl=LDA(bow,k=10)

tpc=topics(ldamdl)

library(tidytext)

beta=tidy(ldamdl,matrix='beta')