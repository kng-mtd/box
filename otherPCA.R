m0=matrix(as.integer(runif(1e7,-1,1)),1e4,1e3)
m0=matrix(as.integer(rbinom(1e7,1,0.1)),1e4,1e3)
m0=matrix(as.integer(rnorm(1e7,0,1)),1e4,1e3)

#m0=matrix(as.integer(rbinom(1e8,1,0.1)),1e5,1e3)

system.time({
  pca=prcomp(m0,scale.=T,rank.=10)
  pca$sdev
  pca$rotation
  pca$x
  summary(pca)
})


library(Matrix)

#ms=Matrix(m0,sparse=T)

ms=Matrix(as.integer(rbinom(1e7,1,0.1)),1e4,1e3,sparse=T)
#ms=Matrix(as.integer(rbinom(1e8,1,0.1)),1e5,1e3,sparse=T)

system.time({
  pca=prcomp(ms,scale.=T,rank.=10)
  pca$sdev
  pca$rotation
  pca$x
  summary(pca)
})
gc()


library(irlba)

system.time({
  pca=prcomp_irlba(ms,10,scale.=T)
  pca$sdev
  pca$rotation
  pca$x
  summary(pca)
})





#svd

svd(m0,2)
svd(ms,2)

library(irlba)

irlba(m0,2)
irlba(ms,2)

library(rsvd)

rsvd(m0,2)
rsvd(ms,2)


     


