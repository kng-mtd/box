library(NMF)

a=rmatrix(10,5)

#A=WH
res=nmf(a,2) # rank 2 approximation

w=basis(res) # W matrix
w
h=coef(res) # H matrix
h

fitted(res)
w%*%h

res=nmf(a,c(2,3,4)) # nmf by each rank
plot(res)

res=nmf(a,2,.options='t') # nmf with trace
plot(res)

layout(cbind(1,2))
basismap(res) # max element by row in W matrix
coefmap(res) # max element by column in H matrix

############

# nmf for penguins data

tb0=penguins %>%
  drop_na() %>% 
  mutate(year=as.factor(year))

tbn=tb0 %>%
  select(is.numeric) # just numeric variable

nn=names(tbn)
l=c()
u=c()

# standardization [0,1] for numeric variable
for(i in nn){
  l[i]=min(tbn[i])
  u[i]=max(tbn[i])
  tbn[i]=scale(tbn[i],center=l[i],scale=u[i]-l[i])
}

str(tbn)



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


tbc0=tb0 %>%
  select(!is.numeric) # just categorical variable

nc=names(tbc0)

# make binary variable 0/1 for each level
tbc=tibble(rep(NA,nrow(tbc0)))
for(i in nc){
  btb=as_tibble(factor2ind(tbc0[[i]]))
  names(btb)=names(btb) %>%
    str_replace('tbc0\\[\\[i\\]\\]',i)
  tbc=tbc %>%
    bind_cols(btb)
}
tbc=tbc[,-1]

str(tbc)

tb=bind_cols(tbn,tbc)
str(tb)
summary(tb)

cor(tb)

par(mfrow=c(1,1))

res=nmf(tb,c(3,4,5))
plot(res)

res=nmf(tb,3,.options='t')
plot(res)

w0=basis(res) # W matrix
w=w0
w[w<0.001]=0

h0=coef(res) # H matrix
h=h0
h[h<0.001]=0

fitted(res)

tb_res=as_tibble(fitted(res))
str(tb_res)

tb_sp=as_tibble(w %*% h)
str(tb_sp)

summary(tb)
summary(tb_res)
summary(tb_sp)
max(tb-tb_sp)
max(tb_res-tb_sp)


library(corrplot)
corrplot(cor(tb))
corrplot(cor(tb_sp))

par(mfrow=c(2,1))
for(i in names(tb)){
  hist(tb[[i]],main=i,xlim=c(0,1.5))
  hist(tb_sp[[i]],main='',xlim=c(0,1.5))
  a=cor(tb[i],tb_sp[i])
  cat(i,':',a[[1]],'\n')
}


# see distribution -> not normal dist.
par(mfrow=c(1,1))
apply(w,2,hist) 
cov(w)
cor(w)
plot(as_tibble(w))

# if w follows normal dist.
library(MASS)
mvrnorm(10,apply(w,2,mean),cov(w))


# see w follows poisson dist.
m=apply(w,2,mean)
m
v=apply(w,2,var)
v

# gamma dist. parameters
# a: shape, b: rate, c: scale=1/rate
# f(x)=b^a/Ga(a) * x^(a-1)*exp(-bx) s.t. x>0
# a=mean^2/var, b=mean/var

rgamma(100,shape=m[1]**2/v[1],rate=m[1]/v[1]) %>% hist()
rgamma(100,shape=m[2]**2/v[2],rate=m[2]/v[2]) %>% hist()
rgamma(100,shape=m[3]**2/v[3],rate=m[3]/v[3]) %>% hist()

# w1 from gamma dist. random -> w2, w3
# w2=b20+b21*w1 -> b21=cov(w1,w2)/var(w1), b20=mean(w2)-mean(w1)*b21
# w3=b30+b31*w1 -> b31=cov(w1,w3)/var(w1), b30=mean(w3)-mean(w1)*b31

# similarly,
# w2 from gamma dist. random -> w1, w3
# w3 from gamma dist. random -> w2, w3
