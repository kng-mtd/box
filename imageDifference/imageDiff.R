library(imager)

img0=load.image('image0.jpg')

plot(img0,axes=F)

img=resize(img0,100,100)
plot(img,axes=F) #or plot(as.raster(img))
nrow(img)
ncol(img)

img=grayscale(img) #[0,1]
plot(img,axes=F,main='origin')

mx=as.matrix(img)

chisq.test(mx)

as.vector(mx) |> hist()


dist_matrix=function(mx){
  options(digits=3,scipen=100)
  par(mfrow=c(2,2))
  mmx=mean(mx)
  mx[1,1]=0
  mx[nrow(mx),ncol(mx)]=1
  img=as.cimg(mx)
  plot(img,axes=F)
  mx[1,1]=mmx
  mx[nrow(mx),ncol(mx)]=mmx
  cat('sum',sum(mx),'\n')
  cat('sd',sd(mx),'\n')
  chisq=chisq.test(mx)$statistic
  cat('chisq',chisq,'   chisq/sum',chisq/sum(mx),'\n')
  cat('rowSums SD',sd(rowSums(mx)),'   colSums SD',sd(colSums(mx)),'\n')
  cat('skewness',skew(mx),'   kurtosis',kurt(mx),'\n')
  as.vector(mx) |>
    hist(breaks=seq(0,1,0.05),xlab='x')
  plot(x=rowSums(mx),y=-(1:nrow(mx)),xlab='sum',ylab='row')
  plot(x=1:ncol(mx),y=colSums(mx),xlab='col',ylab='sum')
}

dist_image=function(fl){
  img=load.image(fl) |> 
    resize(100,100) |> 
    grayscale() #[0,1]
  mx=as.matrix(img)
  
  mx=std0to1(mx)
  
  dist_matrix(mx)
}


#distribution 0
mx=matrix(0.5,100,100)
suppressWarnings(dist_matrix(mx))

#normal sd=0.1
mx=matrix(rnorm(10000,0.5,0.1),100,100)
suppressWarnings(dist_matrix(mx))

#unif sd=0.05
mx=matrix(runif(10000,0.5-0.05*3**.5,0.5+0.05*3**.5),100,100)
suppressWarnings(dist_matrix(mx))

#unif sd=0.1
mx=matrix(runif(10000,0.5-0.03**.5,0.5+0.03**.5),100,100)
suppressWarnings(dist_matrix(mx))

#unif sd=0.2
mx=matrix(runif(10000,0.5-0.12**.5,0.5+0.12**.5),100,100)
suppressWarnings(dist_matrix(mx))


mx=matrix(rnorm(10000,0.5,0.1),100,100)
mx[21:60,21:60]=0.2
suppressWarnings(dist_matrix(mx))


mx=matrix(rnorm(10000,0.5,0.1),100,100)
mx[11:50,11:50]=0.4
mx[11:40,61:90]=1
mx[71:90,21:40]=0
mx[81:90,81:90]=0.4
mx[56:60,56:60]=0
mx[66:68,66:68]=0
mx[72:73,72:73]=0
mx[77:77,77:77]=0
suppressWarnings(dist_matrix(mx))




dist_image('sea1.jpg')
dist_image('sea2.jpg')
dist_image('forest1.jpg')
dist_image('forest2.jpg')
dist_image('turf1.jpg')
dist_image('turf2.jpg')
dist_image('night1.jpg')
dist_image('night2.jpg')

dist_image('image0.jpg')
dist_image('president.jpg')



layout(matrix(1:1,1,1))
image(mx,axes=F,col=gray.colors(10),
      main=str_c('origin  dim: ',nrow(mx),',',ncol(mx)))



k=10

pca=prcomp(mx0)

mx=pca$x[,1:k] %*% t(pca$rotation[,1:k]) %>%
  scale(center=-pca$center,scale=F) 

img=as.cimg(mx)
plot(-img,main=str_c('pca; ',k))



ku=k
kv=k
system.time({
  svd=svd(mx0,ku,kv)#u n*ku, d ku*kv, v m*kv
}) 
#svd$d #singular value
d=diag(svd$d[1:k])
u=svd$u #left singular matrix
v=svd$v #right singular matrix
mx=u %*% d %*% t(v)

img=as.cimg(mx)
plot(-img,main=str_c('svd; ',k))


library(NMF)
system.time({
  res=nmf(mx0,k) # rank k approximation
})
w=basis(res) # W matrix
h=coef(res) # H matrix
mx=w%*%h

img=as.cimg(mx)
plot(-img,main=str_c('nmf; ',k))

