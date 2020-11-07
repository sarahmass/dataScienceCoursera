## Homework for week 2 in RProgramming class ##
corr <- function(directory, threshold = 0){
        ## 'directory' is a character vector of length 1 indicating
        ## the location of the csv files.
        
        ## 'threshold' is a numeric vector of length 1 indicating the
        ## number of completely observed observations (on all variables)
        ## required to compute the correlation between nitrate
        ## and sulfate; the default is 0
        
        ## Return a numeric vector of correlations
        ## Note: do not round the result
        
        ## Check for a valid directory:
        #directory = paste(getwd(),"/",directory,sep = "")
        stopifnot(dir.exists(directory))
        data_files <- list.files(directory)
        comp_nums <- complete(directory)
        corr_vec <- c()
        
        idx <- which(comp_nums$nobs > threshold)
        for (i in idx){
                fpath <- paste(directory,"/",data_files[i], sep = '')
                #print(fpath)
                curr_data <- read.csv(fpath)
                cur_corr <- cor(curr_data$nitrate,curr_data$sulfate,use="complete.obs")
                #print(cur_corr)
                corr_vec <- c(corr_vec,cur_corr)
           
        }
        #print(length(corr_vec))
        corr_vec
}