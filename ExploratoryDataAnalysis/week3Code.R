## Week 3 code examples


## lesson 1 Hierarchial Clustering

set.seed(1234)
par(mar = c(0,0,0,0))
x <- rnorm(12, mean = rep(1:3, each = 4), sd = 0.2)
y <- rnorm(12, mean = rep(c(1,2,1), each = 4), sd = 0.2)
plot(x,y,col = "blue",pch=19, cex=2)
text(x - 0.05, y + 0.05, labels = as.character(1:12))

dataframe<- data.frame(x=x, y=y)
## calculating the euclidean distance which is the default
## for the dist() function
distxy<-dist(dataframe)

# 1          2          3          4          5          6          7          8          9         10         11
# 2  0.34120511                                                                                                              
# 3  0.57493739 0.24102750                                                                                                   
# 4  0.26381786 0.52578819 0.71861759                                                                                        
# 5  1.69424700 1.35818182 1.11952883 1.80666768                                                                             
# 6  1.65812902 1.31960442 1.08338841 1.78081321 0.08150268                                                                  
# 7  1.49823399 1.16620981 0.92568723 1.60131659 0.21110433 0.21666557                                                       
# 8  1.99149025 1.69093111 1.45648906 2.02849490 0.61704200 0.69791931 0.65062566                                            
# 9  2.13629539 1.83167669 1.67835968 2.35675598 1.18349654 1.11500116 1.28582631 1.76460709                                 
# 10 2.06419586 1.76999236 1.63109790 2.29239480 1.23847877 1.16550201 1.32063059 1.83517785 0.14090406                      
# 11 2.14702468 1.85183204 1.71074417 2.37461984 1.28153948 1.21077373 1.37369662 1.86999431 0.11624471 0.08317570           
# 12 2.05664233 1.74662555 1.58658782 2.27232243 1.07700974 1.00777231 1.17740375 1.66223814 0.10848966 0.19128645 0.20802789
dev.off()

hClustering <- hclust(distxy)
plot(hClustering)

## Prettier dendrograms
mypclust <- function(hclust, lab = hclust$labels, 
                     lab.col = rep(1,length(hclust$labels)),
                     hang = 0.1,...){
                     ## modification of plclust for plotting hclust
                     ## objects in color.  copyright Eva KF chan 2009
                     ## arguments: hclust: hclust object, lab: a character
                     ## vector of labels of the leaves of the tree lab.col: 
                     ## colour for the labels; NA=default device forground
                     ## colour hang: as in hclust & plclust Side effect:
                     ## a display of hierachical cluster with coloured leaf labels.
                     y<- rep(hclust$height,2)
                     x<- as.numeric(hclust$merge)
                     y<-y[which(x<0)]
                     x<-x[which(x<0)]
                     x<-abs(x)
                     y<-y[order(x)]
                     x<-x[order(x)]
                     plot(hclust, labels = FALSE, hang = hang, ...)
                     text(x=x, y = y[hclust$order] - (max(hclust$height) *hang), 
                          labels = lab[hclust$order], col = lab.col[hclust$order],
                          srt = 90, adj = c(1, 0.5), xpd = NA, ...)
}
mypclust(hClustering,lab = rep(1:3, each = 4), lab.col = rep(1:3, each = 4))

## run a heat map on the data
set.seed(143)
dataMatrix <- as.matrix(dataframe)[sample(1:12),]
heatmap(dataMatrix)


## Lesson 2: K-Means Clustering and Dimension reduction

# video 1 and 2 K-means clustering

kmeansObj <- kmeans(dataframe,centers = 3)
names(kmeansObj)
# [1] "cluster"      "centers"      "totss"        "withinss"     "tot.withinss"
# [6] "betweenss"    "size"         "iter"         "ifault"     

kmeansObj$cluster
kmeansObj$centers

## plot the points in the dataframe and add color based on their cluster
plot(x,y,col = kmeansObj$cluster, pch = 19, cex = 2)

## plot the centers of each of the clusters with the plus sign symbol
points(kmeansObj$centers, col = 1:3, pch = 3, cex = 3, lwd = 3)

set.seed(1234)
dataMatrix <- as.matrix(datafame)[sample(1:12),]
kmeansobj2 <- kmeans(dataMatrix, centers = 3)
par(mfrow = c(1,2), mar = c(2,4,0.1,0.1))
image(t(dataMatrix)[,nrow(dataMatrix):1],yaxt = "n")
image(t(dataMatrix)[,order(kmeansObj$cluster)],yaxt = "n")

# video 3-4 Dimension Reduction

## create random data
set.seed(12345)
par(mar = rep(0.2, 4))
dataMatrix <- matrix(rnorm(400), nrow = 40)
# this creates a sort of heat map of the data 
image(1:10, 1:40, t(dataMatrix)[,nrow(dataMatrix):1])
## Note that the image will show no real pattern

## now we run a heirarchial clustering on the rows and the cols
## to see if there are any patters to see there

heatmap(dataMatrix)
## note that still no real pattern emerges 

## add pattern to the data:
set.seed(678910)
for(i in 1:40){
  # flip a coin
  coinFlip <- rbinom(1, size=1, prob= 0.5)
  # if coin is heads add a common pattern to that row
  if (coinFlip){
    dataMatrix[i,]<- dataMatrix[i,] + rep(c(0,3),each = 5)
  }
}

par(mar = rep(0.2, 4))
# this creates a sort of heat map of the data 
image(1:10, 1:40, t(dataMatrix)[,nrow(dataMatrix):1])
##Column wise there is now a clear pattern, half
## have means of 3 and about half have means of 5
heatmap(dataMatrix)
## again we see that there is a clear definition of the
## clusters in the columns but no real pattern in the 
## rows since we didn't add any pattern via the rows
dev.off()
hh<- hclust(dist(dataMatrix))

dataMatrixOrdered<-dataMatrix[hh$order,]
par(mfrow = c(1,3))
image(t(dataMatrixOrdered)[, nrow(dataMatrixOrdered):1])
plot(rowMeans(dataMatrixOrdered), 40:1,,xlab="Row Mean", ylab="Row", pch=19)
plot(colMeans(dataMatrixOrdered),xlab="Column", ylab="Column Mean", pch=19)
dev.off()

## Dedimension reduction with singular value decomp (svd) and principal component
## analysis (pca).

svd1 <- svd(scale(dataMatrixOrdered))
par(mfrow = c(1,3))
image(t(dataMatrixOrdered)[, nrow(dataMatrixOrdered):1])
plot(svd1$u[,1],40:1, xlab = "Row", ylab = "First left singular vector", pch = 19)
plot(svd1$v[,1], xlab = "column", ylab = "First right singular vector", pch = 19)

par(mfrow = c(1,2))
plot(svd1$d,xlab = "column", ylab = 'singular value', pch = 19)
plot(svd1$d^2/sum(svd1$d^2), xlab = "column", ylab = "prop. of variance explained", pch=19)
dev.off()
## compare the singular values of svd with pca- they match because
## they are dealing with the same matrix, and finding the same eigen values and eigen
## vectors.  What we do know is that the first eigen vector/value 
## is responsible for about 40% of the variation.  
## also we can note from the images before that
## svd picks up on the shift in the means in both the row and 
## the column dimensions (the u and the v matrices). 

pca1 <- prcomp(dataMatrixOrdered, scale = TRUE)
plot(pca1$rotation[,1],svd1$v[,1], pch= 19, xlab= "principal component 1", ylab = "right singular vector 1")
abline(c(0,1))
dev.off()
## components of the SVD - variance explained

## lets look at a matrix with only a single pattern, 0 if in columns1-5, 1 cols 6-10
constantMatrix<- dataMatrixOrdered*0

for(i in 1:dim(dataMatrixOrdered)[1]){
  constantMatrix[i,]<-rep(c(0,1), each = 5)
}
svd1<-svd(constantMatrix)
par(mfrow=c(1,3))
image(t(constantMatrix)[,nrow(constantMatrix):1])
plot(svd1$d, xlab="Column", ylab='Singular value',pch=19)
plot(svd1$d^2/sum(svd1$d^2), xlab="Column", ylab='proportion of varience explained',pch=19)

## what we see here is that 100% of the variance is due to the first singular value/vector (eigen value/vector)
## this makes sense because if you are in the first 5 columns the result is zero and in the second 5 the result is 1
## There is a single dimension to the variation even though there are a lot of observation (rows)
dev.off()
set.seed(678910)
for(i in 1:40){
    # flip a coin
    coinFlip1<- rbinom(1,size=1,prob=0.5)
    coinFlip2<- rbinom(1,size=1,prob=0.5)
    
    ## if coin is heads add a common pattern to that row
    if(coinFlip1){
        dataMatrix[i,]<-dataMatrix[i,] + rep(c(0,5), each = 5)
    }
    if(coinFlip1){
      dataMatrix[i,]<-dataMatrix[i,] + rep(c(0,5), each = 5)
    }
    if(coinFlip2){
      dataMatrix[i,]<-dataMatrix[i,] + rep(c(0,5), 5)
    }
}
hh <- hclust(dist(dataMatrix))
dataMatrixOrdered <- dataMatrix[hh$order,]


par(mfrow = c(1,3))
image(t(dataMatrixOrdered)[,nrow(dataMatrixOrdered):1])
plot(rep(c(0,1), each = 5), pch = 19, xlab="column", ylab = "pattern 1")
plot(rep(c(0,1),5), pch = 19, xlab="column", ylab = "pattern 2")

svd2<- svd(scale(dataMatrixOrdered))
par(mfrow = c(1,3))
image(t(dataMatrixOrdered)[,nrow(dataMatrixOrdered):1])
plot(svd2$v[,1],pch = 19, xlab = "column", ylab = "1st rt. singular vector")
plot(svd2$v[,2],pch = 19, xlab = "column", ylab = "2nd rt. singular vector")

## we will see in the graphs created from the code above that the patters are
## someone discernable because we know what they are, we can see in the first
## component that the left half are less than the right half, but we also see that
## every other pattern
## in the second one we can see that they alternately grow and fall, 
## but are grouped into two groups the first 5 are again smaller than the 
## second 5.  The patterns are confounded together in each of the 
## principal components. 

## Missing Values
set.seed(1)
dataMatrix2 <- dataMatrixOrdered
## Randomly insert missing data
dataMatrix2[sample(1:100, size = 40, replace = FALSE)] <- NA
svd1<- svd(scale(dataMatrix2))## Doesn't work! 
## Error in svd(scale(dataMatrix2)) : infinite or missing values in 'x'

## Problem with svd and pca is missing values.  :(
## One way of dealing with this is to "impute" the missing values
## This can be done using the library Impute from http://bioconductor.org
## 
## The method uses K-nearest neighbor for the missing value by collecting the 5 rows
## 'close' (the definition of close was not defined, it could mean closest in the data
## set, or closest based on all other *values*), and then averages the column values in those
## to give the missing variable in the row a value.  then svd can be run.  

dataMatrix2<-impute.knn(dataMatrix2)$data
## This doesn't really work right now because I am working with R in my oneDrive directory
## stupid mistake.  i will try to fix it later.  

svd1<-svd(scale(dataMatrixOrdered))
svd2<-svd(scale(dataMatrixOrdered2))
par(mfrow=c(1,2))
plot(svd1$v[1,],pch=19)
plot(svd2$v[1,],pch=19)

## at least in this example the imputing did not make much of a
## difference in the svd values.  

load('data/face.rda')
image(t(faceData)[,nrow(faceData):1])
svd1<- svd(scale(faceData))
plot(svd1$d^2/sum(svd1$d^2), pch = 19, 
     xlab = "singular vector", ylab = "Variance explained")

## The first 5 vectors are responsible for most of the data variance.
## we can look at the image created by the the first 5 and 10 singular value
## vectors

## Note that %*% is matrix multiplication
# Here svd1$d[1] is a constant
approx1 <-svd1$u[,1] %*% t(svd1$v[,1])*svd1$d[1]

## in these examples we need to make the diagonalmatrix out of d
approx5 <-svd1$u[,1:5] %*% diag(svd1$d[1:5]) %*% t(svd1$v[,1:5])
approx10 <-svd1$u[,1:10] %*% diag(svd1$d[1:10]) %*% t(svd1$v[,1:10])

dev.off()
par(mfrow = c(1,4))
library(grDevices)
pal <-colorRampPalette(c("black" , "white" ))

image(t(approx1)[,nrow(approx1):1],col = pal(256),main = "(a)")
image(t(approx5)[,nrow(approx5):1],col = pal(256),main = "(b)")
image(t(approx10)[,nrow(approx10):1],col =pal(256) ,main = "(c)")
image(t(faceData)[,nrow(faceData):1],col = pal(256) ,main = "(d)") ## original data
## note: heat.colors(255), topo.colors(255) also worked but the one shown above
## is the best, especially with black first and white second. This means that low
## values corresponded with black and high values with white.  It gave the best 
## detailed image.  


# http://www.stat.cmu.edu/~cshalizi/ADAfaEPoV/ADAfaEPoV.pdf
# https://web.stanford.edu/~hastie/ElemStatLearn/

## LEson 3: Working with color
## v1: working with color in R Plots
##      - defaults in R suck
##      - black, red, blue are the first three colors in R
##      - volcano color set - heat.colors() and topo.colors()

## v2:  part 2 of working with color 
## - The grDevices package has two functions: colorRamp(), colorRampPalette()
## - these funcitons take palettes of color and help to interpolate between the colors
## - colors() lists the names of colors you can use in any plotting function

## ** colorRamp take a palette of colors and return a function that takes
##    values between 0 and 1, indicating the extremes of the color palette
## ** colorRampPalette: takes a palette of colors and returns a function
##    that takes integer arguments and returns a vector of colors
##    interpolating the palette like heat.colors or topo.colors
## ** I played with the above two palets and liked colorRampPalette best.

## v3: part 3 of working with color
## RcolorBrewer Package
## ** 3 types of palates- sequential, diverging, qualitative
## ** this can be used in conjunction with colorRamp() and ColorRampPalette()

dev.off()

x<-rnorm(10000)
y<-rnorm(10000)
smoothScatter(x,y)
smoothScatter(x,y,colramp = colorRampPalette(c("black","yellow")))

## tutorial on heatmaps:
## http://sebastianraschka.com/Articles/heatmaps_in_r.html#clustering

## a 'concise' paper on PCA http://arxiv.org/pdf/1404.1100.pdf
## a paper jonathon shlens of google Rsearch Tutorial on Principal component Analysis

              