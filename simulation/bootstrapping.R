###
### Topic: Bootstrapping
### A random sample (with replacement) from a dataset D, repeated N times, providing N means that a 95% C.I can be ran on to determine a bound for the true mean.
###
### Sources:
### 1. https://en.wikipedia.org/wiki/Bootstrapping_(statistics)
### 2. https://stats.stackexchange.com/questions/83771/what-is-the-meaning-of-a-confidence-interval-taken-from-bootstrapped-resamples
### 3. https://www.thoughtco.com/example-of-bootstrapping-3126155
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
  includes[i] = boot.dist[25]<0 & 0<boot.dist[976] # if alpha=0.05, this is the 2.5% lowest index and highest,
                                                   # i.e., 1000*0.025=25 (lower). 1000*(1-0.025)=975 (upper)
}
mean(includes)     # this tells us the % of CIs that included the true mean
#[1] 0.952

###
### Additional notes:
### Example - Mean
### Since we are using bootstrapping to calculate a confidence interval about the population mean,
### we now calculate the means of each of our bootstrap samples. These means, arranged in ascending
### order are: 2, 2.4, 2.6, 2.6, 2.8, 3, 3, 3.2, 3.4, 3.6, 3.8, 4, 4, 4.2, 4.6, 5.2, 6, 6, 6.6, 7.6.
### Example - Confidence Interval
### We now obtain from our list of bootstrap sample means a confidence interval. Since we want a 90% 
### confidence interval, we use the 95th and 5th percentiles as the endpoints of the intervals. The 
### reason for this is that we split 100% - 90% = 10% in half so that we will have the middle 90% of
### all of the bootstrap sample means.
### For our example above we have a confidence interval of 2.4 to 6.6.
###