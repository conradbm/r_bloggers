<h2> Financial Time Series Predictive Analysis </h2>

<h4>The tutorial associated with this code is here: <a href="https://www.r-bloggers.com/financial-time-series-forecasting-an-easy-approach/"></h4>

<h4>The key takeaways from this r-bloggers snippet are:</h4>

<ul> 
<li>library(timeSeries) Package introduction</li>
<li>coredata() method to rip out a column of time series values (assumed to be in time advancing format)</li>
<li>Pick a range of values from your data (say the last 100 days)</li>
<li>timeSeries::returns(yearEarningsList) Calculates each years returns --> based on this formula: (Y(t1)-Y(t0))/Y(t0)</li>
<li>Constructing a 95% Confidence Interval using the Chi Squared Distribution
    <ul> 
    <li>Allows us to solve for unknown standard deviation, by approximating --> popStdev = (sample stddev / X^2 )</li>
    <li>Get the lower tail probability based on p=0.025</li>
    <li>Get the upper tail probability based on p=0.975</li>
    <li><strong>This lets us know whether we should throw out our sample stddev</strong></li>
    </ul>
</li>
<li>Use a lognormal distribution to approximate #t units into the future
    <ul> 
    <li> Use the log distro to get our expected</li>
    <li> Use (expected - 1.96 * stdev *sqrt(t)) for the lower approx</li>
     <li> Use (expected + 1.96 * stdev *sqrt(t)) for the lower approx</li>
    </ul>
</li>

<li> By repeating the process for the mean, we get a better drift value to approximate better.</li>

<li> By accomplishing the above, we can now plot out of projected bounds into the future, and as was shown, it projected correctly.</li>

<li> Additionally, we can predict based on a log normal distro, mean approximated above, stdev approximated above, and lower.tail= FALSE, 
to determine what the probability might be of getting a 10% increase in share price next year for example.</li>

</ul>
