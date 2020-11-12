## function for programming assignment 3 in Rprogramming

## rankhospital(state, outcome, num)
##      state: the 2-character abbreviated name of a state
##      outcome: "heart attack", "heart failure", or "pneumonia"
##      num: "best", "worst", or a number,n, indicating the nth best hospital
##           for the state and outcome pair
## Source data is read from 'outcome-of-care-measures.csv' file.
## Returns: a character vector with the name of the hospital
##          that has the best (ie.lowest) 30-day mortality for 
##          the specified outcome in given state.  

## Tie-breaker: results are ordered first by rate (best to worst) then by 
##              Hospital names in alphabetical order.So tie-breakers are 
##              awarded to the hospital name that comes first alphabetically 

rankhospital <- function(state, outcome, num="best"){
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
        
        ## return the nth best, best or worst hospital for state and outcome
        if (num==1 | num=="best"){
                return(info[1,1])
        }else if (num=="worst"){
                return(info[nrow(info),1])
        }else{
                return(info[num,1])
        }
        
        
        
        
        
}