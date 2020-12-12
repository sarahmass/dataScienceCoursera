## created by: Sarah Massengill
## Project 2 for Exploratory Data Analysis
## Question 6: Compare emissions from motor vehicle sources in Baltimore City 
##             with emissions from motor vehicle sources in Los Angeles County, 
##             California (fips == "06037"). Which city has seen greater changes
##             over time in motor vehicle emissions? 


library(dplyr)
library(ggplot2)


## Location of Data for the Project:
url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"

#Check for files in the working directory
wd.files <- dir()
data.files <- c("summarySCC_PM25.rds", "Source_Classification_Code.rds")

## Download files if one of the files is missing
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

## Filter NEI to include only measurements taken in Baltimore City, Maryland 
## (fips = 24510) and Los Angeles County, California ("06037") Note: there are 
## 9320 for LA county while only 2096 for Baltimore.
NEI<- filter(NEI, fips %in% c("24510","06037" ))

## Note: The question does not define Mobile Vehicles at all.  I will interpret
## as a vehicle that moves.  boats and motorcycles will be included.  Unless I 
## get feedback otherwise I will do my best now to gather all such vehicles. 

## Trying to pull in all possible mobile vehicles: on-road, off-road,
## water,and air vehicles.
mobveh.one<-grep("[Mm]obile | [Vv]ehicle[ s]",SCC$SCC.Level.One)
mobveh.two<-grep("[Mm]obile | [Vv]ehicle[ s]",SCC$SCC.Level.Two)
mobveh.three<-grep("[Mm]obile | [Vv]ehicle[ s]",SCC$SCC.Level.Three)
mobveh.four<-grep("[Mm]obile | [Vv]eh[icle s]",SCC$SCC.Level.Four)
mobveh.ei.sector<-grep("[Mm]obile | [Vv]ehicle[ s]",SCC$EI.sector)
mobveh.short.name<-grep("[Mm]obile | [Vv]ehicle[s ]",SCC$Short.Name)
mob.veh<-unique(c(mobveh.one, mobveh.two, mobveh.three, mobveh.four, 
                  mobveh.ei.sector, mobveh.short.name))

## Remove all measurements that do not include motor vehicles. 
SCC<- SCC[mob.veh,] %>% select(SCC:SCC.Level.Four)

## Merge NEI and SCC
nei.scc <- merge(NEI,SCC, by = "SCC", )
nei.scc<- mutate(nei.scc, year = factor(year))
nei.scc<-group_by(nei.scc,EI.Sector,fips,year)
totals<- summarize(nei.scc,total.em=sum(Emissions))
fips2location <- data.frame(fips=c("24510","06037" ), location = c("Los Angeles County,\nCalifornia", "Baltimore City,\n Maryland"))
totals <- merge(totals,fips2location,by="fips")

g <- ggplot(totals,aes(x=year,y = total.em, fill = EI.Sector))
g <- g + geom_col() + facet_wrap(~location)+
     labs(title = "PM2.5 Emissions: All  Mobile Vehicles",
          caption = paste("Data Source:",url),
          y = "Total (Tons)") +
     theme(plot.title = element_text(hjust = 0.5, size = 18, face = "bold"),
           plot.caption = element_text(hjust = 0, size = 9 , color = "blue",face ="italic"),
           axis.title.x = element_blank(),
           legend.title = element_blank(),
           legend.background = element_rect(colour = NA, fill = 'transparent'),
           legend.text = element_text(size= 9),
           legend.margin = margin(0.1,0.1,0.1,0.1,"cm"),
           legend.position = "bottom",
           legend.direction = "horizontal",
           legend.key.height = unit(.2,"cm"),
           legend.key.width = unit(.15,"cm")) +
           guides(fill=guide_legend(ncol = 2 ))
g            
png(file = 'plot6.png')
print(g)
dev.off()       
