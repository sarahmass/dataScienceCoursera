## created by: Sarah Massengill
## Project 2 for Exploratory Data Analysis
## Question 4: Across the United States, how have emissions from coal 
##             combustion-related sources changed from 1999–2008?


library(dplyr)
library(ggplot2)

## Down load the data for the Project:
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

## Three of the SCC$SCC.Level.One levels have "Combustion" in their label:
##      "External Combustion Boilers", "Internal Combustion Engines", and
##      "Stationary Source Fuel Combustion".  Use grep to find the rows

comb <- grep("[Cc]ombustion", SCC$SCC.Level.One)

## 217 of the SCC$Short.Name factor labels include "[Cc]oal".  (Too many to list
##     here.).  Used grep to find rows that contain these labels. Also, noticed 
##     some of these labels included a "Total: All...".  To avoid counting emissions
##     for some categories twice I looked for all entries that included Total or All
coal <- grep("[Cc]oal", SCC$Short.Name)
total.categories <-grep("[Tt]otal|All", SCC$Short.Name)

## Find sources that contain both combustion and coal:
inter <- intersect(comb,coal)

## Find any line that totals other lines find the "Total" sources 
## among the coal combustion sources.
all.total<- intersect(inter,total.categories)

## Remove the sources that indicate a total of other lines 
inter<- inter[!(inter%in%all.total)]


## Collect all rows that are coal combustion and not totals. This reduces
## the factor levels for SCC sources from 11,717 to 77.
SCC <- SCC[inter,]
SCC <- mutate(SCC, SCC = as.character(SCC))

## Find the unique set of SCC factor levels that correspond to these rows
coalcomb.scc <- unique(SCC$SCC)

## filter NEI so that only the SCC values in coalcomb.scc are present. Note: 10 
## of the 77 possible SCC values found in the SCC data frame were not represented
## in the NEI data frame.  So there are 67 different sources of coal  combustion
## related emission measurements. 

NEI <- NEI %>% 
       filter(SCC %in% coalcomb.scc)

## merge the datasets together so that we have more options of grouping
neiscc <- merge(NEI,SCC,by="SCC") 


neiscc1 <- group_by(neiscc,SCC, year)        
       
## These next two chunks of code was to help me investigate the data.       
totals <- summarize(neiscc1, tot.emissions = sum(Emissions), .group = "keep")
ref <- summarize(totals,minyear = min(year))
ref<-merge(ref,totals, by.x=c("SCC","minyear"),by.y=c("SCC","year"), all.y = FALSE)
names(ref) <- c("SCC", "ref.year", "ref.em")
ref<- select(ref,SCC, ref.year, ref.em)

  
totals<-merge(totals, ref, by="SCC")
totals<-mutate(totals, ratio = tot.emissions/ref.em,year = as.factor(year) )
totals<-group_by(totals)

## Plotting total emissions in thousands of tons and filling in the bar graph
## with its color mapped to each SCC label. 
g4<- ggplot(totals, aes(x = year, y = tot.emissions/1e3, fill = SCC))
g4<- g4 + geom_bar(stat="identity") +
     labs(title = "PM2.5 Emissions: All Coal Combustion Sources",
     subtitle = "United States of America",
     caption = paste("Data Source:",url),
                   y = "Total (Thousand Tons)") +
     theme(
           plot.title = element_text(hjust = 0.5, size = 18, face = "bold"),
           plot.subtitle = element_text(hjust = 0.5, size = 14, face = "bold"),
           plot.caption = element_text(hjust = 0, size = 10 , color = "blue",face ="italic"),
           axis.title.x = element_blank(),
           legend.text = element_text(size=8),
           legend.margin = margin(0.0,0.0,0.0,0.0,"cm"),
           legend.position = "bottom",
           legend.direction = "horizontal",
           legend.key.height = unit(.1,"cm"),
           legend.key.width = unit(.1,"cm")) +
        guides(fill=guide_legend(ncol = 9 ))
g4
png(file = 'plot4.png')
print(g4)
dev.off()       

