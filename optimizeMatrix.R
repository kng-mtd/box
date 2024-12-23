# サンプルデータの作成
n=3  # サンプル数
p=3  # 特徴量の数

x0=matrix(rnorm(p * n), nrow = p, ncol = n)  # 入力データ行列
cat('data:\n')
print(x0)

x1=x0[1:p,1:n-1]
print(x1)
x2=x0[1:p,2:n]
print(x2)

# 目的関数の定義
obj_fn <- function(w) {
  w <- matrix(w, nrow = p, ncol = p)
  prd <- w %*% x1
  sum((x2 - prd)^2)
}

# 初期値の設定
prm0 <- runif(p*p)

# optim関数を使って最適化
rst <- optim(par = prm0, fn = obj_fn)

# 結果の表示
prm <- matrix(rst$par, nrow = p, ncol = p)
opt_val <- rst$value

options(digits=3,nsmall=3)
cat('Optimal Parameters:\n')
print(prm)
cat('Optimal Value:',opt_val,'\n')