<h1> Time Series and All It's Cousins </h1>
<p> The fullness and glory of these notes come from <a href="https://a-little-book-of-r-for-time-series.readthedocs.io/en/latest/src/timeseries.html">this</a> article.</p>
<hr>

<br>

<h3> Standard Time Series and R Built-ins</h3>
<hr>
<p> Time series exist in a lot of different fashions, for example </p>
<ul> 
<li>Per unit(1 column, N rows, ex) years) <- column-like</li>
<li>Per unit over a duration (d columns, N rows for d durations, ex) years and months, durations=12. e.g., rows=yearly observations, columns= jan-dec and each cell is the value) <- matrix-like(</li>
</ul>
<p> R has an interesting built-in class-type and function for timeseries named <em>ts(data=df, frequency=1, start=c(2000,1))</em> </p>
<p> </p>

<br>

<h3> Seasonal Time-Series</h3>
<hr>
<p> From several different sources, seasonal time series data, as found most commonly in economics has <strong>three components</strong>:</p>
<ul> 
<li>Seasonal (E.g., Spikes around December for clothing retailers, then sharp decrease following)</li>
<li>Trend (E.g., The general increase in AAPL stock over time)</li>
<li>Random (E.g., 1929's Great Depression Market Crash or 2008's Financial Market Crash; The pure nature/randomness/phenomina of a stochastic time series random variable)</li>
</ul>

<br>

<h3> Forcasting Time-Series</h3>
<hr>
<p> As found in the <em>library(forcast)</em> package in R, we can actually predict where the next value of a time series value will be.</p>
<ul> 
<li></li>
<li></li>
<li></li>
</ul>
<hr>
