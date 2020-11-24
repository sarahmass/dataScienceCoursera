
## Purpose:
This is a project for the 3rd course in Johns Hopkins University's Data Science 
Specialization offered by [Coursera](http://coursera.org).  The projects requires
that data to be gathered and tidied with the following stipulations:

Create one R script called run_analysis.R that does the following.

        1. Merge the training and the test sets to create one data set.
        2. Extract only the measurements on the mean and standard deviation 
           for each measurement.
        3. Use descriptive activity names to name the activities in the data set
        4. Appropriately labels the data set with descriptive variable names.
        5. From the data set in step 4, creates a second, independent tidy data 
           set with the average of each variable for each activity and each 
           subject.


## Raw data:

Source:
Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. A Public Domain Dataset for Human Activity Recognition Using Smartphones. 21th European Symposium on Artificial Neural Networks, Computational Intelligence and Machine Learning, ESANN 2013. Bruges, Belgium 24-26 April 2013.

The raw data is stored in the [UCI HAR Dataset directory](https://github.com/sarahmass/dataScienceCoursera/tree/main/gettingCleaningdata/UCI%20HAR%20Dataset)

Within the UCI HAR Dataset directory, there is a [ReadMe](https://github.com/sarahmass/dataScienceCoursera/blob/main/gettingCleaningdata/UCI%20HAR%20Dataset/README.txt) describing the data and how it was collected.  The data that has been drawn upon for this project is found in both the train and test folders.  Since we are gathering data to anazyse it rather than to train a Classification Neural Neural Network the data needs to be brought together into a single dataframe, participant id's, the activity, and collected feature values need to be pulled together first.  The participants' id's have been separated from the collected metrics because the ID is needed for the job of classifying each activity. ID's are saved in the files called subject_test.txt and subject_train.txt.  Since the Neural Network was being trained to take in the collected metrics to classify the activity as Walking, Walking Upstairs, Walking Downstairs, or laying down, the actual activity tags were separated out of the data file as well to be used in the error analysis of the Neural Network.  The activities for each experiment(or row of ID and Data) can be found in the files labeled y_test.txt and y_train.txt.  The collected metrics are found in the files X_test.txt and X_   






