# https://hilaryparker.com/2014/04/29/writing-an-r-package-from-scratch/


setwd("C:/Users/1517766115.CIV/Desktop/Topics")
source("FileIO.R")
source("Algorithms.R")
dm <- read.data.matrix("file.csv", header=TRUE)
TOPSIS(dm)


