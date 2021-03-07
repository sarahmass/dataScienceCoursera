---
title: "Classifying Bicep Curls"
author: "Sarah Massengill"
date: "3/4/2021"
output: html_document
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = FALSE,message = FALSE)
```

## Background

Using devices such as Jawbone Up, Nike FuelBand, and Fitbit it is now possible to collect a large amount of data about personal activity relatively inexpensively. These type of devices are part of the quantified self movement – a group of enthusiasts who take measurements about themselves regularly to improve their health, to find patterns in their behavior, or because they are tech geeks. One thing that people regularly do is quantify how much of a particular activity they do, but they rarely quantify how well they do it. In this project, your goal will be to use data from accelerometers on the belt, forearm, arm, and dumbbell of 6 participants. They were asked to perform barbell lifts correctly and incorrectly in 5 different ways. More information is available from the website here: http://groupware.les.inf.puc-rio.br/har (see the section on the Weight Lifting Exercise Dataset). 

Six young health participants were asked to perform one set of 10 repetitions of the Unilateral Dumbbell Biceps Curl in five different fashions:  
* Class A: exactly according to the specification  
* Class B: throwing the elbows to the front  
* Class C: lifting the dumbbell only halfway  
* Class D: lowering the dumbbell only halfway  
* Class E: throwing the hips to the front  

Read more: http://groupware.les.inf.puc-rio.br/har#ixzz6oBdIzdE6

## The Data

Provided for this project is a data set with 19622 observation total and 160 variables. Some of the variables are raw data collected from sensors attached at the bicep (labeled arm), wrist (labeled forearm), waist (labeled belt), and on the dumbbell.  There was no codebook given for further analysis into the variables. 

The data appears to be sets of time series data that takes one rep in a single 'window', and at the end of each bicep curl rep the raw data was used to create features to be further analyzed by the original researchers.  

The way we have been instructed to use the data is to treat each observation as independent since they have all been labeled a class variable. The validity of this process to classify the 'goodness' or 'badness' of a real world bicep curls on a single time instance of data is unknown.  It has been shown to be statistically successful with the separated testing data, and all three models achieved a 100% accuracy on the 20 samples held out of the provided training data set.  

## Summary of Results:
My first model used a random forest technique with a 25 bootstrapping resampling method.  This model reported a 95% confidence interval on the testing data of 98.69% to 99.22%. This method was nearly perfect on the training data and I am certain there is overfitting.  To combat the over fitting I created the second model.

My second model also used a random forest technique but included a 5-fold cross-validation resampling method. This reduced the accuracy slightly and resulted in a 95% confidence interval for accuracy of 98.75% to 99.27% for the out of sample error approximation.

The third and final method used a gradient boosting model with a 25 bootstrapping resampling method.  This model was less accurate on the testing set.  The 95% confidence interval puts the out of sample accuracy within 91.86% and 93.22%.  

All three models scored 100% on the 20 sample unlabeled test data.

## Cross Validation

I chose to create a training set and a test set. 70% of the observations provided were randomly selected using the R function from the caret package 'createDataPartition()'s to be in the training set and the other 30% were used for estimating out of sample error.  Further cross validation was employed within the models. 


  

## Tidying the Data

Since the 20 samples set asside to test our models were not time series sets, the variables that indicate time do not have any reasonable reason to be part of the model. The window variables also refer to the beginning and end of a time series, these won't be necessary either.  There are factor variables that were computed as averages or composites of all the window data, and these variables are only non-NA or non-empty at the end of a window, so these variables are removed from consideration.  Since each person performs 10 reps of each outcome, there is no reason to keep identifying variables as predictors. After noticing total columns for the acceleration of the arms, forearms, dumbbell, and belts, I selected only those variables and plotted the values vs the class.  There was no clear correlation with the total-variables between classes so those were removed. 

After removing all previously mentioned variables there were still a total of 49 possible predictors.  At this point I used my knowledge of form and weight lifting (decisions had to be made some how) and I decided to look at the rotation variables (row, pitch, and yaw) for each of the sensor positions.  Row and pitch are rotations about the two horizontal axes and the yaw is the rotation about the vertical axis.  With this final reduction I had 12 predictors to work.  Below are a list of the chosen predictor variables to work with.  

* roll_belt  
* pitch_belt  
* yaw_belt  
* roll_arm  
* pitch_arm  
* yaw_arm  
* roll_dumbbell  
* pitch_dumbbell  
* yaw_dumbbell  
* roll_forearm  
* pitch_forearm  
* yaw_forearm  


```{r getdata,echo=FALSE,message=FALSE}

## Download file
# url = "https://d396qusza40orc.cloudfront.net/predmachlearn/pml-training.csv"
# download.file(url,"./data/train.csv")
# url = "https://d396qusza40orc.cloudfront.net/predmachlearn/pml-testing.csv"
# download.file(url,"./data/test.csv")
```

```{r loadtrainingdata}
library(caret)
data<-read.csv("./data/train.csv")

## Create a "train" and "test" set from the training data
## use the testing data provided as a final validation step
set.seed(12345)
inTrain<-createDataPartition(y=data$classe, p = 0.7,list=FALSE)
training<-data[inTrain,]
testing<-data[-inTrain,]
```

```{r ExploreAndReduce, message=FALSE}
library(dplyr)
# str(testing)
# Many of the variables have a majority of the data as NA except when there was 
# a feature created by summarizing raw data.  Unfortunately, the test data was a
# subset of all entries not just the summarized features used by original researchers.
# This analysis will have to be a bit of a toy example that looks for 
# correlation between the predictors and the result and uses that to classify the 
# test data's output.  This is not a time series assignment.  :(

# collecting columns that don't have NA's in them

training$classe<-as.factor(training$classe)
is.na.cols<-apply(training,2,is.na)
is.na.cols<-apply(is.na.cols,2,sum)
is.na.cols<-is.na.cols[is.na.cols>0]
rem.col<-names(is.na.cols)
rem.col<-c(rem.col,"X","num_window")
training<-select(training,-c(where(is.character),grep("time",names(training)),rem.col))


#length(names(training)) ## started at 160 possible predictors
variables.to.keep<-names(training)
```

```{r,exploreCorelation,message=FALSE}
library(ggpubr)
#head(training)
#apply(training,2,range)"total_accel_belt"     "total_accel_arm"      "total_accel_dumbbell" "total_accel_forearm" 
a<-ggplot(data=training,aes(x=classe, y=total_accel_belt,fill=classe))+geom_boxplot()
b<-ggplot(data=training,aes(x=classe,y=total_accel_arm,fill=classe)) +geom_boxplot()
c<-ggplot(data=training,aes(x=classe,y=total_accel_dumbbell,fill=classe)) +geom_boxplot()
d<-ggplot(data=training,aes(x=classe,y=total_accel_forearm,fill=classe)) +geom_boxplot()
total.grid <- ggarrange(a,b,c,d,ncol = 2, nrow = 2)
annotate_figure(total.grid,
                top = text_grob("Figure 1: Distribution of the total_ Variables"
                                , color = "red", face = "bold", size = 12),
                bottom = text_grob("Data source: https://d396qusza40orc.cloudfront.net/predmachlearn/pml-training.csv",
                                    color = "blue",
                                    hjust = 0, x = 0, face = "italic", size = 8)
                )



```

```{r,PitchRowYaw}
## remove totals from the list.
inTot<-grep("total",names(training))
training<-select(training,-grep("total",names(training)))
#length(names(training))

# lets look pitch, roll, yaw of arm, belt, dumbbell,forearm.  These are
# rotations about the three axis. Based on my 
# experience these rotations often contribute to # incorrect form.
training<-select(training, c("classe",grep("pitch|roll|yaw",names(training))))
#length(names(training))
names(training)
testing<-select(testing,names(training))
```
## Analysis

```{r, parallel, message=F}
library(parallel)
library(doParallel)
cluster <- makeCluster(detectCores() - 1) # convention to leave 1 core for OS
registerDoParallel(cluster)
```
  
### Model 1: Random Forest With 25 Bootstrapped Resamples
The first models I chose to run was a random forest with all the default settings except for allowing for parallel processing.  This model did very good on the training data, too good.  It made no mistakes and this implies over fitting.  In a real world situation my test data would probably not do so well, especially since the test data was randomly chosen from data that was initially not independent because it was part of a time series data set.  Below you can see the results of the model fitting and the confusion matrix of the test set that was initially set aside.   
  
```{r,randomforest,cache=TRUE,warning=F} 
## resampling: bootstrapping, 25, takes just over 3 minutes to run
system.time(rf.mod<-train(x=training[,-1],y=training$classe,method='rf', trControl=trainControl(allowParallel = TRUE)))
rf.mod
trainpred<-predict(rf.mod,training[,-1])
confusionMatrix(trainpred,training$classe)$table
```

```{r, rfconfusion}


testpred<-predict(rf.mod,testing[,-1])

"Results of Testing Set"

confusionMatrix(testpred,factor(testing$classe))

```
### Model 2: Random Forest With 5-Fold Cross-Validation.
The second model used 5-fold cross validation and did  slightly less memorizing and is still overfitting. Below are the results of the model and the confusion matrix.  It still scores 100% accuracy on the training data and estimates the out of sample accuracy with a 95% confidence interval of 98.75% to 99.27% which is still unrealistic.  

```{r,rfwithcv,cache=TRUE, message=FALSE, warning=FALSE}
#takes almost 1 minutes to run
system.time(rfcv.mod<-train(x=training[,-1],y=training$classe,method='rf',trControl=trainControl(method='cv',number=5,allowParallel = TRUE)))

rfcv.mod



trainpred.cv<-predict(rfcv.mod,training[, -1])
confusionMatrix(trainpred.cv,training$classe)
```

```{r,rfcvConfusion}
"Results of Testing Set"
testpred.cv<-predict(rfcv.mod,testing[,-1])
confusionMatrix(testpred.cv,factor(testing$classe))
#

```

### Model 3: Gradient Boost Machine

The third model used Gradient boost to train the model, but used the defaults which used the 25 bootstrapping resampling.  This model did not score a perfect score (only 94%) like the others on the training data, and the testing set had an out of sample accuracy estimate less than the other two (92.5%). While lower accuracy it was still a quite respectable 95% confidence interval of 91.8% to 93.2%.

```{r,boostingmod, cache=TRUE}
system.time(gbm.mod<-train(x=training[,-1],y=training$classe,method='gbm',
                           trControl=trainControl(allowParallel = TRUE),verbose=F))

gbm.mod
trainpred.gbm<-predict(gbm.mod,training[,-1])
confusionMatrix(trainpred.gbm,training$classe)


```

  
All three models scored 100% on the 20 samples that came with out labels. Below is the visualization of the three models on the labeled testing data.
```{r gbmResults, message=F}
"Results on Testing Set:"
testpred.gbm<-predict(gbm.mod,testing[,-1])
confusionMatrix(testpred.gbm,factor(testing$classe))
```

```{r}
stopCluster(cluster)
registerDoSEQ()
```


```{r, 20testing variables}

valdata<-read.csv("./data/test.csv")
dim(valdata)


predval<-predict(rf.mod,valdata)
#predval


predval.cv<-predict(rfcv.mod,valdata)
#predval.cv

predval.gbm<-predict(gbm.mod,valdata)
#predval.gbm

twenty_sample_results<-data.frame(Sample_Number=c(1:20),Random_Forest=predval,Random_Forest.cv=predval.cv,
                                  Gradient_Boost=predval.gbm)

twenty_sample_results
```






```{r,plots}

rf.data<-data.frame(x=testing$classe,y=testpred)
a<-ggplot(data = rf.data, aes(x,y, color=y)) + geom_jitter()+
        ggtitle("Random Forest with Bootstrapping") +
        xlab("True Class") +
        ylab("Predicted")
         
rfcv.data<-data.frame(x=testing$classe,y=testpred.cv)
b<-ggplot(data=rfcv.data,aes(x,y, color=y)) +
        geom_jitter() +
        ggtitle("Random Forest with 5-Fold C-V") +
        xlab("True Class") +
        ylab("Predicted")

gbm.data<-data.frame(x=testing$classe,y=testpred.gbm)
c<-ggplot(data=gbm.data, aes(x,y,color=y)) +
        geom_jitter() + 
        ggtitle("Gradient Boost with Bootstrapping") +
        xlab("True Class") +
        ylab("Predicted")
ggarrange(a,b,c,ncol = 2, nrow = 2)
```

## Appendix

```{r,sessioninfo}
sessionInfo()
```
