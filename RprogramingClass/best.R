## function for programming assignment 3 in Rprogramming

## best takes two arguments: the 2-character abbreviated name of a state and the 
## outcome name.  It reads the 'outcome-of-care-measures.csv' file and returns a
## character vector with the name of the hospital that has the best (ie.lowest)
## 30-day mortality for the specified outcome in given state.  Hospitals with no
## data on "heart attack", "heart failure", or "pneumonia" are excluded from the
## set of hospitals when deciding the rankings.

## Data in the set should be sorted base on outcomes and then alphabetically by 
## hospital names

best <- function(state, outcome){
        ## read outcome data
        data <- read.csv("outcome-of-care-measures.csv", colClasses="character")
        
        ## check that state and outcome are valid
        statesvec <- unique(data$State)
        state <- toupper(state)
        if (!(state %in% statesvec)) stop("invalid state")
        if (!(outcome %in% c("heart attack", "heart failure","pneumonia"))){
                stop("outcome must be 'heart attack','heart failure', or 'pneumonia")
        }
        
        ## collect the rates for the 'outcome' in the given 'state'
        
        if (outcome == 'heart attack'){
                info <- data[data$State==state,c(2,11)]
        }else if (outcome == 'heart failure'){
                info <- data[data$State==state,c(2,17)]
        }else{
                info <- data[data$State==state,c(2,23)]
        }
        
        ## turn rates into numeric data
        info[,2] <- as.numeric(info[,2])
        #print(head(info))
        ## remove any incomplete data
        info <- info[complete.cases(info[,2]),]
        #print(head(info))
        ## sort first by rate and then by alphabet in ascending order
        info <- info[order(info[,2], info[,1]),]
        #print(head(info))       
        ## return the hospital with best rate ties going to the hospital 
        ## that comes first alphabetically
        info[1,1]
        
        

        
}

