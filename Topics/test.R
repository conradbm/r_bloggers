
setwd("C:/Users/1517766115.CIV/Desktop/Topics")
source("FileIO.R")
source("Algorithms.R")
dm <- read.data.matrix("file.csv", header=TRUE)
dm
TOPSIS(dm)

