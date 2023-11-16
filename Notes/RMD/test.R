library(rstan)
library(tidyverse)

tau = 0.4
n = 50
set.seed(123)
x = rnorm(n, 0, 1/tau)

sp_d <- list(N = n, y = x)

sp_fit <- stan('wishart.stan', data = sp_d, 
               iter = 5e3, chains = 1)

save(sp_fit, file = "stan.RData")


load("stan.RData")
theta = log(sp_fit@sim$samples[[1]]$tau)
x_d = seq(-3,0,length.out = 500)
alpha_n = (n+1)/2
beta_n = (sum(x^2)+1)/2

ggplot() + 
  geom_density(aes(x = theta), color = "blue") +
  geom_line(aes(x = x_d, y = dnorm(x_d, log(alpha_n/beta_n), 1/sqrt(alpha_n))), color = "red")

