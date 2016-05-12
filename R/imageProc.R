library(CRImage)
library(EBImage)

args <- (commandArgs(TRUE))
if (all(names(args) == c("maxShape", "minShape", "failureRegion", "numWindows", "pattern", "disease"))) {
stop("supplied arguments must match segmentImage arguments and image search pattern\n",
'\tc("maxShape", "minShape", "failureRegion", "numWindows", "pattern", "disease")')
}

numerics <- c("maxShape", "minShape", "failureRegion", "numWindows")
args[numerics] <- lapply(args[numerics], as.numeric)

disease <- args$disease

ImgPattern <- args$pattern
folders <- list.dirs(recursive = FALSE,
                     path = file.path("rawdata", disease),
                     full.names = FALSE)

for (i in folders) {
    imgFiles <- dir(file.path("rawdata", disease, folders[i]),
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
    saveRDS(featList, file = file.path("rawdata", disease,
                        paste0(folders[i], "_features", ".rds")),
                        compress = "bzip2")
}

