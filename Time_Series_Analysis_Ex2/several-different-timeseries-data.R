###################################################################
### Time series tutorial:
### https://a-little-book-of-r-for-time-series.readthedocs.io/en/latest/src/timeseries.html
####################################################################

###
### Time series recorded only yearly
### i.e., frequency=1
###
kings <- scan("http://robjhyndman.com/tsdldata/misc/kings.dat",
              skip=3)
kingstimeseries <- ts(kings) #default: frequency=1
kingstimeseries

###
### Sometimes the time series data set that you have may have been 
### collected at regular intervals that were less than one year, for ### example, monthly or quarterly. In this case, you can specify the
### number of times that data was collected per year by using the  
### ‘frequency’ parameter in the ts() function For monthly time 
### series data, you set 
### frequency=12, while for quarterly time series data, you set 
### frequency=4.
###
###
### Time series recorded yearly by 12 month intervals,
### i.e., frequency=12
###
births <- scan("http://robjhyndman.com/tsdldata/data/nybirths.dat")
birthstimeseries <- ts(births, frequency=12, start=c(1946,1))
birthstimeseries

###
### Again ...
### Time series recorded yearly by 12 month intervals,
### i.e., frequency=12
###
souvenir <- scan("http://robjhyndman.com/tsdldata/data/fancy.dat")
souvenirtimeseries <- ts(souvenir, frequency=12, start=c(1987,1))
logsouvenirtimeseries <- log(souvenirtimeseries)
souvenirtimeseries

plot(kingstimeseries)
plot(birthstimeseries)
plot(souvenirtimeseries)
plot(logsouvenirtimeseries)

###
### Estimating a trend component of non-seasonal data
###
### To estimate the trend component of a non-seasonal time series 
### that can be described using an additive model, it is common to 
### use a smoothing method, such as calculating the simple moving ### average of the time series.
###
### The simple moving average (SMA) function is inside of 
### library("TTR"), which allows for a smoothing method for 
### for estimating a time series data
###
install.packages("TTR")
library("TTR")

plot(kingstimeseries)
plot(SMA(kingstimeseries), n=10)

###
### Decomposing Seasonal Data
###
### Seasonality:
### http://www.itl.nist.gov/div898/handbook/pmc/section4/pmc443.htm
### Seasonality	Many time series display seasonality. By 
### seasonality, we mean periodic fluctuations. For example, 
### retail sales tend to peak for the Christmas season and then 
### decline after the holidays. So time series of retail sales 
### will typically show increasing sales from September through 
### December and declining sales in January and February.
###
### Seasonality is quite common in economic time series. It is less 
### common in engineering and scientific data.  
###
### A seasonal time series consists of a trend component, a 
### seasonal component and an irregular component. Decomposing 
### the time series means separating the time series into these 
### three components: that is, estimating these three component
###
plot(birthstimeseries)
birthstimeseriescomponents <- decompose(birthstimeseries)
names(birthstimeseriescomponents)
plot(birthstimeseriescomponents)


###
### Seasonality Adjusting
###
### Simply subtract the estimated seasonal (crazy spikes) component from
### our original data, then it won't act so dynamically around the 
### holidays, for example
###
birthstimeseriescomponents <- decompose(birthstimeseries)
birthstimeseriesseasonallyadjusted <- birthstimeseries - birthstimeseriescomponents$seasonal
plot(birthstimeseriesseasonallyadjusted)


###
### Forecasts using Exponential Smoothing
###
### Exponential smoothing can be used to make short-term ### forecasts for time series data.
###

###
### Time series recorded yearly starting in 1813,
###
rain <- scan("http://robjhyndman.com/tsdldata/hurst/precip1.dat",skip=1)
rainseries <- ts(rain,start=c(1813))
plot(rainseries)

###
### Exponential Smoothing (Fluctuations are constant)
###
### The random fluctuations in the time series seem to be ### roughly constant in size over time, so it is probably ### appropriate to describe the data using an additive ### model. Thus, we can make forecasts using simple 
### exponential smoothing.
###
###
### The output of HoltWinters() tells us that the 
### estimated value of the alpha parameter is about 0.024
### . This is very close to zero, telling us that the 
### forecasts are based on both recent and less recent 
### observations (although somewhat more weight is placed ### on recent observations).
###
###
rainseriesforecasts <- HoltWinters(rainseries, 
                                   beta=FALSE, 
                                   gamma=FALSE)
plot(rainseriesforecasts)


### 
### Forcasting into the future
###
###
install.packages('forcast')
library("forecast")
