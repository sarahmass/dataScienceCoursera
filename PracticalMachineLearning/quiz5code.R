set.seed(33833)

mod1<-train(y~., method='rf', data=vowel.train, prox=T)
mod2<-train(y~., method= 'gbm', data = vowel.train, verbose=F)

pred1<-predict(mod1,vowel.test)
pred2<-predict(mod2,vowel.test)

#model 1 accuracy:
acc.rf<-sum(pred1==vowel.test$y)/length(vowel.test$y)

#model 2 accuracy:
acc.gbm<-sum(pred2==vowel.test$y)/length(vowel.test$y)

# accuracy when the predictions agreed.
acc.agree<-sum(pred2==pred1 & pred2==vowel.test$y)/sum(pred2==pred1)

acc.rf
confusionMatrix(pred1,vowel.test$y)$
acc.gbm
acc.agree

#question 2:

set.seed(3433)
library(AppliedPredictiveModeling)
 
data(AlzheimerDisease)
adData = data.frame(diagnosis,predictors)

inTrain = createDataPartition(adData$diagnosis, p = 3/4)[[1]]
training = adData[ inTrain,]
testing = adData[-inTrain,]

set.seed(62433)

mod2.1<-train(diagnosis~.,method='rf', data = training)
mod2.2<-train(diagnosis~.,method='gbm', verbose=F,data = training)
mod2.3<-train(diagnosis~.,method='lda',data = training)

pred2.1<-predict(mod2.1,testing)
pred2.2<-predict(mod2.2,testing)
pred2.3<-predict(mod2.3,testing)

acc2.1<-sum(pred2.1==testing$diagnosis)/length(testing$diagnosis)
acc2.2<-sum(pred2.2==testing$diagnosis)/length(testing$diagnosis)
acc2.3<-sum(pred2.3==testing$diagnosis)/length(testing$diagnosis)

predDF<-data.frame(pred1=pred2.1,pred2=pred2.2,pred3=pred2.3,
                   diagnosis=testing$diagnosis)
combmod<-train(diagnosis~.,method='rf',data=predDF)
pred.comb<-predict(combmod,predDF)
acc.comb<-sum(pred.comb==testing$diagnosis)/length(testing$diagnosis)

#question 3

set.seed(3523)

library(AppliedPredictiveModeling)
library(elasticnet)

data(concrete)

inTrain = createDataPartition(concrete$CompressiveStrength, p = 3/4)[[1]]

training = concrete[ inTrain,]

testing = concrete[-inTrain,]

set.seed(233)
mod3<-train(CompressiveStrength~.,method='lasso',data=training)

plot.enet(mod3$finalModel, xvar = "penalty", use.color = TRUE) 
## cement is the last variable set to zero as the Lambda penalty increases



# question 4. 

library(lubridate) # For year() function below
library(forecast)

dat = read.csv("gaData.csv")

training = dat[year(dat$date) < 2012,]

testing = dat[(year(dat$date)) > 2011,]

tstrain = ts(training$visitsTumblr)

modfit<-bats(tstrain)
frcst.tumbler<- forecast(modfit,length(testing$date),level=c(95)) # length of testing is 235
tot.in.ci<-sum(testing$visitsTumblr>=frcst.tumbler$lower & testing$visitsTumblr<=frcst.tumbler$upper)
acc<-tot.in.ci/length(testing$date)
acc

# Question 5

set.seed(3523)

library(AppliedPredictiveModeling)
library(e1071)
data(concrete)

inTrain = createDataPartition(concrete$CompressiveStrength, p = 3/4)[[1]]

training = concrete[ inTrain,]

testing = concrete[-inTrain,]

set.seed(325)
modfit5<-svm(CompressiveStrength~.,training) #fit support vector machine to data
pred.5<-predict(modfit5,testing)
MSE<-sum((pred.5-testing$CompressiveStrength)^2)/length(testing$CompressiveStrength)
RMSE<-sqrt(MSE)
