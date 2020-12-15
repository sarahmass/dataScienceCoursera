## created by: Sarah Massengill
## Project 2 for Exploratory Data Analysis
## Question 3: Of the four types of sources indicated by the type (point, 
##             nonpoint, onroad, nonroad) variable, which of these four sources 
##             have seen decreases in emissions from 1999–2008 for Baltimore 
##             City? Which have seen increases in emissions from 1999–2008? 


## Directions: Use the ggplot2 plotting system to make a plot answer this question.

library(dplyr)
library(ggplot2)

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

## group NEI by year, and filter for measurements only in Baltimore City 
NEI <- NEI %>% filter(fips == "24510") %>%
               select(SCC,type,Emissions,year)%>%
               #mutate(year=as.factor(as.character(year))) %>%
               group_by(type, year)



## calculate the total measured PM2.5 emissions by summing 
## the readings for every source grouped by year 
totals <- summarise(NEI, Total = sum(Emissions), .group = "keep")
totals<-mutate(totals,year=as.factor(year))



g <- ggplot(data = totals, aes(x = year,y = Total))
g<- g + 
    geom_bar(stat = "identity",aes(color = type, fill = type)) +
    facet_wrap(~type,nrow=2) +
    labs(title="PM2.5 Emissions by Type and Year",
         subtitle = "Baltimore City, Maryland",
         caption = paste("Data Source:",url),
         y = "Total Tons") +
    geom_text(aes(label = round(Total,1)),colour="black", fontface="bold", vjust=-0.2) +
    theme(
      plot.title = element_text(hjust = 0.5, size = 20, face = "bold"),
      plot.subtitle = element_text(hjust = 0.5, size = 15, face = "bold"),
      plot.caption = element_text(hjust = 0, size = 10 , color = "blue",face ="italic"),
      legend.position="none",
      axis.title.x = element_blank())+
    coord_cartesian(ylim=c(0, 2300))
    
g #print to screen device
png(file = 'plot3.png')
print(g)
dev.off()

