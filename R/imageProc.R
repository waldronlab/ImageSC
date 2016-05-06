library(CRImage)
library(EBImage)

a <- readImage("rawdata/test/28_16.png")
fp <- file.path("rawdata/test/28_16.png")

segValues <- segmentImage(filename = fp, maxShape = 800, minShape = 40, failureRegion = 2000,
threshold = "otsu", numWindows = 4)

display(segValues[[1]])
display(segValues[[2]])

writeImage(segValues[[2]], "rawdata/test/sample.png")



