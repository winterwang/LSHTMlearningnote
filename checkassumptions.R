## function to do graphical checks in one hit, given a model
## assumes that broom and gridExtra are available
## and that the model object has tidiers available
check_assumptions <- function(x, ...){
  if (inherits(x,"gam")){
    stop("check_assumptions doesn't work with gam() objects")
  }
  
  my_theme <- ggplot2::theme_classic() + 
    ggplot2::theme(text=ggplot2::element_text(size=rel(3)))
  
  # get the residuals etc.
  rr <- broom::augment(x)
  ## plot 0 resid vs. fitted
  rr0 <- ggplot2::ggplot(rr, ggplot2::aes(x = .fitted, y = .resid)) + 
    ggplot2::geom_point() + 
    ggplot2::geom_smooth() + 
    ggplot2::geom_hline(yintercept = 0, linetype=2) + 
    my_theme
  ## plot 1 qq plot
  # get int and slope for qqline
  probs <- c(0.25,0.75)
  y <- quantile(rr$.std.resid, probs, names = FALSE, na.rm = TRUE)
  x <- qnorm(probs)
  slope <- diff(y)/diff(x)
  int <- y[1L] - slope * x[1L]
  rr1 <- ggplot2::ggplot(rr, aes(sample=.std.resid)) + 
    ggplot2::geom_qq(size=rel(2)) + 
    ggplot2::geom_abline(intercept = int, slope = slope, linetype = 2, size = 1) +
    my_theme
  
  ## plot 2 scale location plot
  rr2 <- ggplot2::ggplot(rr, ggplot2::aes(x = .fitted, y = sqrt(abs(.std.resid)))) + 
    ggplot2::geom_point() + 
    ggplot2::geom_smooth() + 
    ggplot2::geom_hline(yintercept  = 1) +
    my_theme
  ## plot 3 cooks distance plot
  rr3 <- ggplot2::ggplot(rr, ggplot2::aes(.hat, .std.resid)) +
    ggplot2::geom_vline(size = 1, xintercept = 0) +
    ggplot2::geom_hline(size = 1, yintercept = 0) +
    ggplot2::geom_point(ggplot2::aes(size = .cooksd)) + 
    ggplot2::geom_smooth(se = FALSE) + 
    my_theme
  
  plot(gridExtra::arrangeGrob(rr0, rr1, rr2, rr3, nrow=2))
  
}
