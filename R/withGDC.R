library(GenomicDataCommons)

diseaseCode <- "THCA"
base_dir <- "~/data"
data_path <- file.path(base_dir, diseaseCode)

dir.create(data_path, recursive = TRUE)
gdc_set_cache(data_path)

image_manifest <- files(legacy = TRUE) %>%
    filter ( ~ cases.project.project_id == "TCGA-THCA" &
        data_format == "SVS") %>%
            manifest()

mani <- head(image_manifest, 1)

gdcdata(mani$id, use_cached = TRUE)
