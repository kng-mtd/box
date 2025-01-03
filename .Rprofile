library(stats)
library(MASS)
library(tidyverse)
library(magrittr)
library(knitr)
library(gridExtra)
library(effsize)
library(ppcor)
library(arsenal)
library(corrplot)
library(RSQLite)
library(data.table)
library(palmerpenguins)


#quartiles
qtile=function(x) {
  quantile(x,probs=c(0.0,0.025,0.05,0.25,0.5,0.75,0.95,0.975,1))
}


#mode
mode=function(x) {
  as.numeric(names(which.max(table(x))))
}


#skewness of vector
skew=function(x){
  m=mean(x,na.rm=T)
  mean((x-m)**3,na.rm=T)/(mean((x-m)**2,na.rm=T))**1.5
}


#kurtosis of vector
kurt=function(x){
  m=mean(x,na.rm=T)
  mean((x-m)**4,na.rm=T)/(mean((x-m)**2,na.rm=T))**2
}


#standardize[0,1] of vector
std0to1=function(x){
  (x-min(x,na.rm=T))/(max(x,na.rm=T)-min(x,na.rm=T))
}



#summarize variables by arsenal
smArs=function(tb){
  arsenal::tableby(~.,tb) |> 
    summary(text=T) |>
    kable('simple')
}



#rows have missing data
miss=function(tb){
  tb[!complete.cases(tb),]
}



#eject outlier of a vector
outlier=function(x){
  #boxplot(scale(x))
  q=fivenum(x)
    r=q[4]-q[2]
    l=q[2]-r*1.5
    u=q[4]+r*1.5
    x=x[x>l & x<u]
  #boxplot(x)
  x
}



#eject outlier of all numeric variables
outliers=function(tb){
  par(mfrow=c(1,2))
  v=select(tb,is.numeric) |> colnames()
  #boxplot(scale(tb[v]))
  
  q=tb[v] |> sapply(fivenum)
  for(i in v){
    r=q[4,i]-q[2,i]
    l=q[2,i]-r*1.5
    u=q[4,i]+r*1.5
    tb=tb[(tb[i]>l & tb[i]<u),]
  }
  #boxplot(scale(tb[v]))
  tb
}



#see distribution of all numeric variables
dists=function(tb){
  options(digits=2)
  par(mfrow=c(2,2))
  c=select(tb,is.numeric) |> colnames()
  tb0=tibble(var=NA,cv=NA,skew=NA,kurt=NA,shapiro=NA)
  tb1=tb0
  for(i in c){
    m=select(tb,i) |> drop_na() |> as.matrix()
    if(F){
      hist(m,main=i,
           xlab=str_c('cv:',format(sd(m)/mean(m)),
                      ' skew:',format(skew(m)),
                      ' kurt:',format(kurt(m))))
    }
    tb1[1,1]=i
    tb1[1,2]=format(sd(m)/mean(m))
    tb1[1,3]=format(skew(m))
    tb1[1,4]=format(kurt(m))
    tb1[1,5]=format(shapiro.test(m)$p.value)
    tb0=bind_rows(tb0,tb1)
  }
  tb0[-1,] |> kable('simple')
}



#see distribution of all numeric variables by all categories
distsByCat=function(tb){
  options(digits=2)
  par(mfrow=c(3,3))
  v=select(tb,is.numeric) |> colnames()
  c=select(tb,is.factor) |> colnames()
  tb0=tibble(n_var=NA,c_var=NA,cv=NA,skew=NA,kurt=NA,shapiro=NA)
  tb1=tb0
  for(i in v){
    for(j in c){
      f=tb[j] |>
        unlist() |>
        levels()
      for(k in f){
        m=tb  |> 
          filter(.data[[j]]==k) |>
          select(i) |>
          drop_na() |>
          as.matrix()
        if(F){
          hist(m,main=str_c(i,'\n',j,':',k),
               xlab=str_c('cv:',format(sd(m)/mean(m)),
                          ' skew:',format(skew(m)),
                          ' kurt:',format(kurt(m))))
        }
        tb1[1,1]=i
        tb1[1,2]=str_c(j,':',k)
        tb1[1,3]=format(sd(m)/mean(m))
        tb1[1,4]=format(skew(m))
        tb1[1,5]=format(kurt(m))
        tb1[1,6]=format(shapiro.test(m)$p.value)
        tb0=bind_rows(tb0,tb1)    
        
      }
    }
  }
  tb0[-1,] |> kable('simple') 
}



#see correlation easily
easyCR=function(tb){
  select(tb,is.numeric) |> 
    cor(use='complete.obs') |> 
    #print.table(digits=2) |>
    kable('simple')
}



#cramerV
crv=function(c1,c2){
  c1=as.matrix(c1)
  c2=as.matrix(c2)
  crs=table(c1,c2)
  chisq=chisq.test(crs)$statistic
  n=sum(crs)
  v=sqrt(chisq/(n*(min(nrow(crs),ncol(crs))-1)))
  names(v)='cramerV'
  return(v)
}


#cramerV for table or matrix
crvm=function(m){
  chi2=chisq.test(m)$statistic
  n=sum(m)
  v=sqrt(chi2/(n*(min(nrow(m),ncol(m))-1)))
  names(v)='cramerV'
  return(v)
}



#see Cramer's V in all couple of categorical valuables
crvall=function(tb){
  options(digits=2)
  par(mfrow=c(2,2))
  c=select(tb,is.factor) |> colnames()
  tb0=tibble(var1=c(NA),var2=c(NA),cramerV=c(NA))
  tb1=tb0
  for(i in c){
    for(j in c){
      if(i!=j){
        t=tibble(tb[i],tb[j]) |> table()
        cr=crv(tb[i],tb[j])
        if(F){
          mosaicplot(t,main='',
                     sub=str_c('cramer\'sV:',format(cr)))
        }
        tb1[1,1]=i
        tb1[1,2]=j
        tb1[1,3]=cr
        tb0=bind_rows(tb0,tb1)
      }
    }
  }
  tb0[-1,] |> kable('simple')
}



#Mantel-Haenszel
#(c1,c2,c3) independence of c1 and c2 on c3 fixed
crvmh=function(c1,c2,c3){
  c1=as.matrix(c1)
  c2=as.matrix(c2)
  c3=as.matrix(c3)
  crs=table(c1,c2,c3)
  mh=mantelhaen.test(crs)[1]$statistic
  n=sum(crs)
  v=sqrt(mh[1]/(n*(min(nrow(crs),ncol(crs))-1)))
  names(v)='cramerV_MH'
  return(v)
}



#summary by c1
agr1c=function(tb,v,c1){
  f=as.formula(str_c(v,'~',c1))
  a=aggregate(f,tb,summary)
  m=aggregate(f,tb,mean)
  s=aggregate(f,tb,sd)
  b=bind_cols(a[[1]],a[[2]],s[[2]],s[[2]]/m[[2]],)
  c=names(a)
  colnames(b)[1]=c[1]
  colnames(b)[8]='sd'
  colnames(b)[9]='cv'
  print(c[2])
  kable(b,'simple')
}


#summary by c1,c2
agr2c=function(tb,v,c1,c2){
  f=as.formula(str_c(v,'~',c1,'+',c2))
  a=aggregate(f,tb,summary)
  m=aggregate(f,tb,mean)
  s=aggregate(f,tb,sd)
  b=bind_cols(a[[1]],a[[2]],a[[3]],s[[3]],s[[3]]/m[[3]])
  c=names(a)
  colnames(b)[1]=c[1]
  colnames(b)[2]=c[2]
  colnames(b)[9]='sd'
  colnames(b)[10]='cv'
  print(c[3])
  kable(b,'simple')
}



#see eta in all numeric vars by all categorical vars
etaall=function(tb){
  options(digits=2)
  par(mfrow=c(2,2))
  v=select(tb,is.numeric) |> colnames()
  c=select(tb,is.factor) |> colnames()
  tb0=tibble(n_var=c(NA),c_var=c(NA),eta=c(NA))
  tb1=tb0
  for(i in v){
    for(j in c){
      f=as.formula(str_c(i,'~',j))
      anv=aov(f,tb)
      # strictly aov can be used in balanced design and 1wayANOVA
      anv=summary(anv) |> unlist()   
      if(F){
        boxplot(f,tb,main=j,ylab=i,
                xlab=str_c('eta:',
                           format(anv['Sum Sq1']/(anv['Sum Sq1']+anv['Sum Sq2']))))
      }
      
      #use car::Anova
      #anv=Anova(lm(f,tb),type=2)
      #boxplot(f,tb,main=j,ylab=i,
      #    xlab=str_c('eta:',
      #               format(anv$'Sum Sq1'[1]/
      #                        (anv$'Sum Sq1'[1]+anv$'Sum Sq2'[2]))))
      
      tb1[1,1]=i
      tb1[1,2]=j
      tb1[1,3]=format(anv['Sum Sq1']/(anv['Sum Sq1']+anv['Sum Sq2']))
      tb0=bind_rows(tb0,tb1)   
    }
  }
  tb0[-1,] |> kable('simple')
}




link2mat=function(n,ft,dr){
  #n #node
  #ft edge list;from node,to node,edge weight
  #dr directed or andirected flag true/false
  mx=matrix(0,n,n)
  for(i in 1:nrow(ft)){
    mx[ft$from[i],ft$to[i]]=ft$weight[i]
    if(!dr) mx[ft$to[i],ft$from[i]]=ft$weight[i]
  }
  return(mx)
}


mat2link=function(mx,dr){
  #n #node
  #mx adjecent matrix
  #dr directed or andirected flag true/false
  n=nrow(mx)
  ft=tibble(from=NA,to=NA,weight=NA)
  for(i in 1:n){
    for(j in 1:n){
      if(!dr && j<i) next
      if(mx[i,j]!=0) ft=bind_rows(ft,tibble(from=i,to=j,weight=mx[i,j]))
    }                               
  }
  ft=ft[-1,]
  return(ft)
}



hex2raw=function(hex) {
  raw=sapply(seq(1, nchar(hex), by=2), function(i) {
    as.raw(strtoi(substr(hex, i, i+1), base=16))
  })
  raw
}


# -> use model.matrix
factor2ind <- function(x, baseline){
  xname <- deparse(substitute(x))
  n <- length(x)
  x <- as.factor(x)
  if(!missing(baseline)) x <- relevel(x, baseline)
  X <- matrix(0L, n, length(levels(x)))
  X[(1:n) + n*(unclass(x)-1)] <- 1L
  X[is.na(x),] <- NA
  dimnames(X) <- list(names(x), paste(xname, levels(x), sep = ":"))
  return(X[,-1,drop=FALSE])
}
