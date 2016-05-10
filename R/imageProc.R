library(CRImage)
library(EBImage)

args <- (commandArgs(TRUE))
if (all(names(args) == c("maxShape", "minShape", "failureRegion", "numWindows", "pattern"))) {
stop("supplied arguments must match segmentImage arguments and image search pattern\n",
'\tc("maxShape", "minShape", "failureRegion", "numWindows", "pattern")')
}
args[1:4] <- lapply(args[1:4], as.numeric)

ImgPattern <- args$pattern
folders <- list.dirs(recursive = FALSE,
                     path = file.path("rawdata"),
                     full.names = FALSE)

for (i in folders) {
    imgFiles <- dir(file.path("rawdata", folders[i]),
                    pattern = ImgPattern, full.names = TRUE)
    featList <- lapply(imgFiles, function(img) {
                       segmentImage(
                                    filename = img,
                                    maxShape = args$maxShape,
                                    minShape = args$minShape,
                                    failureRegion = args$failureRegion,
                                    threshold = "otsu",
                                    numWindows = args$numWindows)$features
                    })
    saveRDS(featList, file = paste0(folders[i], "_features", ".rds"), compress = "bzip2")
}

