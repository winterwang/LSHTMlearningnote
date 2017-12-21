# design a function that helps to calculate the binomial distribution
# and draw the discrete graph
graph.binom <- function(n, p) {
  x <- (dbinom(0:n, size = n, prob = p))
  barplot(x, yaxt="n",
          col = "lightblue",
          ylim = c(0, 0.3),
          names.arg = 0:n, ylab = "Probability", xlab = "R (Number of successes)",
          main = sprintf(paste('Binomial Distribution (n,p)' , n, p, sep = ', ')))
  axis(2, at=c(seq(0, 0.4, 0.1), 0.025), las=2)
  abline(h=0.025, col = "Red", lty=2, lwd = 2)
}