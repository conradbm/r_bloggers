# FileIO.R

###
### Function: read.data.matrix
### Parameters: path= path to file and header if columnames provided
###
### Convert a standard import of:
###
###         name      x1  x2  x3
###1       weight    0.2 0.2 0.6
###2 alternative1    0.5 0.5 0.5
###3 alternative2    0.5 0.5 0.5
###4 alternative3    0.5 0.5 0.5
###
### into (with rownames instead of a rownames column):
###
###              x1  x2  x3
### weight       0.2 0.2 0.6
### alternative1 0.5 0.5 0.5
### alternative2 0.5 0.5 0.5
### alternative3 0.5 0.5 0.5
###
read.data.matrix <- function(path, header=TRUE){
  dm <- read.csv(path, header=header)
  row.names(dm) <- dm[,1]
  dm <- dm[,2:ncol(dm)]
  dm
}