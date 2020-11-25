# ReadMe
### Purpose:
This is a project for the 3rd course in Johns Hopkins University's Data Science 
Specialization offered by [Coursera](http://coursera.org).  The projects requires
that data to be gathered and tidied with the following stipulations:

Create one R script called run_analysis.R that does the following.

0. Read in all the necessary labels, data, column names, and subject Id's
   Appropriately labels the data set with descriptive variable names.(part of #4)
1. Merge the training and the test sets to create one data set.
2. Extract only the measurements on the mean and standard deviation for 
   each measurement.
3. Use descriptive activity names to name the activities in the data set 
4. Format the descriptive variable names that were added in #0 so that they can 
   be conveniently used with out being encased in ``. To do this the dashes, -, 
   and the parentheses,(), need to be removed from the variable names.
5. From the data set in step 4, create a second, independent tidy data 
   set with the average of each variable for each activity and each 
   subject.


### Raw data:

Source:
Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. A Public Domain Dataset for Human Activity Recognition Using Smartphones. 21th European Symposium on Artificial Neural Networks, Computational Intelligence and Machine Learning, ESANN 2013. Bruges, Belgium 24-26 April 2013.

The raw data is stored in the [UCI HAR Dataset directory](https://github.com/sarahmass/dataScienceCoursera/tree/main/gettingCleaningdata/UCI%20HAR%20Dataset)

Within the UCI HAR Dataset directory, there is a [ReadMe](https://github.com/sarahmass/dataScienceCoursera/blob/main/gettingCleaningdata/UCI%20HAR%20Dataset/README.txt) describing the data and how it was collected.  The subject ID's, normalized data, and activity labels will be found with in the sub-directories: [train](https://github.com/sarahmass/dataScienceCoursera/tree/main/gettingCleaningdata/UCI%20HAR%20Dataset/train) and [test](https://github.com/sarahmass/dataScienceCoursera/tree/main/gettingCleaningdata/UCI%20HAR%20Dataset/test).

The original purpose of the data was to use it to train a Neural Network to classify the activity being performed by each subject.  It was separated into two sets, a training set and a testing set.  The Neural Network required that the Id's, collected metrics, and the labeled outcome be saved in separate places.  Within their respective sub-directory the ID's can be found in the files labeled subject_train.txt and subject_test.txt, the data with 561 columns of collected metrics can be found in X_train.txt and X_test.txt, and the activity labels are in y_train.txt and y_test.txt.  Before the testing and training data can be merged the ID, activity, and data columns need to be merged together, and then the rows for the testing and training subjects can be merged.  

The metric data collected for each subject for each activity have the 561 row names found in the feature.txt file in the UCI HAR Dataset Directory.  The metric variables are described in the feature_info.txt file.  

  
### Getting and Cleaning the Data:

The raw data as described above will be cleaned as described in the Purpose section.  I have included a [CodeBook.md]({add link}) to detail my process, the code in [run_analysis.R](https://github.com/sarahmass/dataScienceCoursera/blob/main/gettingCleaningdata/run_analysis.R), and the two data sets in [subActivity_all.txt](https://github.com/sarahmass/dataScienceCoursera/blob/main/gettingCleaningdata/subActivity_all.txt) and [subActivity_means.txt](https://github.com/sarahmass/dataScienceCoursera/blob/main/gettingCleaningdata/subActivity_means.txt).





