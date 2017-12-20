



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