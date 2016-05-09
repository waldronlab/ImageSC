library(CRImage)
library(EBImage)

fpatt <- "*.png"
folders <- list.dirs(recursive = FALSE,
					 path = file.path("rawdata"),
					 full.names = FALSE)

for (i in folders) {
	pngfiles <- dir(file.path("rawdata", folders[i]),
					pattern = fpatt, full.names = TRUE)
	featList <- lapply(pngfiles, function(img) {
					   segmentImage(
									filename = img,
									maxShape = 800,
									minShape = 40,
									failureRegion = 2000,
									threshold = "otsu",
									numWindows = 4)$features
					})
}

