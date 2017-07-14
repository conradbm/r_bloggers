###### Author: Blake Conrad### Get a time series sequence by half hour for any ### specified number of days N.######
get_sequence_of_days_by_half_hour <- function(days){  start <- as.POSIXct("2017-01-01")  interval <- 30 #mins    end <- start + as.difftime(days, units="days")    seq(from=start, by=interval*60, to=end)}
time_scale <- get_sequence_of_days_by_half_hour(5)time_scale <- lapply(as.list(time_scale), as.character)time_scale
