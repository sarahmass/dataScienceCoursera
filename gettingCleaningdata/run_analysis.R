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

# STEP 0: Collect the Id labels, activity labels, column labels, test data
#         train data stored with in the directory "UCI HAR Dataset" with in the
#         working directory,"dataScienceCoursera/gettingCleaningdata"

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
names(test_data) <- c("subjectId", "activity", colNames[,2] )

# Gather the subject ID's for the train data
train_subjectId<- read.table("./UCI HAR DATAset/train/subject_train.txt")

# Gather the activity labels for the train data
train_activity <- read.table("./UCI HAR DATAset/train/y_train.txt")

# Gather the train data set
train_data <- read.table("./UCI HAR DATAset/train/X_train.txt")

# Combine the train data with the subject Id, and the activity label
train_data <- cbind(train_subjectId[,1], train_activity[,1], train_data)
names(train_data) <- c("subjectId", "activity", colNames[,2] )

#clean up temporary variables
rm(test_subjectId, test_activity, train_subjectId, train_activity, colNames)

# STEP 1: Merges the training and the test sets to create one data set.
data <- rbind(train_data, test_data)

# clean up temporary data variables
rm(test_data, train_data)





# STEP 2: Extracts only the measurements on the mean and standard deviation for each 
#         measurement.
library(dplyr)
data <- select(data,grep("mean|std",names(data),value = T))
# Uses descriptive activity names to name the activities in the data set
# Appropriately labels the data set with descriptive variable names.
# From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
