



library(haven)
library(ggplot2)
library(ggthemes)
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
