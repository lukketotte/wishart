data {
  int<lower=0> N;
  vector[N] y;
}

parameters {
  real<lower=0> tau;
}

transformed parameters{
  real theta;
  theta = log(tau);
}

model {
  tau ~ chi_square(1);
  y ~ normal(0, 1/sqrt(exp(theta)));
}

