#!/bin/bash

fnames=$(ls -1 *.svs)

folders=$(echo $fnames | cut -d. -f1)

for i in $folders
do 
	if [ -d ${i} ]; then
		echo "${i} exists"
	else
		mkdir ${i}
		# vips dzsave 
	fi
done
 
# pseudo code for foldername (fix to come)
vips dzsave $1 foldername --suffix .png --tile.size 400 --depth 1
echo done
