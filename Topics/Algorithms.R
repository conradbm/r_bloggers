# Algorithms.R

### Function: TOPSIS
### Parameters: data.frame object in read.data.matrix format
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
### Thus, the shape is (N+1)xD for N alternatives accross D attributes with 1 single weight row 1.
###
TOPSIS <- function(DM){
  #DM <- data.frame(cost=as.numeric(runif(5,100, 200)),                                   #cost attribute, 100-200
  #             productivity=as.numeric(abs(rnorm(5))),                               #benefit attribute, abs(normalDist)
  #             location=as.numeric(floor(runif(5, 0, 5))),                           #benefit attribute, 0-5
  #             row.names = sprintf("alternative_%d",seq(1:5))
  #  )
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
  
  CStar <- data.frame(S[,2] / (S[,1]-S[,2]))
  names(CStar) <- "C"
  row.names(CStar) <- row.names(VNDM)
  
  # Next order them by descending, then return
  
  return(CStar)
}

###
### Function: sensitivity
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