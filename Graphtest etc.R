library(ggplot2)
library(ggthemes)
library("gridExtra")
library("ggsci")


hist(Chol$chol1)
curve(dnorm(x, mean=mean(Chol$chol1), sd=sd(Chol$chol1)), add=TRUE)

ggplot(Chol, aes(x=chol1)) + geom_histogram(binwidth = 22, fill="white", colour="#5F9EA0") + 
  theme_economist() 
