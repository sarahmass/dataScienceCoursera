## Homework for week 2 in RProgramming class ##
complete <- function(directory,id = 1:332){
        ## 'directory' is a character vector of length 1 indicating
        ## the location of the csv files.
        
        ## 'id' is an integer vector indicating the monitor ID numbers
        ## to be used
        
        ## Return a data frame of the form:
        ## id nobs
        ## 1  117
        ## 2  1041
        ## ...
        ## where 'id' is teh monitor ID number and 'nobs' is the
        ## number of complete cases
        
        ## Check for a valid directory:
        #directory = paste(getwd(),"/",directory,sep = "")
        stopifnot(dir.exists(directory))
        
        id_vec = c()
        nobs_vec = c()
        ## collect data from all monitors into one data.frame
        for (i in id) {
                if (i < 10){
                        id_num <- paste("00",i,sep = "")
                }else if (i < 100 ){
                        id_num <- paste("0",i,sep = "")
                }else{
                        id_num <- i
                }
                
                fpath <- paste(directory,"/",id_num,".csv", sep = '')
                new_data <-read.csv(fpath)
                cur_nobs <- sum(complete.cases(new_data))
                #new_data <-new_data[complete.cases(new_data),]
                id_vec <- c(id_vec,i)
                nobs_vec <- c(nobs_vec, cur_nobs)
        }
        
        data.frame(id = id_vec, nobs = nobs_vec)
}