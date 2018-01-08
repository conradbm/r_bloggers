# https://hilaryparker.com/2014/04/29/writing-an-r-package-from-scratch/


setwd("C:/Users/1517766115.CIV/Desktop/Topics")
source("FileIO.R")
source("Algorithms.R")
dm <- read.data.matrix("maut_validate.csv", header=TRUE)
topsisRes <-TOPSIS(dm)
topsisRes

dm
mautRes <- MAUT(dm, scales=c("linear","linear","linear"))
mautRes


library(ggplot2)
ggplot(data=topsisRes, aes(x=Alternative,y=Rank,color=as.factor(Rank))) + geom_point()
