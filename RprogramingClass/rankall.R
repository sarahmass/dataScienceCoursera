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
        #source("rankhospital.R")
        data = read.csv("outcome-of-care-measures.csv", 
                        na.strings = "Not Available",
                        stringsAsFactors = FALSE)
        
        ## get valid (unique) states and sort them alphabetically
        states = as.vector(unique(data$State))
        states <- states[order(states)]
        
        ## associate outcome names and columns in the original data w/ each other. 
        outnames<-c("heart attack"=11, 'heart failure'=17, 'pneumonia'=23)
        if (!(outcome %in% names(outnames))){
                stop("outcome must be 'heart attack','heart failure', or 'pneumonia'")
        }
        ## get only necessary columns:
        info <- data[,c(2,7,outnames[outcome])]
        colnames(info) <- c('hospital', 'State', outcome)
        info <- info[order(info[,2],info[,3],info[,1]),]
        info <- info[complete.cases(info),]
        
        info <- split(info,info$State)
        
        
        hosp_list<-sapply(info,function(x,n=num){
                #print(x)
                if (n=='best'){
                        return(x[1,1])
                }else if (n=='worst'){
                        return(x[nrow(x),1])
                }else {
                        return(x[n,1])
                }
        })
        # results <- data.frame()
        # for (state in states){
        #         Hospital<-rankhospital(state,outcome,num)
        #         results<- rbind(results,data.frame(hospital = Hospital, state=state, row.names=state))
        # }
        #rownames(results)<- states
        
        cbind(hosp_list,states)
        
}