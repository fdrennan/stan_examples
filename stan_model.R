library(rstan)
options(mc.cores = parallel::detectCores())
rstan_options(auto_write=TRUE)
X=rnorm(1000, mean=5, sd=1)

my_data = list(N=1000, X=X)

fit = stan(file = 'my_model.stan', data = my_data)

print(fit)
