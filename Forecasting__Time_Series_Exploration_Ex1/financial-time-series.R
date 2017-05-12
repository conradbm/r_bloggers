# Financial Time Series Data Example
# https://www.r-bloggers.com/financial-time-series-forecasting-an-easy-approach/

### Interesting findings:
### Time series data is stochastic w.r.t time
### We can estimate its change overtime using the X^2
### distribution when we want to know the standard deviation
### and whether our sample stddev is a good estimate.

### This tutorial is a great example of how one can look at 
### stochastic time series data and make predictions into the 
### future based on predicted population parameters

### When you are predicting values in the future, we can also predict our new
### standard deviations and means. ex) newStdev = oldStdev *sqrt(addedValue)

### Install Packages
install.packages('timeSeries')
install.packages('quantmod')

### Include Libraries
suppressPackageStartupMessages(library(timeSeries))
suppressPackageStartupMessages(library(quantmod))

### downloading stock price
getSymbols("AAPL")

### View the data
head(AAPL)

### using adjusted close price
Y <- coredata(AAPL[,"AAPL.Adjusted"])

### history time span, i.e., last 100 days
hist_start <- 1
hist_end <- 100
hist <- c(hist_start:hist_end)

### historical prices
(Y.hist <- Y[hist])

### historical returns = (Y(t1)-Y(t0))/Y(t0)
### Similar to AYPI; Average Yearly Return Increase
(Y.hist.ret <- returns(Y.hist))

### standard deviation computed based on history
paste(((sv_hist <- sd(Y.hist.ret, na.rm=T)) * 100),"% Average Yearly Deviation")

### Aboveshown value is the estimate of our standard deviation ### of our share price daily returns as determined by hystorical ### observations.

### It is a good practice to compute the confidence intervals ### for estimated parameters in order to understand if we have ### sufficient precision as implied by the samples set size.

### 95% confidence interval
###
### Note: Only works for K > 30
### X^2 formula:
### Let K = #samples - 1
###
### X^2 = K*(sample stddev)^2 / (pop stdev)
### We can solve for the pop stdev by setting it to the left
### (pop stdev) = K*(sample stddev^2) / X^2(mu=K, stdev=2*K)
### Do the above Eqn for both p=0.975 and p=0.025 to get the
### margin of error domain [lower, upper] for the actual 
### standard deviation for the stock price

n <- length(hist)
sv_hist_low <- sqrt((n-1)*sv_hist^2/qchisq(.975, df=n-1))
sv_hist_up <- sqrt((n-1)*sv_hist^2/qchisq(.025, df=n-1))
(sv_hist_confint_95 <- c(sv_hist_low, sv_hist, sv_hist_up))

### relative future time horizon
t <- 1:20

### martingale hypothesis (the average of future returns is equal to the current value)
### This drift value can change the way to future prediction ### behaves
u <- 0 #updated on line 140

### future expected value as based on normal distribution hypothesis
### In essense ...
### log(lastValueRecorded) + (drift - (1/2)*sample_stdev^2)*eachProjectedYearsPrediction
fc <- log(Y.hist[hist_end]) + (u - 0.5*sv_hist^2)*t

### lower bound 95% confidence interval
### Where we predict future stock in worst case
fc.lb <- fc - 1.96*sv_hist*sqrt(t)

### upper bound 95% confidence interval
### Where we predict future stock in best case
fc.ub <- fc + 1.96*sv_hist*sqrt(t)

### collecting lower, expected and upper values
fc_band <- list(lb = exp(fc.lb), 
                m = exp(fc),
                ub = exp(fc.ub))

### absolute future time horizon
xt <- c(hist_end + t)

### stock price history line plot
plot(Y[hist_start:(hist_end + max(t))], type='l',
     xlim = c(0, hist_end + max(t)),
     ylim = c(5, 20),
     xlab = "Time Index",
     ylab = "Share Price",
     panel.first = grid())

plot(Y[hist_start:(hist_end + max(t))], 
     type='l', # makes it a line
     xlim = c(0, hist_end + max(t)), # x domain
     ylim = c(5,20), # y range
     xlab = "Time Index",
     ylab = "Share Price",
     panel.first = grid() # puts a grid in background
     )  

### starting point for our forecast
suppressWarnings(points(x = hist_end, 
                        y = Y.hist[hist_end],
                        pch = 21, bg = "green"))

### lower bound stock price forecast
lines(x = xt, y = fc_band$lb, lty = 'dotted', col = 'violet', lwd = 2)

### expected stock price forecast
lines(x = xt, y = fc_band$m, lty = 'dotted', col = 'blue', lwd = 2)

### upper bound stock price forecast
lines(x = xt, y = fc_band$ub, lty = 'dotted', col = 'red', lwd = 2)


### The plot shows the lower (violet) and upper (red) bounds including the actual future 
### price evolution and the forecasted expected value (blue). In that, I did not account for ### a drift u (u = 0) and as a consequence, there is a flat line representing the future 
### expected value (actually its slope is slightly negative as determined by the -0.5*σ^2 
### term).

### If you like to have future stock price drift more consistent with its recent history, you ### may compute a return based on the same time scale of the standard deviation.

### added line of code
(mu_hist <- mean(Y.hist.ret, na.rm=T))

### 95% confidence interval for the mean
n <- length(hist)
mu_hist_low <- mu_hist - qt(0.975, df=n-1)*sv_hist/sqrt(n)
mu_hist_up <- mu_hist + qt(0.975, df=n-1)*sv_hist/sqrt(n)
(mu_hist_confint_95 <- c(mu_hist_low, mu_hist, mu_hist_up))

### drift computed on historical values
(u <- mu_hist)


### Furthermore, the code shown above can be easily enhanced with 
### sliders to specify the stock price history to take into account for ### parameters estimation and the desired future time horizon. That can ### be done by taking advantage of the manipulate package or by 
### implementing a Shiny gadget or application, for example.

### Using the same model is possible to compute the probability that ### the future stock price be above or below a predetermined value at ### time t. That is possible by computing the normal distribution 
### parameters as a function of ΔT = t – t0 and a density distribution ### basic property. Herein is how.

(curr_share_price <- Y.hist[hist_end])

### This is the mean mu_t of our normal distribution computed with ΔT= 10, ten units of time ### (days) ahead of the current time:
### Our prediction 10 units into the future
t <- 10
(mu_t <- log(curr_share_price) + u - 0.5*sv_hist^2)*t

### This is the standard deviation sv_t of our normal distribution computed with ΔT = 10, ten units of time (days) ahead of the current time:
### Predicted standard deviation 10 units into the future
(sv_t <- sv_hist*sqrt(t))

### Arbitrarly, I determine a target price 10% higher of the current one and hence equal to:

(target_share_price <- 1.10*curr_share_price)


### The probability that the share price at time t is equal or greater (please note the lower.tail = FALSE parameter) than the target price is the following:

pnorm(q = log(target_share_price), #because we chose the log version of the normal
      mean = mu_t,
      sd = sv_t,
      lower.tail = FALSE # equal to or greater than implication is why this is FALSE
      )
