library(httr)

args <- (commandArgs(TRUE))
disease <- tolower(args$disease)

imgUrl <- paste0("https://tcga-data.nci.nih.gov/tcgafiles/ftp_auth/distro_ftpusers/anonymous/tumor/", 
disease, "/bcr/nationwidechildrens.org/diagnostic_images/slide_images/")

webResponse <- GET(imgUrl)
parsedResponse <- content(webResponse, "parsed")

## create list out of the parsed response
linesRead <- unlist(as_list(parsedResponse)$body$pre)

## Take nationwidechildrens.org files
linesRead <- linesRead[grep("nation", linesRead)]

## Obtain tar.gz filenames
compressedImageFiles <- unname(grep("tar\\.gz$", linesRead, value = TRUE))

## Download file to memory
for (i in seq_along(compresssedImage)) {
    GET(file.path(imgUrl, compressedImageFiles[i]),
        write_disk(file.path("rawdata", compressedImageFiles[i])))
}

tarFiles <- list.files(path = "./rawdata", pattern = ".tar.gz", full.names = TRUE)
for (i in tarFiles) {
    innerFiles <- untar(i, compressed = "gzip", list = TRUE)
    imageFiles <- grep("\\.svs$", innerFiles, value = TRUE)
    untar(i, files = imageFiles, exdir = file.path("rawdata", imageFiles))
}
