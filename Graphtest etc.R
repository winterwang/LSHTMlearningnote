library(haven)
library(ggplot2)
library(ggthemes)
library(RYoudaoTranslate)
library(RCurl)
library(rjson)
library(ggsci)
library(epicalc)
apikey = "498375134"
keyfrom = "JustForTestYouDao"







growgam1 <- read_dta("backupfiles/growgam1.dta")

ggplot(growgam1, aes(x=age, y=wt)) + geom_point(shape=20, colour="grey40") +
  stat_smooth(method = lm, size = 0.3) +
  scale_x_continuous(breaks=seq(0, 38, 4),limits = c(0,36.5))+
  scale_y_continuous(breaks = seq(0, 20, 5),limits = c(0,20.5)) +
  theme_stata() +labs(x = "Age (Months)", y = "Weight (kg)") 


Model <- lm(wt~age, data=growgam1)

plot(growgam1$age, growgam1$wt, main="Regression")
abline(Model, col="lightblue")

range(growgam1$age)
newage <- seq(5,36, by=0.05)
  

pred_interval <- predict(Model, newdata=data.frame(age=newage), interval="prediction",
                         level = 0.95)
lines(newage, pred_interval[,2], col="orange", lty=2)
lines(newage, pred_interval[,3], col="orange", lty=2)


library(knitr)
library(kableExtra)
dt <- read.csv("backupfiles/anova2.csv", header = T)
kable(dt, "html", align = "c",caption = "One-way ANOVA table") %>%
  kable_styling(bootstrap_options = c("striped", "bordered"))




par(mfrow=c(1,2))
a <- rnorm(10000,50, 5)
b <- rnorm(10000, 50, 10)
hist(a, xlim=c(0,100), main = "")

hist(b, xlim=c(0,100), main = "")




x <- rbeta(10000,1.2,1.3)
hist(x, breaks = 30,
     xlim=c(min(x),max(x)), probability=T, 
     col='lightblue', xlab='Kurtosis < 3', ylab=' ', axes=F,
     main='Light-tailed')
curve(dnorm(x, mean = 0.5), xlim = c(0,1), add = T, lwd=2)
y <- rt(10000, 8)
hist(y, breaks = 30,
     xlim=c(min(y),max(y)), probability=T, ylim = c(0,0.4),
     col='lightblue', xlab='Kurtosis > 3', ylab=' ', axes=F,
     main='Heavy-tailed')
curve(dnorm(x), xlim = c(-5,5), add = T, lwd=2)

lines(dn, col='red', lwd=2)

set.seed(1234)
#hist(x, breaks = 30, probability = T)
curve(dt(x, 10), xlim = c(-5,5), frame=F, type = "l", lty=2)
curve(dt(x, 5), xlim = c(-5,5), add = T, col="red", type = "l", lty=3)
curve(dnorm(x), xlim = c(-5,5), add = T, col="blue")

# design a function that helps to calculate the binomial distribution
# and draw the discrete graph
graph.binom <- function(n, p) {
  x <- (dbinom(0:n, size = n, prob = p))
  barplot(x, yaxt="n",
          col = "lightblue",
          ylim = c(0, 0.4),
          names.arg = 0:n, ylab = "Probability",
          main = sprintf(paste('Binomial Distribution (n,p)' , n, p, sep = ', ')))
  axis(2, at=c(seq(0, 0.4, 0.1), 0.025), las=2)
  abline(h=0.025, col = "Red", lty=2, lwd = 2)
}

graph.binom(20, 0.0866)
graph.binom(20, 0.4910)


library(mvtnorm) #多変量正規分布パッケージ
library(scatterplot3d) #三次元描画パッケージ

sigma.zero <- matrix(c(1,0,0,1), ncol=2) #分散共分散行列（無相関）
x1 <- seq(-3, 3, length=50)  # 変量x1の定義域 -3≦x1≦3
x2 <- seq(-3, 3, length=50)  # 変量x2の定義域 -3≦x1≦3

f.zero <- function(x1,x2) { 
  dmvnorm(matrix(c(x1,x2), ncol=2), 
          mean=c(0,0), sigma=sigma.zero) }
# 分散共分散行列 sigma.zero の密度関数
z <- outer(x1, x2, f.zero) 
# x1とx2の定義域の外積に対する密度関数f.zeroの値域
z[is.na(z)] <- 1  # z に関する条件
op <- par(bg = "white")  #グラフィクスの環境設定
persp(x1, x2, z, theta = -30, phi = 15, expand = 0.7, col = "lightblue", xlab = "X", 
      ylab = "Y", zlab = "Probability Density")  

# interactive 3d bivariate normal distribution
library(rgl)
x10000 <- rmvnorm(n=10000, mean=c(0,0), sigma=sigma.zero)#乱数1000個
 plot3d(x10000[,1], x10000[,2],col = "lightblue", xlab = "X", 
       ylab = "Y", zlab = "Probability Density", 
       dmvnorm(x10000, mean=c(0,0), sigma=sigma.zero), type="s", size=1, lit=TRUE, main = "",sub="3-D Plot")

 

 library(car)
 x10000 <- rmvnorm(n=10000, mean=c(0,0), sigma=sigma.zero)#乱数10000個
  data.ellipse(x10000[1], x10000[2], levels=c(0.5, 0.975))
  contour(x.points,y.points,z)

  
  
  library(knitr)
  library(kableExtra)
  dt <- read.csv("backupfiles/walkingAT.csv", header = T)
  names(dt) <- c("", "Active exercise group (i=1)", "Eight week control group (i=2)")
  kable(dt, "html",  align = "c",caption = "表 22.1: Children's ages at time of first walking alone by randomisation group") %>%
    kable_styling(bootstrap_options = c("striped", "bordered")) %>%
    add_header_above(c("", "Age in months for walking alone" = 2))

  

  
  data <-  data.frame(x^3,x^2,x,sqrt(x),log(x),1/sqrt(x),1/x,1/(x^2),1/(x^3))
  names(data) <- c("cubic","square","identity","square root","log","1/(square root)",
                   "inverse","1/square","1/cubic")
  test <- shapiro.test(data$cubic)
  W.statistic <- as.numeric(test$statistic)
  p.value <- test$p.value
  Transformation <- "cubic"
  Formula <- "square"
  (results <- data.frame(Transformation, Formula, W.statistic, p.value))
  
  Ladder.x <- function(x){
    data <- data.frame(x^3,x^2,x,sqrt(x),log(x),1/sqrt(x),1/x,1/(x^2),1/(x^3))
    names(data) <- c("cubic","square","identity","square root","log","1/(square root)",
                     "inverse","1/square","1/cubic")
 #   options(scipen=3, digits = 3)
    test1 <- shapiro.test(data$cubic)
    test2 <- shapiro.test(data$square)
    test3 <- shapiro.test(data$identity)
    test4 <- shapiro.test(data$`square root`)
    test5 <- shapiro.test(data$log)
    test6 <- shapiro.test(data$`1/(square root)`)
    test7 <- shapiro.test(data$inverse)
    test8 <- shapiro.test(data$`1/square`)
    test9 <- shapiro.test(data$`1/cubic`)
    W.statistic <- c(test1$statistic, 
                     test2$statistic,
                     test3$statistic,
                     test4$statistic,
                     test5$statistic,
                     test6$statistic,
                     test7$statistic,
                     test8$statistic,
                     test9$statistic)
    p.value <- c(test1$p.value,
                 test2$p.value,
                 test3$p.value,
                 test4$p.value,
                 test5$p.value,
                 test6$p.value,
                 test7$p.value,
                 test8$p.value,
                 test9$p.value)
    Transformation <- c("cubic","square","identity","square root","log","1/(square root)",
                        "inverse","1/square","1/cubic")
    Formula <- c("x^3","x^2","x","sqrt(x)","log(x)","1/sqrt(x)","1/x","1/(x^2)","1/(x^3)")
    (results <- data.frame(Transformation, Formula, W.statistic, p.value))
  }  
  
  
  
  
  library(gvlma)
  gvmodel <- gvlma(Model1) 
  summary(gvmodel)
  plot.gvlma(gvmodel)
  