// parameters{
//   real<lower = 0, upper = 1> p;
// }
// 
// model{
//   15 ~ binomial(30, p);
// }
data{
  int<lower = 1> N;
  int<lower = 0, upper = 10> y[N];
}

parameters{
  real<lower = 0, upper = 1> theta;
}

model{
  y ~ binomial(10, theta);
}
