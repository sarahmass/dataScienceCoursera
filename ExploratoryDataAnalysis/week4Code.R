par(mfrow = c(1,3), mar = c(5,4,1,1))
samsungData <- transform(samsungData, activity = factor(activity))
sub1 <- subset(samsungData, subject == 1)
plot(sub1[,1], col = sub1$activity,ylab = names(sub1)[1])
plot(sub1[,2], col = sub1$activity,ylab = names(sub1)[2])
plot(sub1[,3], col = sub1$activity,ylab = names(sub1)[3])
legend("bottomright", legend = unique(sub1$activity),
       col = unique(sub1$activity), pch = 1)

## ignoring the rest of the subjects for right now.  
dev.off

par(mfrow = c(1,1))
source("myplclust.R")
distanceMatrix <- dist(sub1[,1:3])
hcclustering <-hclust(distanceMatrix)
myplclust(hclustering, lab.col = unclass(sub1$activity))

par(mfrow = c(1,2))
plot(sub1[,10], pch = 19, col=sub1$activity,ylab = names(sub1)[10])
plot(sub1[,11], pch = 19, col=sub1$activity,ylab = names(sub1)[11])

distanceMatrix<- dist(sub1[,10:12])
hclustering <- hclust(distanceMatrix)
myplclust(hclustering, lab.col = unclass(sub1$activity))

svd1 = svd(scale(sub1[,-c(562,563)]))
par(mfrow = c(1,2))
plot(svd1$u[,1], col = sub1$activity,pch = 19)
plot(svd1$u[,2], col = sub1$activity,pch = 19)

par(mfrow = c(1,1))
maxContrib <- which.max(svd1$v[,2])
distanceMatrix <- dist(sub1[,c(10:12),maxContrib])
hclustering <-hclust(distanceMatrix)
myplclust(hclustering,lab.col = unclass(sub1$activity))

kClust <-kmeans(sub1[,-c(562,563)], centers = 6, nstart = 100)
table(kClust$cluster,sub1$activity)

## Histograms of Log10(emission) levels
par(mfrow=c(1,4))
hist(log10(NEI$Emissions[NEI$year==1999]), col = 4, 
     freq = FALSE,
     ylim = c(0,0.35),
     xlim = c(-10,5), 
     breaks = 20)
abline(v=log10(1),lwd=2)
hist(log10(NEI$Emissions[NEI$year==2002]), col = 3, freq = FALSE,ylim = c(0,0.35),breaks = 20)
abline(v=log10(1),lwd=2)
hist(log10(NEI$Emissions[NEI$year==2005]), col = 2, freq = FALSE,ylim=c(0,0.35),breaks = 20)
abline(v=log10(1),lwd=2)
hist(log10(NEI$Emissions[NEI$year==2008]), col = "yellow", freq = FALSE,ylim=c(0,0.35),breaks = 20)
abline(v=log10(1),lwd=2)


