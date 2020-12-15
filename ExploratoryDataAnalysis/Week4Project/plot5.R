## created by: Sarah Massengill
## Project 2 for Exploratory Data Analysis
## Question 5: How have emissions from motor vehicle sources changed from 1999–2008 
##             in Baltimore City?: 


library(dplyr)
library(ggplot2)
library(ggrepel)

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
NEI<- filter(NEI, fips == "24510")

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
nei.scc<-group_by(nei.scc,EI.Sector,year)
totals<- summarize(nei.scc,total.em=sum(Emissions))
totals<-mutate(totals, EI.Sector = factor(EI.Sector))

g <- ggplot(totals,aes(x=year,y = total.em, fill = EI.Sector))
g <- g + geom_col() + 
     labs(title = "PM2.5 Emissions: All  Mobile Vehicles",
          subtitle = "Baltimore City, Maryland",
          caption = paste("Data Source:",url),
          y = "Total (Tons)") +

     geom_label_repel(aes(label = round(total.em),fill = EI.Sector),
                      direction = "y",
                      #arrow = arrow(length = unit(0.03, "npc"), type = "closed", ends = "first"),
                      show.legend = FALSE,
                      force = 1,
                      hjust = 2,
                      position = position_stack(vjust = 0.5),
                      color="black", 
                      fontface="bold") +

     theme(plot.title = element_text(hjust = 0.5, size = 18, face = "bold"),
           plot.subtitle = element_text(hjust = 0.5, size = 14, face = "bold"),
           plot.caption = element_text(hjust = 0, size = 9 , color = "blue",face ="italic"),
           axis.title.x = element_blank(),
           legend.title = element_blank(),
           legend.background = element_rect(colour = NA, fill = 'grey92'),
           legend.text = element_text(size=8),
           legend.margin = margin(0.0,0.0,0.0,0.0,"cm"),
           legend.position = "bottom", #c(.7,.78),
           legend.direction = "horizontal",
           legend.key.height = unit(.15,"cm"),
           legend.key.width = unit(.13,"cm")) +
           guides(fill=guide_legend(ncol = 2 ))
g            
png(file = 'plot5b.png')
print(g)
dev.off()       
