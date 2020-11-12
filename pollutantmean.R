## Homework for week 2 in RProgramming class ##

pollutantmean <- function(directory, pollutant, id = 1:332){
        ## 'directory' is a character vector of length 1 indicating
        ## the location of the CSV files
        
        ## 'pollutant' is a character vector of length 1 indicating
        ## the name of the pollutant for which we will calculate the
        ## mean; either "sulfate" or "nitrate".  
        
        ## 'id' is an integer vector indicating the monitor ID numbers
        ## to be used
        
        ## Return the mean of the pollutant across all monitors list
        ## in 'id' vector ignoring NA values.
        ## Note: Do not round the result.
        
        ## Check for a valid directory:
        #directory = paste(getwd(),"/",directory,sep = "")
        stopifnot(dir.exists(directory))
        
        
        ## Check for a a valid pollutant:
        stopifnot(pollutant == "sulfate" || pollutant == "nitrate")
        
        
        pol_data <- data.frame()
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
                new_data <- read.csv(fpath)
                pol_data <- rbind(pol_data,new_data)
        }
        #print(pol_data[[pollutant]])
        mean(pol_data[[pollutant]],na.rm = TRUE)
        
          
}