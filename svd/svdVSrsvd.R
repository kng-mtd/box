tb0=penguins |> select(is.numeric,-year) |> drop_na()
name=names(tb0)
tb0=scale(tb0)
summary(tb0)
m=ncol(tb0)

cat('SVD')
for(k in 1:m){
  cat('\n k=',k,'\n')
  s=svd(tb0,k,k)
  u=s$u
  if(k==1){
    d=diag(as.matrix(s$d))
  }else{
    d=diag(s$d[1:k])
  }
  v=s$v
  tb1=u %*% d %*% t(v)
  colnames(tb1)=name
  summary(tb1) |> print()
  cat('MSE:',mean((tb0-tb1)**2),'\n')
  cat('V[SE]',var(as.vector(tb0-tb1)**2),'\n')
}

library(rsvd)

cat('rSVD')
for(k in 1:m){
  cat('\n k=',k,'\n')
  s=rsvd(as.matrix(tb0),k)
  u=s$u
  if(k==1){
    d=diag(as.matrix(s$d))
  }else{
    d=diag(s$d[1:k])
  }
  v=s$v
  tb1=u %*% d %*% t(v)
  colnames(tb1)=name
  summary(tb1) |> print()
  cat('MSE:',mean((tb0-tb1)**2),'\n')
  cat('V[SE]',var(as.vector(tb0-tb1)**2),'\n')
}



library(imager)

img0=load.image('image1.jpg')
#plot(img0,axes=F)

img=grayscale(img0) #[0,1]
plot(img,axes=F)
save.image(img,'image10.jpg')

mx=as.matrix(img)
dim(mx)
img=as.cimg(mx)
plot(img,axes=F,main='origin')

k=20

gc()
cat('\nSVD k:',k)
system.time({
  s=svd(mx,k,k)
  u=s$u
  d=diag(s$d[1:k])
  v=s$v
  tb1=u %*% d %*% t(v)
})  
  img=as.cimg(tb1)
  plot(img,axes=F,main=str_c('SVD ',k))
  save.image(img,'image1svd20.jpg')

gc()
cat('\nrSVD k:',k)
system.time({
  s=rsvd(mx,k)
  u=s$u
  d=diag(s$d[1:k])
  v=s$v
  tb1=u %*% d %*% t(v)
})
  img=as.cimg(tb1)
  plot(img,axes=F,main=str_c('rSVD ',k))
  save.image(img,'image1rsvd20.jpg')



k=50

gc()
cat('\nSVD k:',k)
system.time({
  s=svd(mx,k,k)
  u=s$u
  d=diag(s$d[1:k])
  v=s$v
  tb1=u %*% d %*% t(v)
})
  img=as.cimg(tb1)
  plot(img,axes=F,main=str_c('SVD ',k))
  save.image(img,'image1svd50.jpg')

gc()
cat('\nrSVD k:',k)
system.time({
  s=rsvd(mx,k)
  u=s$u
  d=diag(s$d[1:k])
  v=s$v
  tb1=u %*% d %*% t(v)
})
  img=as.cimg(tb1)
  plot(img,axes=F,main=str_c('rSVD ',k))
  save.image(img,'image1rsvd50.jpg')

