---
title: |
  <center> Investigating the Effect of Vitamin C</center>
  <center> on Tooth Growth in Guinea Pigs </center>

author: "Sarah Massengill"
date: "2/2/2021"
output: pdf_document
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

```{r loaddata, results='hide',echo=FALSE, message=FALSE }
library(ggplot2)
library(dplyr)
data("ToothGrowth")
```
## Overview:
This report goes through a data exploration and performs several hypothesis tests on R's dataset ToothGrowth.  In Data exploration we see that as the dose of Vitamin C increases so do the tooth growth lengths.  While orange juice outperforms the ascorbic acid for the lower doses, the results between the two methods are indistinguishable at 2.0 mg/day. The hypothesis tests using the t-statistic value due to n being on the smaller side support the hunches made while exploring the data.  

## Data Exploration:
According to the R Documentation, ToothGrowth is a data set that detailed the length of a 60 guinea pigs teeth in response to three different doses of either vitamin C given delivered through orange juice (OJ) or an ascorbic acid supplement (VC).  The three doses were 0.5,1.0, and 2.0 mg/day.  The guinea pigs were grouped first by method, 30 were given OJ and 30 were given VC, and then by dose with 10 guinea pigs in each supplement/dose group. 


**Note**: As described in the Help file in R, the tooth length is measured in the "length of odontoblasts" which are cells responsible for tooth growth. Understanding these cells are out of the scope of this project so the lengths will not be labeled with units. 


To look at the names of the columns in the data frame a call to the r function names() is made. Below are the names and the R documentation definitions of the meaning for each variable.   

* Len = The length of guinea pig tooth growth. 
* supp = The supplement given to the guinea pigs: orange juice (OJ), or ascorbic acid (VC). 
* dose = The dose given to the guinea pigs: 0.5, 1.0, 2.0 mg/day. 

To explore data types, str() is called:

```{r explore.characteristics, echo=FALSE}
str(ToothGrowth)
```
Here it is clear that there are 60 guinea pigs in the study, the doses and the length are numeric values, and the supplements are Factor values with two levels.  Level 1 is OJ and level 2 is VC. 


To see how the guinea pigs are split into supplement-dose groups, a call to table is used.

```{r explore.distribution of pigs, echo=FALSE}
table(ToothGrowth$supp,ToothGrowth$dose)
```
There are 10 guinea pigs in each group.  Now to visualize the effects the tooth growth for the six groups a call to ggplot's boxplot is applied to the data. 


```{r, explore.boxplot,fig.height=2.5, echo=FALSE}

# New facet label names for dose variable
dose.labs <- c("dose: 0.5 mg/day", "dose: 1.0 mg/day", "dose: 2.0 mg/day")
names(dose.labs) <- c("0.5", "1", "2")

# New legend label names for supp variable
supp.labs <- c("OJ: Orange Juice", "VC: Ascorbic Acid")
names(supp.labs) <- c("OJ", "VC")

g <- ggplot(data=ToothGrowth,aes(x=supp, y=len, fill=supp)) +
     geom_boxplot() +
     facet_grid(~dose,
                labeller = labeller(dose=dose.labs)) +
     labs(y = "Tooth Growth", 
          x = "Supplement", 
          title = "Effect of Vitamin C on Guinea Pig Tooth Growth by Dose and Supplement") +
     scale_fill_discrete(labels = supp.labs) +
     theme(
             legend.position = "none",
             legend.direction = "horizontal",
             legend.title = element_blank()
     )
g
```


A quick look at the box plots of the data split into dose groups and then into supplement groups leads one to believe that OJ works better on average for the two lower doses, but seems to perform equally well as VC at the dose of 2mg/day. Another thing to notice is that the average increase from 0.5 mg/day to 1.0 mg/day is larger than the average increase from 1.0 mg/day to 2.0 mg/day.  This suggests a point of diminishing returns at about 1.0 mg/day, and one might even conclude that if data were collected for a 3mg/day dose that the average increase from 2.0 mg/day to 3.0 may be even less if any. Included in the appendix is a code sample and graph for data visualization from the RStudio documentation. Note the the larger slope between the 0.5 and 1.0 mg/day doses, than the slope between 1.0 and 2.0 mg/day doses.  

## Hypothesis Testing

Assumptions for hypothesis tests:
* The 60 guinea pigs represent an independent random sample from a normal distribution. 
* Guinea pigs were randomly assigned to the six dose-supplement groups.
* Variance with in the groups are equal

Note: All code and full t.test() outputs can be found in the appendix.

**\underline{Test 1}**   
The null hypothesis is that the dose amount does not matter. Ignoring the supplement given, the doses 0.5 and 1.0 mg/day result in the same average growth. The Alternative Hypothesis is that the larger dose of 1.0 mg/day does in fact effect the average tooth growth.  

\[H_o: \mu_{0.5}=\mu_{1.0},  \hspace{2cm}
H_a: \mu_{0.5}\not=\mu_{1.0}\] 

```{r,htest.1, echo=F}
dose0.5 <- ToothGrowth %>% filter(dose == 0.5) %>% select(len)
dose1.0 <- ToothGrowth %>% filter(dose == 1.0) %>% select(len)
results <- t.test(dose1.0,dose0.5, alternative = "two.sided", var.equal = T)
print(paste("results: p-value = ",
            round(results$p.value,9) ,
            ", confidence interval: [", 
            round(results$conf[1],2),
            ", "
            ,round(results$conf[2],2), "]",
            sep = ""))
```
The results of the non-paired two sample t-test with $n=20$ and an $\alpha = 0.05$ are in favor of rejecting the null hypothesis. With means $\mu_a = 19.735$ and $\mu_o = 10.606$, the p-value of $1.27 * 10^{-7}$ tells us that it is *very* rare that a difference in the mean values of 9 or more would occur if the null hypothesis were true. The confidence interval of $[6.28, 11.98]$ as expected agrees with the p-value determination of rejecting the null since zero is not in the $95\%$ confidence interval.    

**\underline{Test 2}**   
The null hypothesis is that the dose amount does not matter. Ignoring the supplement given, the doses 1.0 and 2.0 mg/day result in the same average growth. The Alternative Hypothesis is that the larger dose of 2.0 mg/day does in fact effect the average tooth growth.  

\[H_o: \mu_{1.0}=\mu_{2.0}, \hspace{2cm} 
H_a: \mu_{1.0}\not=\mu_{2.0}\]


```{r, htest.2, echo=F}
dose2.0 <- ToothGrowth %>% filter(dose == 2.0) %>% select(len)
results <- t.test(dose2.0,dose1.0, alternative = "two.sided", var.equal = T)
print(paste("results: p-value = ",
            round(results$p.value,7) ,
            ", confidence interval: [", 
            round(results$conf[1],2),
            ", "
            ,round(results$conf[2],2), "]",
            sep = ""))
```

The results of the non-paired two sample t-test with $n=20$ and an $\alpha = 0.05$ is in favor of rejecting the null hypothesis. With means $\mu_{1.0} = 19.735$ and $\mu_{2.0} = 26.10$, the p-value of $1.81* 10^{-5}$ tells us that it is rare that a difference of 9 or more in the mean values would occur if the null hypothesis were true. The confidence interval of $[3.74, 8.99]$ as expected agrees with the p-value determination of rejecting the null since zero is not in the $95\%$ confidence interval. 

**Note**: These two tests reveal that the dose does in fact have a statistical significance in the results of tooth growth.  


**\underline{Test 3}**   
The null hypothesis is that the supplement method does not matter when the dose is 0.5 mg/day, both orange juice and asorbic acid have the same average growth. The Alternative Hypothesis is when the dose is 0.5 mg/day the method of administering Vitamin C does effect the average tooth growth.  

\[H_o: \mu_{oj_{0.5}}=\mu_{vc_{0.5}}, \hspace{2cm}   
H_a: \mu_{oj_{0.5}}\not=\mu_{vc_{0.5}}\]


```{r,htest.3, echo=F}
suppOJ0.5<- ToothGrowth %>% filter(supp == "OJ" & dose== 0.5) %>% select(len)
suppVC0.5<- ToothGrowth %>% filter(supp == "VC" & dose== 0.5) %>% select(len)
results <- t.test(suppOJ0.5,suppVC0.5, alternative = "two.sided", var.equal = T)
print(paste("results: p-value = ",
            round(results$p.value,5) ,
            ", confidence interval: [", 
            round(results$conf[1],2),
            ", "
            ,round(results$conf[2],2), "]",
            sep = ""))
```

The p-value for this hypothesis test is 0.0053 which is smaller than .05, and the $95\%$ confidence interval for the change in means is $[1.77, 8.73] which does not contain zero.  So there is enough evidence to reject the null hypothesis.  And the we can see that the difference between OJ and VC at 0.5 mg/day is positive meaning that OJ has an average tooth growth larger than that of the ascorbic acid supplement. The mean change for Orange Juice is 13.23 while only 7.98 for ascorbic acid.  


**\underline{Test 4}**   
The null hypothesis is that the supplement method does not matter when the dose is 1.0 mg/day, both orange juice and asorbic acid have the same average growth. The Alternative Hypothesis is when the dose is 1.0 mg/day the method of administering Vitamin C does effect the average tooth growth.  

\[H_o: \mu_{oj_{1.0}}=\mu_{vc_{1.0}}, \hspace{2cm}  
H_a: \mu_{oj_{1.0}}\not=\mu_{vc_{1.0}}\]


```{r,htest.4, echo=F}
suppOJ1.0 <- ToothGrowth %>% filter(supp == "OJ" & dose== 1.0) %>% select(len)
suppVC1.0 <- ToothGrowth %>% filter(supp == "VC" & dose== 1.0) %>% select(len)
results <- t.test(suppOJ1.0,suppVC1.0, alternative = "two.sided", var.equal = T)
print(paste("results: p-value = ",
            round(results$p.value,5) ,
            ", confidence interval: [", 
            round(results$conf[1],2),
            ", "
            ,round(results$conf[2],2), "]",
            sep = ""))
```
The p-value for this hypothesis test is 0.00078 which is smaller than .05, and the $95\%$ confidence interval for the change in means is $[2.84, 9.02] which does not contain zero.  So, there is enough evidence to reject the null hypothesis.  And the we can see that the difference between OJ and VC at 1.0 mg/day is positive meaning that OJ has an average tooth growth larger than that of the ascorbic acid supplement. The mean change for Orange Juice is 22.70 while only 16.77 for ascorbic acid.


**\underline{Test 5}**   
The null hypothesis is that the supplement method does not matter when the dose is 2.0 mg/day, both orange juice and asorbic acid have the same average growth. The Alternative Hypothesis is when the dose is 2.0 mg/day the method of administering Vitamin C does effect the average tooth growth.  

**$H_o: \mu_{oj_{2.0}}=\mu_{vc_{2.0}}$,  
**$H_a: \mu_{oj_{2.0}}\not=\mu_{vc_{2.0}}$


```{r,htest.5, echo=F}
suppOJ2.0<- ToothGrowth %>% filter(supp == "OJ" & dose== 2.0) %>% select(len)
suppVC2.0<- ToothGrowth %>% filter(supp == "VC" & dose== 2.0) %>% select(len)
results<-t.test(suppOJ2.0,suppVC2.0, alternative = "two.sided", var.equal = T)
print(paste("results: p-value = ",
            round(results$p.value,2) ,
            ", confidence interval: [", 
            round(results$conf[1],2),
            ", "
            ,round(results$conf[2],2), "]",
            sep = ""))

```
This test actually shows a different result.  At a dose of 2.0 mg/day the null hypothesis is \underline{not} rejected.  The p-value of 0.9637 is significantly larger that 0.05 and the $95\%$ confidence interval, [-3.56, 3.72] contains zero almost exactly in the middle of the interval.  This means that on average the means for both orange juice and ascorbic acid at doses of 2.0 mg/day do not have statistically significant differences.  

\newpage
# Appendix

Names of columns:  
```{r explore.names}

names(ToothGrowth)
```
Table values of supplement-dose for data Exploration:


```{r, explore.summary}
data.summary <-ToothGrowth %>% group_by(supp,dose) %>%
                summarize(mean = mean(len), median = median(len), min = min(len), max = max(len))
data.summary


```
From RStudio Documentation:


```{r helpcode sample,fig.height=4,}
require(graphics)
coplot(len ~ dose | supp, data = ToothGrowth, panel = panel.smooth,
       xlab = "ToothGrowth data: length vs dose, given type of supplement")
```

hypothesis tests:

```{r,A.htest.1, }
dose0.5<- ToothGrowth %>% filter(dose == 0.5) %>% select(len)
dose1.0<- ToothGrowth %>% filter(dose == 1.0) %>% select(len)
t.test(dose1.0,dose0.5, alternative = "two.sided", var.equal = T)

```


```{r,A.htest.2}
dose2.0<- ToothGrowth %>% filter(dose == 2.0) %>% select(len)
t.test(dose2.0,dose1.0, alternative = "two.sided", var.equal = T)

```

```{r,A.htest.3}
suppOJ0.5<- ToothGrowth %>% filter(supp == "OJ" & dose== 0.5) %>% select(len)
suppVC0.5<- ToothGrowth %>% filter(supp == "VC" & dose== 0.5) %>% select(len)
t.test(suppOJ0.5,suppVC0.5, alternative = "two.sided", var.equal = T)

```

```{r,A.htest.4}
suppOJ1.0<- ToothGrowth %>% filter(supp == "OJ" & dose== 1.0) %>% select(len)
suppVC1.0<- ToothGrowth %>% filter(supp == "VC" & dose== 1.0) %>% select(len)
t.test(suppOJ1.0,suppVC1.0, alternative = "two.sided", var.equal = T)
```

```{r,A.htest.5}
suppOJ2.0<- ToothGrowth %>% filter(supp == "OJ" & dose== 2.0) %>% select(len)
suppVC2.0<- ToothGrowth %>% filter(supp == "VC" & dose== 2.0) %>% select(len)
t.test(suppOJ2.0,suppVC2.0, alternative = "two.sided", var.equal = T)

```