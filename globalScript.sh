#!/bin/bash
# This script is meant to delegate the arguments to other R scripts and shell scripts.
# Process is broken down into three steps. See below. 

# Download image files from TCGA data portal
R CMD BATCH --no-save --no-restore '--args disease="prad" user="marcel.ramos"' R/dlImages.R downloadLogs.out

# Tile images
./TileSVS.sh 400 .png marcel.ramos prad

# Segment and Extract Features
R CMD BATCH --no-save --no-restore '--args maxShape=800 minShape=40 failureRegion=2000 numWindows=4 pattern="\\.png" disease="prad" user="marcel.ramos"' R/imageProc.R segments.out

echo "done"
