library(rstan)
library(tidyverse)

tau = 0.4
n = 50
set.seed(123)
x = rnorm(n, 0, 1/sqrt(tau))

rsamp = 100000
y = rnorm(rsamp, 2.2, sqrt(3))
z = y/sqrt(3)
ggplot() +
  geom_density(aes(x = z^2)) +
  geom_density(aes(x = rchisq(rsamp, 1, 2.2^2/3)), color = "red")



sp_d <- list(N = n, y = x)

sp_fit <- stan('wishart.stan', data = sp_d, 
               iter = 5e3, chains = 1)

#save(sp_fit, file = "stan.RData")


load("stan.RData")
theta = log(sp_fit@sim$samples[[1]]$tau)
x_d = seq(-3,0,length.out = 500)
alpha_n = (n+1)/2
beta_n = (sum(x^2)+1)/2

ggplot() + 
  geom_density(aes(x = theta), color = "blue") +
  geom_line(aes(x = x_d, y = dnorm(x_d, log(alpha_n/beta_n), 1/sqrt(alpha_n))), color = "red")

# using a chi-square instead of normal
tau = sp_fit@sim$samples[[1]]$tau
ggplot() + geom_density(aes(x = tau), color = "blue") + 
  geom_density(aes(x = rchisq(1000, 1, 1/n)), color = "red")

ggplot() + geom_density(aes(x = rchisq(1000, 1, 1/n)), color = "red")



