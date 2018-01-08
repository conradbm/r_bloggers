# Algorithms.R

###
### Standard Decision Matrix Format (N+1)xD:
###
###               attribute1 attribute2 ... attributei ... attributeD
### weight     
### alternative1
### alternative2
### .
### .
### .
### alternativeN
###



### Function: TOPSIS
### Parameters: data.frame in read.data.matrix format
### Output: data.frame
###
### For more theory visit:
### 1. https://github.com/conradbm/madm/blob/master/Examples/SAW_and_Topsis.xls
TOPSIS <- function(DM){
  #DM <- data.frame(cost=as.numeric(runif(5,100, 200)),                                   #cost attribute, 100-200
  #             productivity=as.numeric(abs(rnorm(5))),                               #benefit attribute, abs(normalDist)
  #             location=as.numeric(floor(runif(5, 0, 5))),                           #benefit attribute, 0-5
  #             row.names = sprintf("alternative_%d",seq(1:5))
  #       )
  #w <- data.frame(t(matrix(c(0.45, 0.35, 0.2))))
  #names(w) <- names(DM)
  #DM <- rbind(w,DM)
  #row.names(DM)[1] = "weights"
  #DM
  
  weightVectorNormalize <- function(DM){
    VNDM <- DM
    for (i in 1:ncol(DM)){
      
      denom <- sqrt(sum(DM[,i]^2))
      
      for(j in 2:length(DM[,i])){
        
        VNDM[j,i] <- DM[1,i]*((DM[j,i])/denom)
      }
    }
    return(VNDM)
  }
  
  VNDM <- weightVectorNormalize(DM)
  #VNDM
  
  PNI <- function(DM){
    s <- data.frame(row.names=FALSE)
    for (name in names(DM)){
      p<-0
      n<-0
      if(grepl("cost", name)){
        # min is better
        p <- min(DM[2:nrow(DM),name])         #remember to ignore the weight row
        n <- max(DM[2:nrow(DM),name])         #remember to ignore the weight row
        #cat(name, "neg:",n,"\tpos:",p,"\n")
      }
      else{
        # max is better
        p <- max(DM[2:nrow(DM),name])         #remember to ignore the weight row
        n <- min(DM[2:nrow(DM),name])         #remember to ignore the weight row
        #cat(name, "neg:",n,"\tpos:",p,"\n")
      }
      
      s <- rbind(s,t(data.frame(c(name, p, n))))
    }
    
    # Structure labeling
    names(s) <- c("Name", "PositiveIdeal", "NegativeIdeal")
    row.names(s) <- names(DM)
    
    # Structure & Convert data
    d <- data.frame(t(s[,2:ncol(s)]))
    d2 <- data.frame(apply(d, 2, as.numeric))
    
    # Re-structure labeling
    names(d2) <- names(d)
    row.names(d2) <- row.names(d)
    
    return(d2)
  }
  ideals <- PNI(VNDM)
  #ideals
  
  distanceFromIdeals <- function(ideals, DM){
    SPlus <- c()
    SMinus <- c()
    for(i in 2:nrow(DM)){
      SPlus[i] <- sqrt(sum((DM[i,] - ideals[1,])^2))
      SMinus[i] <- sqrt(sum((DM[i,] - ideals[2,])^2))
    }
    return (data.frame(SPlus, SMinus))
  }
  
  S <- distanceFromIdeals(ideals, VNDM)
  row.names(S) <- row.names(VNDM)
  #S
  
  CStar <- data.frame(S[,2] / (S[,1]+S[,2]))
  names(CStar) <- "C"
  row.names(CStar) <- row.names(VNDM)
  
  # Next order them by descending, then return
  CStar$Rank <- rank(-CStar$C)
  CStar$Alternative <- row.names(CStar)
  row.names(CStar) <- NULL
  retDf <- CStar[2:nrow(CStar),c("Alternative", "C","Rank")]
  return(retDf)
}

###
### Function: sensitivity
### Parameters: data.frame in data.matrix format, 
###
### E.g.,
### sensitivity(cols=FALSE, step=0.01, data=dm, independent=TRUE, alg='TOPSIS')
###
### If cols=FALSE is true, we will independetly increment each weight on each 
### attribute and run the all specified with the step size given and create
### a data.frame matrix that will be plotable by ggplot or plotly to show which
### weights on each attribute would cause an 'outranking' relationship.
###
### I want to be able to plot several different viewpoints
###
### A stacked bar chart
### Overlapped lines showing independent changes
###
### Anything else?
sensitivity <- function(){
  
}

### Function: Utility
### Parameters: data.frame object in read.data.matrix format, vector of scales (linear, exponential, or logrithmic)
###
### For more theory visit: 
### 1. https://github.com/conradbm/madm/blob/master/Examples/MAUT.xls
### 2. https://github.com/conradbm/madm/blob/master/Examples/SAW_and_Topsis.xls
###
Utility <- function(DM, scales=c()){
  # if scales not null, save which function goes with each column
  # define min/maxs for each attribute
     # benefit attributes: ((val-min)/(max-min))
     # cost attributes: ((min-val)/(max- min))+1
  # normalize scores based on the linear scale
  # re-normalize any specified non-linear columns from the scales vector
  # sum each column after scaling each by their columns weights -- sumproduct
     # result = Dx2 data.frame to show an alternative, its score, and its rank.
  
  # bonus: bar chart 'Global Utility Score' with scores as yvalue and alternative as xvalue
  # bonus: instead of adding them all (SAW), just scale each alternative by each attribute, then plot
     # a stacked bar with x=alternative, y=value, color=attribute
}

### For more theory visit: 
### 1. https://github.com/conradbm/madm/blob/master/Examples/ELECTRE.xlsx
###
ELECTRE <- function(DM){
  
}

### For more theory visit: 
### 1. https://github.com/conradbm/madm/blob/master/Examples/PROMETHEE.xlsx
###
PROMETHEE <- function(DM){
  
}