library(imager)

img0=load.image('image0.jpeg')
plot(img0,axes=F)

img=resize(img0,200,250)
plot(img,axes=F) #or plot(as.raster(img))
nrow(img)
ncol(img)

img=grayscale(img) #[0,1]
plot(img,axes=F,main='origin')

# 微分フィルタ
dffilterX = as.cimg(
  array(c(0,0,0,-1,1,0,0,0,0), c(3,3)))
dffilterY = as.cimg(
  t(array(c(0,0,0,-1,1,0,0,0,0), c(3,3))))
# [0,1] to [-1,1] by convolutin 
dfx=convolve(img,dffilterX)
dfy=convolve(img,dffilterY)
plot(imlist(dfx=dfx,dfy=dfy), layout="row",axes=F)

dfx=abs(dfx)
plot(-dfx,axes=F,main='diff x')
dfy=abs(dfy)
plot(-dfy,axes=F,main='diff y')

dfxy=pmax(dfx,dfy)
plot(-dfxy,axes=F,main='diff x&y')

mx0=as.matrix(dfxy)

k=50

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

