## created by: Sarah Massengill
## Project 2 for Exploratory Data Analysis
## Question 2: Have total emissions from PM2.5 decreased in the Baltimore City, 
##             Maryland (fips == "24510") 
#              from 1999 to 2008?

## Directions: Using the base plotting system, make a plot showing the total
##             PM2.5 emission from all sources for each of the years 
##             1999, 2002, 2005, and 2008.

library(dplyr)
## Location of data for the Project:
url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"

#Check for files in the working directory
wd.files <- dir()
data.files <- c("summarySCC_PM25.rds", "Source_Classification_Code.rds")

for (f in data.files){
  if(!( f %in% wd.files)){
    download.file(url,"exdataFNEI.zip") 
    ## unzip data and read to a table
    unzip("exdataFNEI.zip")    
  }  
}

## Read the data into their variables
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

## Collect only Baltimore City, Maryland measurements and group by year
NEI <- NEI%>% mutate(year=as.factor(as.character(year))) %>%
              filter(fips == "24510") %>%
              group_by(year)

## calculate the total measured PM2.5 emissions for by summing 
## the readings for every source grouped by year 
totals <- with(NEI, tapply(Emissions,year,sum))

## set reference year total
old<-totals["1999"]

## Convert totals from an array into a data frame to work with tapply() 
tots <- data.frame(year = unique(NEI$year), yearlySum=totals)

## function to calculate relative change with respect to old = totals[1999]
relative_change <-function(new){
        (new-old)/old*100
}
decreases <-with(tots, tapply(yearlySum,year,relative_change))

## We could plot the total emissions as a ratio of each year with 1999 as the 
## reference year. 
## totals <- tapply(NEI$Emissions,NEI$year,sum)/(sum(NEI$Emissions[NEI$year==1999]))

## calculate a trend line by fitting a line to the data
totals_line <- line(tots$yearlySum)

## Prepare the margins of the graph
par(mfrow=c(1,1), mar=c(5,4,4,1))

## Create a color palette
pal<- colorRampPalette(c("blue","springgreen4"))
colors=pal(5)
## Save the plot to a png file so first create a 
## png graphic device
## launch a png graphics device
png(file = 'plot2.png')

## Plot a bar plot of the total Emissions for each year
## dividing all totals by 1e6 makes y-axis in terms of millions of tons
## and looks less busy
barplot(totals/1000,
        col=colors[1:4],
        ylab="Thousand Tons",
        ylim = c(0,max(totals)/1000+1),
        main="Total Measured PM2.5 Emissions by Year",
        
)

## add the trend line to emphasize the decrease in the total measured Emissions
## abline(coef = totals_line$coefficients/1e3,lwd=3) # commented out because it
##                                                     was too busy
mtext("Baltimore City, Maryland", side = 3, line = 0, cex=1)
mtext("Data Source: https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip",
      col='blue', 
      side = 1, cex = .9,
      line = 3, at = 2.25)

## label each bar with the relative change in total emissions
## with 1999 being the reference year
decreases <- abs(round(decreases,digits=1))
text(x=c(0.7,1.9,3.1,4.3), y = 1, 
     labels= c("Reference\nyear",
               paste(decreases[2:4],"%\ndecrease", sep="" )),
     col="white",
     cex=1.2)
average_dec <- round(abs(totals_line$coefficients[2]),1)

## add text for the average absolute decrease each 3year period
text(x=3.5,y=3.8,
     labels=paste("Average decrease\nper 3 year period is\n ~", 
                  average_dec," tons.", sep=""),
     col="springgreen4")
dev.off()
