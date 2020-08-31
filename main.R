library(rstan)
library(readr)

NOT_LOCAL = !Sys.info()['sysname'] == 'Darwin'
# https://cran.r-project.org/web/packages/rstan/vignettes/stanfit-objects.html
if (NOT_LOCAL) {
  options(mc.cores = parallel::detectCores())
  rstan_options(auto_write=TRUE)

  # Independent Variable
  x <- rnorm(50, 5, 2)

  #t- distributed noise
  noise <- rt(50, 3)

  y <- 5* x + noise

  my_model <- stan_model("my_model.stan")

  data <- list(x = x, y = y, N = length(x), nu = 3L)

  fit <- sampling(my_model, data, chains = 2, iter = 1000, refresh = 0)

  write_rds(x = fit, path = 'fit.rda')
  print(fit, pars = "beta", probs = c(0.025, 0.5, 0.975))
  summary(fit)
} else {
   system('touch fit.rda')
   system('docker-compose up --remove-orphans')
   fit = read_rds('fit.rda')
   pairs(fit)
   plot(fit)
 }
