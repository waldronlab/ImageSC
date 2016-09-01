#variableForOGTiles example <-   #fileNamesOG <- dir(path="/home/dayaffe/Imaging/ImageSC/scratch/david.yaffe/THAD/TCGA-E8-A434-01Z-00-DX1", pattern=".jpeg")
viewHeatmap <- function() #variableWithMatrixData is whatever variable you stored the results of the RDSMatrix function
{
  tintMatrix <- matrix(nrow = nrow(fileNamesOG), ncol = 3)
  clusterCounter <- 1
  for(i in fileNames)
  {
    tempString <- strsplit(i, "/")
    tempString <- strsplit(tempString[[1]][10], ".jpeg")
    tempString <- strsplit(tempString[[1]][1], "_")
    tryCatch(tintMatrix[clusterCounter, ] <- c(tempString[[1]][1], tempString[[1]][2], results$kmeansData$cluster[clusterCounter]))
    clusterCounter <- clusterCounter + 1
  }
  
  found = FALSE
  comparisonCounter <- 1
  comparisonCounter2 <- 1
  num <- nrow(tintMatrix)
  while(comparisonCounter <= nrow(fileNamesOG))
  {
    while(comparisonCounter2 <= num)
    {
      if(identical(fileNamesOG[comparisonCounter, 1], tintMatrix[comparisonCounter2, 1]) == TRUE && identical(fileNamesOG[comparisonCounter, 2], tintMatrix[comparisonCounter2, 2]) == TRUE)
      {
        found = TRUE
      } else {
        found = FALSE
      }
      comparisonCounter2 <- comparisonCounter2 + 1
    }
    if(found == FALSE)
    {
      tryCatch(tintMatrix[clusterCounter, ] <- c(fileNamesOG[comparisonCounter, 1], fileNamesOG[comparisonCounter, 2], "0"))
      #print(tintMatrix[clusterCounter, ])
      clusterCounter <- clusterCounter + 1
    }
    comparisonCounter <- comparisonCounter + 1
  }
  colnames(tintMatrix) <- c("x", "y", "cluster")
  heatMatrix <- matrix()
  heatMatrix <- apply(tintMatrix[, 1:3], 2, function(x) as.numeric(x))
  counter1 <- 1
  counter2 <- 1
  while(counter1 <= nrow(heatMatrix))
  {
    counter2 <- 1
    while(counter2 <= 2)
    {
      heatMatrix[counter1, counter2] = heatMatrix[counter1, counter2] + 1
      counter2 <- counter2 + 1
    }
    counter1 <- counter1 + 1
  }
  fileNamesOGCount <- apply(fileNamesOG[, 1:2], 2, function(x) as.numeric(x))
  counter <- 1
  maxX <- max(fileNamesOGCount[, 1])
  maxY <- max(fileNamesOGCount[, 2])
  heatmapMatrix <- matrix(nrow = maxX, ncol = maxY)
  while(counter <= nrow(heatMatrix))
  {
    tryCatch(heatmapMatrix[heatMatrix[counter, ][[1]], heatMatrix[counter, ][[2]]] = heatMatrix[counter, ][[3]])
    counter <- counter + 1
  }
  #heatmapMatrix[is.na(heatmapMatrix)] <- 0
  
  return(image(heatmapMatrix[,-1]))
}
