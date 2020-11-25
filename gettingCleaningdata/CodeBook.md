# CodeBook

The raw data can be found in several files within the [UCI HAR Dataset directory](https://github.com/sarahmass/dataScienceCoursera/tree/main/gettingCleaningdata/UCI%20HAR%20Dataset):

1. Measured variables can be found in test/X_test.txt, and train/X_train.txt.
   These files have a total of 10299 objects between the two of them, and have
   581 numeric values in each row.  Each row is a subject/activity observation.
   multiple observations of each subject/activity pair were recorded.
   
2. The activity numeric codes can be found in test/y_test.txt and train/y_train.txt
   These files together hold the 10299 activities that go with each row of measured 
   numeric data.
   
3. The subject Id's can be found in test/subject_test and train/subject_train.  
   There were 30 subjects who participated in the study and each subject was labeled
   with a number ranging from 1 to 30.  These values are also numerical 

4. The 561 variable names can be found in features.txt (and their explanations in 
   feature_info.txt). The tidied data set will only contain 79 of these variables.
   These variable names are characters and include dashes and 
   parentheses that will need to be removed. 
   
The data was provided by Davide Anguita, Alessandro Ghio, Luca Oneto, 
Xavier Parra and Jorge L. Reyes-Ortiz. A Public Domain Dataset for Human 
Activity Recognition Using Smartphones. 21th European Symposium on Artificial 
Neural Networks, Computational Intelligence and Machine Learning, 
ESANN 2013. Bruges, Belgium 24-26 April 2013.
   
### Step 0:

The data from each of the files above were read in using read.table() and stored
in temporary variables.  The ID's and the activity codes were merged with the 
numerical data using the cbind() method for both sets.  Then column names were
applied to the columns for each data set by assigning names(test_data) and 
names(train_data) the values: subjectId, activity, and the names read in from 
[feature.txt](https://github.com/sarahmass/dataScienceCoursera/blob/main/gettingCleaningdata/UCI%20HAR%20Dataset/features.txt).

At this point temporary variables that held the column names, the subject Id's and 
activities for each set can now be discarded from memory. So the rm() command is called
to clean up variables are taking up memory and will no longer be used.

### Step 1: 

The two data sets test_data and train_data are now complete with subject Ids, activity
labels and labeled variable data.  Now using the rbind() method the two data sets are 
combined in a single data. And the temporary variables holding the two partial data
sets are removed with the rm() command.  

### Step 2:

At the top of run_analysis.R, library(dplyr) was imported.  This allowed me to us
the select() function to select all variables that were a mean or a standard deviation
of the collected measurements.  I did this by grep()'ing the patter "mean|std". 
71 variables in addition to the subjectId and the activity variables.  At this stage
the dataframe dimensions are 10299 x 81.

### Step 3:

The table of activity codes and labels is stored in [activity_labels.txt](https://github.com/sarahmass/dataScienceCoursera/blob/main/gettingCleaningdata/UCI%20HAR%20Dataset/activity_labels.txt).  After reading in the table with read.table(), I mutated the data table by using the cut() method to convert the numerical class labels into factor labels with the readable labels: WALKING, wALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING,STANDING, and LAYING.  

### Step 4: 

The variable names that were assigned in step zero were readable labels, but they had special characters (dashes and parentheses) that would require them to be encased in `` when using them to subset the dataframe.  To fix this all dashes, "-" were replaced with dots "." (which are allowed in variable names in R) and all parentheses were removed. These changes were made using the gsub() method twice on names(data) and the names(data) were reassigned with these new modifications. The dataset was then written to the file [subActivity_all.txt](https://github.com/sarahmass/dataScienceCoursera/blob/main/gettingCleaningdata/subActivity_all.txt).

The variable values except for subject ID and activity, are all normalized measurement values bounded within [-1,1].  The original Acceleration units of measurements were in standard gravity units 'g' while the gyroscope measured angular velocity in radians/second. More about this can be read in the raw data's [ReadMe](https://github.com/sarahmass/dataScienceCoursera/blob/main/gettingCleaningdata/UCI%20HAR%20Dataset/README.txt).  


### Step 5:

From the data set in step 4, a new data set is created by first grouping the data by subjectId and activity using the group_by() method.  Then using the summarize_all method each of the 79 mean and standard deviation variables are averaged using the mean() function and stored in a new data frame.  This data frame is then written using write.table() to the file [SubActivity_means.txt](https://github.com/sarahmass/dataScienceCoursera/blob/main/gettingCleaningdata/SubActivity_means.txt).



### Variables:

[1] "subjectId"                      "activity"                      "tBodyAcc.mean.X"               "tBodyAcc.mean.Y"              
 [5] "tBodyAcc.mean.Z"               "tBodyAcc.std.X"                "tBodyAcc.std.Y"                "tBodyAcc.std.Z"               
 [9] "tGravityAcc.mean.X"            "tGravityAcc.mean.Y"            "tGravityAcc.mean.Z"            "tGravityAcc.std.X"            
[13] "tGravityAcc.std.Y"             "tGravityAcc.std.Z"             "tBodyAccJerk.mean.X"           "tBodyAccJerk.mean.Y"          
[17] "tBodyAccJerk.mean.Z"           "tBodyAccJerk.std.X"            "tBodyAccJerk.std.Y"            "tBodyAccJerk.std.Z"           
[21] "tBodyGyro.mean.X"              "tBodyGyro.mean.Y"              "tBodyGyro.mean.Z"              "tBodyGyro.std.X"              
[25] "tBodyGyro.std.Y"               "tBodyGyro.std.Z"               "tBodyGyroJerk.mean.X"          "tBodyGyroJerk.mean.Y"         
[29] "tBodyGyroJerk.mean.Z"          "tBodyGyroJerk.std.X"           "tBodyGyroJerk.std.Y"           "tBodyGyroJerk.std.Z"          
[33] "tBodyAccMag.mean"              "tBodyAccMag.std"               "tGravityAccMag.mean"           "tGravityAccMag.std"           
[37] "tBodyAccJerkMag.mean"          "tBodyAccJerkMag.std"           "tBodyGyroMag.mean"             "tBodyGyroMag.std"             
[41] "tBodyGyroJerkMag.mean"         "tBodyGyroJerkMag.std"          "fBodyAcc.mean.X"               "fBodyAcc.mean.Y"              
[45] "fBodyAcc.mean.Z"               "fBodyAcc.std.X"                "fBodyAcc.std.Y"                "fBodyAcc.std.Z"               
[49] "fBodyAcc.meanFreq.X"           "fBodyAcc.meanFreq.Y"           "fBodyAcc.meanFreq.Z"           "fBodyAccJerk.mean.X"          
[53] "fBodyAccJerk.mean.Y"           "fBodyAccJerk.mean.Z"           "fBodyAccJerk.std.X"            "fBodyAccJerk.std.Y"           
[57] "fBodyAccJerk.std.Z"            "fBodyAccJerk.meanFreq.X"       "fBodyAccJerk.meanFreq.Y"       "fBodyAccJerk.meanFreq.Z"      
[61] "fBodyGyro.mean.X"              "fBodyGyro.mean.Y"              "fBodyGyro.mean.Z"              "fBodyGyro.std.X"              
[65] "fBodyGyro.std.Y"               "fBodyGyro.std.Z"               "fBodyGyro.meanFreq.X"          "fBodyGyro.meanFreq.Y"         
[69] "fBodyGyro.meanFreq.Z"          "fBodyAccMag.mean"              "fBodyAccMag.std"               "fBodyAccMag.meanFreq"         
[73] "fBodyBodyAccJerkMag.mean"      "fBodyBodyAccJerkMag.std"       "fBodyBodyAccJerkMag.meanFreq"  "fBodyBodyGyroMag.mean"        
[77] "fBodyBodyGyroMag.std"          "fBodyBodyGyroMag.meanFreq"     "fBodyBodyGyroJerkMag.mean"     "fBodyBodyGyroJerkMag.std"     
[81] "fBodyBodyGyroJerkMag.meanFreq"



### R & Package Versions
R version 4.0.3 (2020-10-10) -- "Bunny-Wunnies Freak Out"
Copyright (C) 2020 The R Foundation for Statistical Computing
Platform: x86_64-w64-mingw32/x64 (64-bit)
attached packages:
attached base packages:
[1] stats     graphics  grDevices utils     datasets  methods   base     

other attached packages:
[1] ggplot2_3.3.2   Formula_1.2-4   survival_3.2-7  lattice_0.20-41 dplyr_1.0.2    




