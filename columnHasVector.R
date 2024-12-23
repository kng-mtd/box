v1=c(1,2,3)
v2=c(10,20,30)
v3=c(100,200,300)

tb=tibble(x=c(list(v1),list(v2),list(v3)))
tb
tb$x
tb$x[1]
tb$x[[1]]
tb$x[[1]][1]
tb$x[2]
tb$x[[2]]

sum(tb$x[[1]])
sum(tb$x[[2]])

tb[[1]]
tb[[1]][1]
tb[[1]][[1]]
tb[[1]][[1]][1]
tb[[1]][2]
tb[[1]][[2]]

sum(tb[[1]][[1]])
sum(tb[[1]][[2]])

v4=c(0.1,0.2,0.3)
tb=bind_rows(tb,tibble(x=list(v4)))
tb
tb$x
tb$x[4]
tb$x[[4]]

tb[[1]]
tb[[1]][4]
tb[[1]][[4]]
