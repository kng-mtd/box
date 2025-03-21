tb0=penguins |> drop_na()|> select(is.numeric,-year)
tb=scale(tb0)

#covariance matrix tXX/(n-1)
cov(tb0)

#correlation matrix tXnXn, Xn=scale(X)
cor(tb0)
cov(tb)


#variance: eigen values of covariance matrix
eigen(cov(tb))$values

prcomp(tb)$sdev**2

svd(cov(tb))$d
svd(tb)$d**2/(nrow(tb)-1)

library(rsvd)
rsvd(cov(tb),k=2)$d
rsvd(tb,k=2)$d**2/(nrow(tb)-1)


#principal loadings: eigen vector of covariance matrix
eigen(cov(tb))$vectors

prcomp(tb)$rotation

svd(cov(tb))$u
svd(cov(tb))$v

svd(tb)$v
svd(tb,nv=2)$v

rsvd(tb,k=2)$v


#principal score
(tb %*% eigen(cov(tb))$vectors)[1:5,]

prcomp(tb)$x[1:5,]

(tb %*% svd(tb)$v)[1:5,]

(svd(tb)$u %*% diag(svd(tb)$d))[1:5,]

(tb %*% rsvd(tb,k=2)$v)[1:5,]

(rsvd(tb,k=2)$u %*% diag(rsvd(tb,k=2)$d))[1:5,]
