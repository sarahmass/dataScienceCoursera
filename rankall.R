## function for programming assignment 3 in Rprogramming

## rankall(outcome, num)
##      outcome: "heart attack", "heart failure", or "pneumonia"
##      num: "best", "worst", or a number,n,indicating the nth best hospital
##           for each state and outcome pair
## Source data is read from 'outcome-of-care-measures.csv' file.
## Returns: a character vector with the name of the hospital
##          that has the best (ie.lowest) 30-day mortality for 
##          the specified outcome in given state.  

## Tie-breaker: results are ordered first by rate (best to worst) then by 
##              Hospital names in alphabetical order.So tie-breakers are 
##              awarded to the hospital name that comes first alphabetically 

rankall <- function(outcome,num = "best"){
        source("rankhospital.R")
        data = read.csv("outcome-of-care-measures.csv")
        states = as.vector(unique(data$State))
        #sort states in alphabetical order
        states <- states[order(states)]
        results <- data.frame()
        for (state in states){
                Hospital<-rankhospital(state,outcome,num)
                results<- rbind(results,data.frame(hospital = Hospital, state=state, row.names=state))
        }
        #rownames(results)<- states
        
        results
}