#Following along in R Week 1


## Lesson 1, Video 2: Exploratory Graphs: part 1

pollution <- read.csv("data/avgpm25.csv", colClasses = c("numeric",
                     "character","factor", "numeric", "numeric"))

head(pollution)

#       pm25  fips region longitude latitude
# 1  9.771185 01003   east -87.74826 30.59278
# 2  9.993817 01027   east -85.84286 33.26581
# 3 10.688618 01033   east -87.72596 34.73148
# 4 11.337424 01049   east -85.79892 34.45913
# 5 12.119764 01055   east -86.03212 34.01860
# 6 10.827805 01069   east -85.35039 31.18973

# fips is a region id

## one dimensional summaries
## 1.  five number summary:
summary(pollution$pm25)

# units are micrograms/m^3 
#Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
# 3.383   8.549  10.047   9.836  11.356  18.441 
# Median and the mean are below the stadard of 12 micrograms/m^3
# but the max is not, so there are some counties where the standard
# is not met at least during this time period. 

boxplot(pollution$pm25, col = "blue")

hist(pollution$pm25, col = "green")
rug(pollution$pm25)

# change the number of bars shown with in the
# plot.  too many=too noisy, not enough=hides distribution shape
hist(pollution$pm25, col = "green",breaks = 100)
rug(pollution$pm25)

## add a line to show the cut off for the max allowed measurement
boxplot(pollution$pm25, col = "blue")
abline(h = 12)

## add abline to a histogram:
hist(pollution$pm25, col = "green")
abline(v = 12, lwd = 2)
abline(v = median(pollution$pm25), col = "magenta", lwd = 4)
abline(v = mean(pollution$pm25), col = "blue", lwd = 2)

# region is a categorical variable, so this is a nice way
# to summarize categorical variables.  There are more than 400
# counties in the East, and about 125 or so in the West.
barplot(table(pollution$region),col = "wheat", main = "Number of
        Counties in Each Region")


## Lesson 1 Video 3 Exploratory Graphs (part 2)
# plot two dim. data by plotting box plots or pm25 with respect to 
# region:
boxplot(pm25 ~ region, data = pollution, col = "red")

#similar type of plot with histograms:
par(mfrow = c(2,1), mar = c(4,4,2,1))
hist(subset(pollution,region=="east")$pm25, col = "green")
hist(subset(pollution,region=="west")$pm25, col = "green")

#scatter plot, col = region gives different colors for each region
with(pollution, plot(latitude,pm25, col = region))
abline(h = 12, lwd = 2, lty = 2)

# multiple colorscatter plots.  
par(mfrow = c(1,2), mar = c(5,4,2,1))
with(subset(pollution,region == "west"), plot(latitude,pm25, main = "West"))
with(subset(pollution,region == "east"), plot(latitude,pm25, main = "East"))

## Lesson 2: Plotting

# L2,v1: plotting systems in R:

# simple Base Plot
library(datasets)
data(cars)
# speed vs stopping distance
with(cars, plot(speed, dist))

library(lattice)
state<- data.frame(state.x77, region = state.region)
xyplot(Life.Exp ~ Income | region, data = state,
       layout = c(4,1))

library(ggplot2)
data(mpg)
qplot(displ,hwy,data = mpg)

Lesson 2, Video 2: Base Plotting (part 1)

# ?par will open the page for parameter information
# ?plot will give the default methods for plot graphs

library(datsets)
hist(airquality$Ozone)


with(airquality, plot(Wind,Ozone))

airquality<- transform(airquality,Month = factor(Month))
boxplot(Ozone ~ Month, airquality, xlab="Month", ylab="Ozone (ppb)")

## Leson 2 video 3: Base plotting system (part 2)

## Example 1
with(airquality, plot(Wind,Ozone))
# add a title:
title(main = "Ozone and Wind in New York City")

## Example 2:
with(airquality, plot(Wind,Ozone,
    main = "Ozone and Wind in New York City"))
with(subset(airquality, Month == 5), points(Wind, Ozone, col="blue"))

## Example 3:
with(airquality, plot(Wind,Ozone,
                      main = "Ozone and Wind in New York City",
                      type = "n"))
with(subset(airquality, Month == 5), points(Wind, Ozone, col="blue"))
with(subset(airquality, Month != 5), points(Wind,Ozone,col="red"))
legend("topright", pch = 1, col = c("blue", "red"),
       legend = c("May","Other Months"))

## Example 4:
with(airquality, plot(Wind,Ozone,
                      main = "Ozone and Wind in New York City",
                      pch=20))
## find a regression line using the lm() function
model<- lm(Ozone ~ Wind, airquality)
## draw in the line found by lm() to the plot
abline(model,lwd = 2)

## Example 5:
par(mfrow=c(1,2))
with(airquality, {
        plot(Wind,Ozone, main="Ozone and Wind")
        plot(Solar.R, Ozone, main = "Ozone and Solar Radiation")
        })
## Example 6:
par(mfrow=c(1,3), mar = c(4,4,2,1), oma = c(0,0,2,0))
with(airquality,{
        plot(Wind,Ozone, main="Ozone and Wind")
        plot(Solar.R, Ozone, main = "Ozone and Solar Radiation")
        plot(Temp,Ozone,main = "Ozone and Temperature")
        mtext("Ozone and Weather in New York City", outer = T)
})

## Lesson 2, Video 4: Base Plotting Demonstration

# example 1:
x <- rnorm(100)

hist(x)

y <- rnorm(100)
plot(x,y)

z <- rnorm(100)
plot(x,z)

# change margins:
par(mar = c(2,2,2,2)) # These margins are too small
## we lose the x and y labels
plot(x,y)

# make margins a bit bigger on the bottom and left
par(mar = c(4,4,2,2))
plot(x,y) # default plot character is 1 = "o"
plot(x,y,pch = 20) # solid dots
plot(x,y,pch = 19) # bolder solid dots
plot(x,y, pch = 2) # triangles
plot(x,y,pch = 3) # plus signs +
plot(x,y, pch = 4) # x marks the spot

example(points)

x <- rnorm(100)
y<- rnorm(100)
plot(x,y,pch=20)
title("scatterplot")
legend("topleft", legend = "Data")
legend("topleft", legend = "Data", pch = 20)
fit <- lm(y~x)
abline(fit) # default line is thickness 1
abline(fit, lwd = 3) # this line will have thickness 3

abline(fit, lwd=3, col = "blue")

plot(x,y,xlab = "Weight",ylab="Height",
     main = "Scatterplot",
     pch = 20)

legend('topright', legend = "Data", pch = 20)
fit<-lm(y~x)
abline(fit,lwd=3,col="red")
z<-rpois(100,2)
par(mfrow=c(2,1))
plot(x,y,pch=20)
plot(x,z,pch = 19)
par(mar= c(2,2,1,1))
par(mfrow =c(1,2))
par(mar=c(4,4,2,2))
plot(x,y,pch=20)
plot(x,z,pch = 19)

x<- rnorm(100)
y<- x + rnorm(100)
g<- gl(2,50) # results in 2 groups of 50 1s and 2s
g<- gl(2,50,labels=c('Male','Female'))# this results in the same but male and female

str(g) # Factor w/ 2 levels "Male","Female": 1 1 1 1 1 1 1 1 1 1 ...

plot(x,y) # don't know which are males and which are females
plot(x,y, type = "n") # gets plot ready but no points are plotted
points(x[g== "Male"],y[g=="Male"],col="red",pch=8)
points(x[g== "Female"],y[g=="Female"],col="blue",pch = 5)

## Lesson 3: Graphics Devices 
#l3v1: Graphics devices in R (part 1)

## most common way of creating a plot

library(datasets) # loading a data set
## calling a plotting function from base plotting system
with(faithful, plot(eruptions,waiting))
## annotate the plot
title(main = "Old Faithful Geyser data")

## second way:
## launch a graphics device
pdf(file = "myplot.pdf") # creates 'myplot.pdf in working directory
## call a plotting function and send to file
with(faithful, plot(eruptions, waiting))
## Annotate plot if necessary
title(main = "Old Faithful Geyser data")
## explicitly close graphics device
dev.off() ## important!

## l3v2: Grahpics Devices in R (part 2)

## copying a plot.
with(faithful,plot(eruptions,waiting)) ## plot to screen device
title(main = "Old Faithful Geyser data")
dev.copy(png,file = 'geyserplot.png') ## copy to png
dev.off()
