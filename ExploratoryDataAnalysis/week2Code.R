## Week 2 in Exploratory Data Analysis: Example code

## Lesson 1: Lattice Plotting

library(datasets)
library(lattice)

## simple scatter plots
xyplot(Ozone~Wind, data=airquality)

## convert 'Month' to a factor variable
airquality<- transform(airquality, Month = factor(Month))
xyplot(Ozone~Wind | Month, data=airquality, layout = c(5,1))

## lattice produces a trelis object and then auto-prints
## when run in command line

p<- xyplot(Ozone~Wind, data=airquality) ## no printing
print(p)

set.seed(10)
x <- rnorm(100)
f <- rep(0:1, each = 50)
y <- x +f - f * x + rnorm(100, sd= 0.5)
f <- factor(f, labels = c("Group 1","Group 2"))
xyplot(y~x | f) # plots vertically 
xyplot(y~x | f, layout = c(2,1)) #plots horizontally ??


xyplot(y~x | f, layout = c(2,1), panel = function(x,y,...){
  panel.xyplot(x,y,...) # first call default panel function for xyplot
  panel.abline(h = median(y), lty = 2) # add dotted h-line @ median(y)
})


xyplot(y~x | f, layout = c(2,1), panel = function(x,y,...){
  panel.xyplot(x,y,...) # first call default panel function for xyplot
  panel.lmline(x,y,col=2, lty = 2) # add dotted linear regression lines
})

## Swirl
## loaded both lattice and ggplot2
## lattice functions take a formula for the first argument usually of the form y~x

## colors
pal<-colorRamp(c('red', "blue"))

## Lesson 2: ggplot2

library(ggplot2)
str(mpg)
## look at displacement variable:displ, 
## drv: type of drive:4,f,r; cyl: number of cylinders
## hwy: highway milage
## 'helo world' of ggplot:
qplot(displ,hwy,data = mpg)
## color mapped to drv variable values: 4,f,r
## legend automatically made. 
qplot(displ,hwy,data = mpg, color = drv)
## statistical summary of the data, data points and then 
## smooths it, giving a trend line and 
qplot(displ,hwy,data = mpg, geom = c('point','smooth'))
## one variable gives a histogram, again the 
## drv variable values determine the color and a 
## legend is automatically included.
qplot(hwy, data=mpg, fill = drv)

## facets (like panels in lattice):
# variables on the left hand side of facets determines
# the number of rows, while the right determins number
# of columns
# "." means there is no variable to determine the number
# of rows/columns to use depending on its placement
## plot a 1x3 array of the hwy vs disp,for each drv
qplot(displ,hwy,data=mpg,facets=.~drv)

## array of 3x1 histograms per drv value
qplot(hwy,data=mpg,facets=drv~., binwidth = 2)


## swirl: 
# first variable is how to split, second is the variable you are 
# examining, the data set, and type of plot
qplot(drv,hwy, data = mpg, geom="boxplot")
## add color equal to manufacturer splits the boxplots further by drv and manufacturer
qplot(drv,hwy, data = mpg, geom="boxplot", color = manufacturer)

#Histograms
qplot(hwy, data = mpg, fill = drv)

qplot(displ,hwy, data=mpg, geom=c("point","smooth"),facets=.~drv)
#`geom_smooth()` using method = 'loess' and formula 'y ~ x'


g+geom_point() + geom_smooth()
#`geom_smooth()` using method = 'loess' and formula 'y ~ x'

g+geom_point() + geom_smooth(method = "lm")

g+geom_point() + geom_smooth(method = "lm") + facet_grid(.~drv)
#`geom_smooth()` using formula 'y ~ x'

g + geom_point(color = "pink", size = 4, alpha = 1/2)

g + geom_point(size = 4, alpha = 1/2, aes(color = drv))

g + geom_point(aes(color = drv)) + labs(title="Swirl Rules!") + labs(x="Displacement", y="Hwy Mileage")

g + geom_point(aes(color = drv)) + theme_bw(base_family = "Times")



g + geom_point(aes(color = drv), size = 2, alpha = 1/2) + geom_smooth(size = 4, linetype = 3, method = "lm", se = FALSE)


myx<- 1:100
myy <- rnorm(100)
myy[50]<- 100
plot(myx, myy, type="l", ylim=c(-3,3))

testdat<-data.frame(x = myx, y = myy)
g <- ggplot(testdat, aes(x = myx, y = myy))
g + geom_line()

# this will subset the data set such that the y-values
# fall with in the limit, we do not want this.  
g + geom_line() + ylim(-3,3)

## This will not subset the data but only display values that fit with in
## the coordinate system values like the base system did with its plot function
g + geom_line() + coord_cartesian(ylim = c(-3,3))

g<-ggplot(data=mpg, aes(x = displ, y = hwy, color = factor(year)))
g + geom_point()
g + geom_point() + facet_grid(drv~cyl, margins = TRUE) ## ad marginal totals over each row and col
g + geom_point() + facet_grid(drv~cyl, margins = TRUE) + geom_smooth(method = "lm", se = FALSE, size = 2, color = "black")
# `geom_smooth()` using formula 'y ~ x'

qplot(price, data = diamonds)
# `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

qplot(price, data = diamonds, binwidth= 18497/30, fill = cut)
qplot(price, data= diamonds, geom="density")
qplot(price, data= diamonds, geom="density", color = cut)

qplot(carat,price, data=diamonds)
qplot(carat,price, data=diamonds, shape = cut)
qplot(carat,price, data=diamonds, color = cut)
qplot(carat,price, data=diamonds, color = cut) + geom_smooth(method = "lm")
# `geom_smooth()` using formula 'y ~ x'

qplot(carat,price, data=diamonds, color = cut, facets=.~cut) + geom_smooth(method = "lm")
# `geom_smooth()` using formula 'y ~ x'

g<-ggplot(data=diamonds, aes(depth,price))

g + geom_point(alpha = 1/3)
cutpoints<-quantile(diamonds$carat, seq(0,1,length=4), na.rm = TRUE)
diamonds$car2 <- cut(diamonds$carat, cutpoints)
g<- ggplot(data = diamonds, aes(depth,price))
g + geom_point(alpha = 1/3) + facet_grid(cut~car2)
g + geom_point(alpha = 1/3) + facet_grid(cut~car2) + geom_smooth(method = "lm",size = 3, color = 'pink')
#`geom_smooth()` using formula 'y ~ x'
ggplot(diamonds, aes(carat,price)) + geom_boxplot()+ facet_grid(. ~ cut)
#Warning message:
#  Continuous x aesthetic -- did you forget aes(group=...)? 









## quiz code:
# #2
library(nlme)
library(lattice)
xyplot(weight ~ Time | Diet, BodyWeight)
