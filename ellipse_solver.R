#ellipse
# (x-x0 /a)**2+(y-y0 /b)**2=1

x0=1 #center x
y0=-1 #center y
a=2 #range of x /2 
b=3 #range of y /2
# if a==b, a,b is radius 

n=50

x=runif(n,-a,a)+x0
y=( (1-(x-x0)**2/a**2) *b**2 )**.5 *sign(runif(n,0,2)-1) +y0
tb0=tibble(x,y)
tb0
plot(tb0)


fn0=function(p,tb){
  sum(((tb$x-p[1])**2/p[3] + (tb$y-p[2])**2/p[4] -1)**2) #p(x0,y0,a**2,b**2)
}

rst=optim(c(0,0,1,2),fn=fn0,tb=tb0)

rst$par
rst$value


c=pi/6
x1=x*cos(c)-y*sin(c)
y1=x*sin(c)+y*cos(c)
tb1=tibble(x1,y1)
tb1
plot(tb1)

pr=prcomp(tb1)
plot(pr$x)

