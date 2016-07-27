#!/bin/bash

R CMD BATCH --no-save --no-restore '--args disease="prad" user="marcel.ramos"' R/dlImages.R downloadLogs.out

./TileSVS.sh 400 .png marcel.ramos prad

R CMD BATCH --no-save --no-restore '--args maxShape=800 minShape=40 failureRegion=2000 numWindows=4 pattern="\\.png" disease="prad" user="marcel.ramos"' R/imageProc.R segments.out

echo "done"
