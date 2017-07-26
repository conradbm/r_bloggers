###
### Topic: Bootstrapping
### A random sample (with replacement) from a dataset D, repeated N times, providing N means that a 95% C.I can be ran on to determine a bound for the true mean.
###
### Sources:
### 1. 
### 2. https://stats.stackexchange.com/questions/83771/what-is-the-meaning-of-a-confidence-interval-taken-from-bootstrapped-resamples
###

# a function to perform bootstrapping
boot.mean.sampling.distribution = function(raw.data, B=1000){
  # this function will take 1,000 (by default) bootsamples calculate the mean of 
  # each one, store it, & return the bootstrapped sampling distribution of the mean
  
  boot.dist = vector(length=B)     # this will store the means
  N         = length(raw.data)     # this is the N from your data
  for(i in 1:B){
    boot.sample  = sample(x=raw.data, size=N, replace=TRUE)
    boot.dist[i] = mean(boot.sample)
  }
  boot.dist = sort(boot.dist)
  return(boot.dist)
}

# simulate bootstrapped CI from a population w/ true mean = 0 on each pass through
# the loop, we will get a sample of data from the population, get the bootstrapped 
# sampling distribution of the mean, & see if the population mean is included in the
# 95% confidence interval implied by that sampling distribution

set.seed(00)                       # this makes the simulation reproducible
includes = vector(length=1000)     # this will store our results
for(i in 1:1000){
  sim.data    = rnorm(100, mean=0, sd=1)
  boot.dist   = boot.mean.sampling.distribution(raw.data=sim.data)
  includes[i] = boot.dist[25]<0 & 0<boot.dist[976]
}
mean(includes)     # this tells us the % of CIs that included the true mean
#[1] 0.952