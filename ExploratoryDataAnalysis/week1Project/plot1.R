
library(lubridate)
library(dplyr)

## Create a temp file. 
temp <- tempfile()

## Download zipped data into temp file
url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(url,temp)

## unzip data and read to a table
data <- read.table(unz(temp,"household_power_consumption.txt"),
                   header=TRUE,
                   sep = ";",
                   quote = "",
                   na.strings = "?")
unlink(temp)

## filter the data to only include data from Feb 1 thru Feb 2 2007
data <- filter(data, dmy(Date) %in% c(dmy("01/02/2007"),dmy("02/02/2007")))

## add a DateTime variable (a POSIXct date-time object)               
data$DateTime = paste(data$Date,data$Time, sep=" ")
data$DateTime = dmy_hms(data$DateTime)

## launch a png graphics device
png(file = 'plot1.png')
with(data, hist(Global_active_power,col="red", main = "Global Active Power", 
                ylab="Frequency", xlab = "Global Active Power (kilowatts)")) 
                #margin=c(4,4,2,1), xlim = 0:6)

## close graphics device
dev.off()
