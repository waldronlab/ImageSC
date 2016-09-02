#system("./home/dayaffe/Imaging/ImageSC/TileSVS.sh 200")

#GLOBAL VARIABLE FOR ToHeatmap FUNCTION. As the code is now, the segments are removed once they are finished to compensate for the problem image. I realize that this is a bad way to do it.
fileNamesOG <- list()


#BEFORE USING THIS FUNCTION, you must tile the images first. The "p" variable/first argument is the folder with those tiles in them
segmentImages <- function(p, n, fileType)
{
  library("jpeg")
  library("CRImage")
  
  #We need to store the image file names for when we eventually heatmap
  #Example: fileNamesOG <- dir(path="/home/dayaffe/Imaging/ImageSC/scratch/david.yaffe/THAD/TCGA-E8-A434-01Z-00-DX1", pattern=".jpeg")
  fileNamesOG <<- dir(path=p, pattern=fileType)
  fileNamesOG <<- strsplit(fileNamesOG, fileType)
  fileNamesOG <<- unlist(sapply(fileNamesOG, strsplit, "_"))
  fileNamesOG <<- matrix(fileNamesOG, ncol = 2, byrow = TRUE)
  
  name <- ""
  saveFolder <- ""
  saveName <- ""
  system(paste("mkdir", n))
  folder = paste0(p, "/")
  tempFolder = n
  file.names <- dir(folder, pattern =fileType)
  for(i in file.names){
    name <- i
    f = paste0(folder, name)
    saveName <- paste0(name, "_features.rds")
    saveFolder <- paste0(tempFolder, "/")
    move <- paste0("mv ", f, " ", folder, "DONE")
    segmentationValues=try(segmentImage(f,maxShape=800,minShape=40,failureRegion=2000,threshold="otsu",numWindows=4))
    #writeJPEG(segmentationValues[[2]], target = paste0(saveFolder, saveName), quality = 0.7, bg = "black")
    if(is(segmentationValues, "try-error")){
      errorHandling(move)
      next
    }
    system(move)
    saveRDS(segmentationValues[[3]], paste0(saveFolder, saveName))
  }
  system(paste("rm -r", p))
}

errorHandling <- function(m) {
  print("PROBLEM IMMAGE CAUGHT")
  system(m)
}

#segmentImages("/home/dayaffe/Imaging/ImageSC/scratch/david.yaffe/THAD/TCGA-EL-A4K1-11A-HALF", "/home/dayaffe/Imaging/ImageSC/scratch/david.yaffe/THAD/TCGA-EL-A4K1-11A-HALF-Features", ".jpeg")
