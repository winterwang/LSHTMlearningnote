############################################
## Example 3
############################################

## SAMPLING MODEL
## p(yi | F) = G(yi), yi>0

## PRIOR
## F = DP(M G0)

#############################################
## without censoring -- DP for y[i], y>0 only
#############################################

## data
## healthy Tconv mouse 2
yf <- c(37,11,5,2) # frequencies
xf <- c(1,2,3,4)   # counts
y <- rep(xf,yf)    # raw data
n <- length(y)
k <- n             # initialize

## hyperparameters
## a0 <- 1;   b0 <- 1   # hyperprior b ~ Ga(a0,b0) 
a <- 1; b <- .05     # G0(mu) = Ga(a,b)
lambda <- 300        # k ~ Poi(lambda)

M <- 1
H <- 10
N <- 25; p=8

rdiric<- function(n,a) {
  ## generates x ~ Dir(a,...a) (n-dim)
  p <- length(a)
  m <- matrix(nrow=n,ncol=p)
  for (i in 1:p) {
    m[,i] <- rgamma(n,a[i])
  }
  sumvec <- m %*% rep(1,p)
  m / as.vector(sumvec)
}


sample.dponly <- function(N=10,M=1,p=8,
                          plt.G0=F,plt.spl=F,plt.Ghat=F,
                          cdf=T)
{
  ## generates posterior p(G | y)
  ## for yi ~ G
  ## G0:   prior mean
  ## Ghat: empirical
  ## Gbar: posterior mean
  ## G:    posterior sample
  xgrid <- 1:p
  r <-  1/(1-dpois(0,lambda=2)) # trunction to x>=1
  G0 <- dpois(xgrid,lambda=2)*r # prior base measure
  G1 <- M*G0                    # post base measure  
  G1[xf] <- G1[xf]+yf     # +1 because xgrid starts at 0
  G <- rdiric(N,G1)
  Gcdf <- apply(G,1,cumsum)
  n <- sum(yf)
  Gbar <- G1/(n+M)
  Gbarcdf <- cumsum(Gbar)
  if (cdf)
    matplot(xgrid,Gcdf,type="n",bty="l",
            xlim=c(1,10),xlab="X",ylab="G",ylim=c(0,1))
  else
    matplot(xgrid,t(G),xlim=c(1,8),type="n",bty="l",
            xlab="COUNT",ylab="G") 
  if (plt.spl){
    for(i in 1:N){
      if (cdf)
        cdfplt(xgrid,Gcdf[,i],lw=1,lt=i,hi=10)
      else
        lines(xgrid,G[i,],lw=1,lt=i)
    }
  }
  G0cdf <- cumsum(G0)
  if (plt.G0){
    if (cdf)
      cdfplt(xgrid,G0cdf,  lt=3,lw=3, cl=1)
    else
      lines(xgrid,G0,  lt=3,lw=3, col=1)
  }
  Ghat <- rep(0,p) # initialize
  n <- sum(yf)
  Ghat[xf] <- yf/n
  Ghatcdf <- cumsum(Ghat)
  if (plt.Ghat){
    if (cdf){
      cdfplt(xgrid,Ghatcdf, lt=1, lw=3, cl=1)
      cdfplt(xgrid,Gbarcdf, lt=2, lw=3, cl=1)
    } else{
      xg <- as.numeric(names(table(y)))
      lines(table(y)/n,lwd=1)
      points(xg,table(y)/n,pch=19)
      lines(xgrid,Gbar,lty=1,lwd=3)
    }
  }# plt.Ghat
}

#############################################
## plotting a cdf -- aux function
#############################################

cdfplt <- function(x,y,lo=NULL,hi=NULL,
                   lw=1,lt=1,cl=1)
{
  p <- length(x)
  if (!is.null(hi)) # final line segment
    if(hi > x[p])
      lines(c(x[p],hi), c(1,1),col=cl,lwd=lw,lty=lt)
  if (!is.null(lo)){ # initial line segment
    if (lo<x[1]){
      lines(c(lo,x[1]), c(0,0),col=cl,lwd=lw,lty=lt)
      if (y[1]>0)   # prob mass at x[1]
        points(x[1],0,pch=1)
    }
  }# initial seg
  ylag <- c(0,y)    # prev prob
  for(i in 1:p){
    if (i<p)
      lines(x[c(i,i+1)],y[c(i,i)],col=cl,lwd=lw,lty=lt)
    if (y[i]>ylag[i]){ # prob mass @ x[i]
      points(x[i],y[i],pch=19)
      points(x[i],ylag[i],pch=1)
    }
  }# for i
}



## RUN IT: 
## run the commands below - best line by line

ex <- function()
{
  sample.dponly(plt.spl=T,cdf=F,plt.Ghat=T)
  legend(3,0.65, legend=c("E(G | y)", "G ~ p(G | y)", "Ghat (pins)"),
         lty=c(1,2,1), lwd=c(3,1,1),bty="n")
}
