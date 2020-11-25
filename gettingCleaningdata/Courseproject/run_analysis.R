# run_analysis.R by Sarah Massengill, in November 2020 for the 
# purpose of fulfilling the requirements for the Course Project in "Getting 
# and Cleaning Data", the third course in Johns Hopkins' Data Science 
# Specialization on Coursera.  

# R version 4.0.3 (2020-10-10) -- "Bunny-Wunnies Freak Out"
# Copyright (C) 2020 The R Foundation for Statistical Computing
# Platform: x86_64-w64-mingw32/x64 (64-bit)

# The data was provided by Davide Anguita, Alessandro Ghio, Luca Oneto, 
# Xavier Parra and Jorge L. Reyes-Ortiz. A Public Domain Dataset for Human 
# Activity Recognition Using Smartphones. 21th European Symposium on Artificial 
# Neural Networks, Computational Intelligence and Machine Learning, 
# ESANN 2013. Bruges, Belgium 24-26 April 2013.

library(dplyr)

################################################################################
# STEP 0: Collect the Id labels, activity labels, column labels, test data     #
#         train data stored with in the directory "UCI HAR Dataset" with in the#
#         working directory,"dataScienceCoursera/gettingCleaningdata"          #
################################################################################

# Gather the 561 column names for the test and train data sets
colNames<- read.table("./UCI HAR DATAset/features.txt")

# Gather the subject ID's for the test data
test_subjectId<- read.table("./UCI HAR DATAset/test/subject_test.txt")

# Gather the activity labels for the test data
test_activity <- read.table("./UCI HAR DATAset/test/y_test.txt")

# Gather the test data set
test_data <- read.table("./UCI HAR DATAset/test/X_test.txt")

# combine the test data with the subject Id, and the activity label
test_data <- cbind(test_subjectId[,1], test_activity[,1], test_data)

# Appropriately labels the data set with descriptive variable names.
names(test_data) <- c("subjectId", "activity", colNames[,2] )

# Gather the subject ID's for the train data
train_subjectId<- read.table("./UCI HAR DATAset/train/subject_train.txt")

# Gather the activity labels for the train data
train_activity <- read.table("./UCI HAR DATAset/train/y_train.txt")

# Gather the train data set
train_data <- read.table("./UCI HAR DATAset/train/X_train.txt")

# Combine the train data with the subject Id, and the activity label
train_data <- cbind(train_subjectId[,1], train_activity[,1], train_data)

# Appropriately labels the data set with descriptive variable names.
names(train_data) <- c("subjectId", "activity", colNames[,2] )

#clean up temporary variables
rm(test_subjectId, test_activity, train_subjectId, train_activity, colNames)

###############################################################################
# STEP 1: Merges the training and the test sets to create one data set.       #
###############################################################################

data <- rbind(train_data, test_data)

# clean up temporary data variables
rm(test_data, train_data)




################################################################################
# STEP 2: Extracts only the measurements on the mean and standard deviation    #  
#         for each measurement.                                                #
################################################################################

data <- select(data,subjectId, activity, grep("mean|std",names(data),value = T))

################################################################################
# STEP 3: Uses descriptive activity names to name the activities in the data   #
#         set. The activity codes and labels are stored in a file. The file is #
#         read in and the labels are used to convert the activities from       #
#         numeric codes to factor labels.                                      #
################################################################################

# Read activity code and label pairs from file
activity_tbl <- read.table("./UCI HAR DATAset/activity_labels.txt",
                              col.names=c("code", "label"))

# Activity Labels: WALKING, wALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING,
# STANDING, and LAYING.
data <- mutate(data, activity = cut(data$activity,breaks = 6,
                                    labels = activity_tbl$label))

################################################################################
# STEP 4: Appropriately label variables with descriptive names. This was mostly#
#         done in step 0. Here the variable names are fixed to exclude symbols #
#         dashes and parentheses to make them more convenient for further      #
#         analysis (they won't need to be encased in ``).                      #
################################################################################

names(data) <- gsub("\\()","", names(data))
names(data) <- gsub("-", ".", names(data))

# Write data set to a .csv file:
write.table(data, file = "subActivity_all.txt", row.names = FALSE)


################################################################################
# STEP 5: From the data set in step 4, creates a second, independent tidy data #  
#         set with the average of each variable for each activity and each     #
#         subject.                                                             #
################################################################################

# Group by subjectId and activity, then find the mean of each variable for each 
# subjectId, activity pair. 

SubActivityMeans <- data %>% group_by(subjectId, activity) %>%
                             summarize_all(mean,.groups="keep")

#write dataframe to .csv file:
write.table(SubActivityMeans, file="subActivity_means.txt", row.names = FALSE)