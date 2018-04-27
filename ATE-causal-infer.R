set.seed(25)
n <- 200
Z <- matrix(rnorm(4*n),ncol=4,nrow=n)
prop <- 1 / (1 + exp(Z[,1] - 0.5 * Z[,2] + 0.25*Z[,3] + 0.1 * Z[,4]))
treat <- rbinom(n, 1, prop)
Y <- 200 + 10*treat+ (1.5*treat-0.5)*(27.4*Z[,1] + 13.7*Z[,2] +
                                        13.7*Z[,3] + 13.7*Z[,4]) + rnorm(n)
X <- cbind(exp(Z[,1])/2,Z[,2]/(1+exp(Z[,1])),
           (Z[,1]*Z[,3]/25+0.6)^3,(Z[,2]+Z[,4]+20)^2)
#estimation of average treatment effects (ATE)
fit1<-ATE(Y,treat,X)
summary(fit1)
plot(fit1)



Y <- cattaneo2$bweight
X <- with(cattaneo2, cbind(fbaby, mmarried, alcohol, fedu, mage))
X <- with(cattaneo2, cbind(fbaby))
X <- with(cattaneo2, cbind(mage, mage^2))
treat <- cattaneo2$mbsmoke
fit1<-ATE(Y,treat,X, backtrack = FALSE)

summary(fit1)


X <- with(cattaneo2, cbind(mage, as.factor(fbaby), as.factor(prenatal)))
Y <- LogCat$fitted.values
fit2 <- ATE(Y, treat, X)
summary(fit2)


LogCat <- glm(lbweight ~ mbsmoke + mage + as.factor(fbaby) + as.factor(prenatal), data = cattaneo2, family = binomial(link = "logit"))
summary(LogCat)
predict(LogCat)

LogCat <- glm(lbweight ~ 1, data = cattaneo2, family = binomial(link = "logit"))
summary(LogCat)
predict(LogCat)
