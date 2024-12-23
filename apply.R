tb=penguins %>% select(is.numeric)

apply(tb,1,sum,na.rm=T) %>% head()

apply(tb,2,mean,na.rm=T)

sapply(tb,mean,na.rm=T) #return vector

lapply(tb,mean,na.rm=T) #retrun list

apply(tb,2,range,na.rm=T)

tb %>%
  drop_na() %>% 
  apply(2,function(x){
  return (c(mean(x),median(x),names(which.max(table(x)))))
})
