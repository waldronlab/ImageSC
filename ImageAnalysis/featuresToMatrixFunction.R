
#Path argument example: "/home/dayaffe/Imaging/ImageSC/scratch/david.yaffe/THAD/TCGA-E8-A434-01Z-00-DX1-Features"
#Path argument is to folder where the rds files for the features is stored
fileNames <- list() # NEEDED FOR HEATMAP
extractedFeaturesToMatrix <- function(path, moreFeatures, dendrogram, kmeans, kclusters)
{
  resultValues <- list()
  
  library(Matrix)
  
  p <- paste0(path, "/")
  fileNames <<- dir(path=path, pattern=".rds")

  RDSMatrix <- matrix(nrow = length(fileNames), ncol = 41) #Matrix of feature extraction
  percentiles5 <- matrix(nrow = length(fileNames), ncol = 41) #To initally store 5% values of each feature
  percentiles95 <- matrix(nrow = length(fileNames), ncol = 41) #To initally store 95% values of each feature
  
  count <- 0
  for(i in fileNames) {
    if(nrow(readRDS(paste0(p, i))) != 0)
    {
      fileNames[count] <<- paste0(p, i)
    } else
    {
      fileNames <<- fileNames[-count]
    }
    count <- count + 1
  }
  fileNames <<- na.omit(fileNames)
  rowCount <- 1
  for(i in fileNames)
  {
    tempNumeric <- colMeans(readRDS(i))
    colCount <- 1
    while(colCount <= 41)
    {
      RDSMatrix[rowCount, colCount] = tempNumeric[[colCount]]
      if(moreFeatures == TRUE)
      {
        quantiles <- quantile(readRDS(i)[,colCount], c(0.05, 0.95))
        percentiles5[rowCount, colCount] = quantiles[1]
        percentiles95[rowCount, colCount] = quantiles[2]
      }
      colCount <- colCount + 1
    }
    rowCount <- rowCount + 1
  }
  
  
  colnames(RDSMatrix) <- names(colMeans(readRDS(fileNames[1])))
  if(moreFeatures == TRUE)
  {
    tempNames <- colnames(RDSMatrix)
    tempNames5 <- lapply(tempNames, function(x) paste0(x,"_5%"))
    tempNames95 <- lapply(tempNames, function(x) paste0(x,"_95%"))
    colnames(percentiles5) <- tempNames5
    colnames(percentiles95) <- tempNames95
    
    RDSMatrix <- cbind(RDSMatrix, percentiles5[,-1], percentiles95[,-1]) #Combine 5th percentil and 95th percentile matrix with feature extracted matrix
    
  }
  
  
  RDSMatrix <- RDSMatrix[!rowSums(!is.finite(RDSMatrix)),]
  RDSMatrix <- scale(RDSMatrix)
  

  if(dendrogram == TRUE)
  {
    #CLUSTERING
    #Hierarchical Clustering
    d <- dist(RDSMatrix, method = "euclidean") # distance matrix
    fit <- hclust(d, method="ward.D2")
  } else {
    fit <- NA
  }
  
  if(kmeans == TRUE)
  {
    #KMEANS
    resultsFromKmeans <- kmeans(RDSMatrix, kclusters)
    df <- data.frame(RDSMatrix)
    df$cluster <- factor(resultsFromKmeans$cluster)
    centers <- as.data.frame(resultsFromKmeans$centers)
    kmeansPlot <- ggplot(data=df, aes(x=s.radius.mean,y=h.sen.s2,color=cluster)) + geom_point()

  } else {
    results = NA
    kmeansPlotData = NA
  }
  
  resultValues <- list(RDSMatrix, fit, resultsFromKmeans, kmeansPlot)
  names(resultValues) = c("featureMatrix", "dendrogram", "kmeansData", "kmeansPlot")
  
  return(resultValues)
}
