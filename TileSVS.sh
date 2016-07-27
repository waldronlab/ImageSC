#!/bin/bash

oldDir=$(pwd)

cd /scratch/${3}/${4}/

shopt -s nullglob
FILES=(*.svs)
if [ ${#FILES[@]} -eq 0 ]; then 
    echo "no svs files found"
else
    for i in "${FILES[@]}"
    do
        FOLDER=$(echo ${i} | cut -d. -f1)
        if [ -d ${FOLDER} ]; then
            echo "${FOLDER} exists"
        else
            mkdir ${FOLDER}
            echo "$i -> ${FOLDER}"
            vips dzsave ${i} ${FOLDER}/ --suffix ${2} --tile-size ${1} --depth 1
            cd ./${FOLDER}/${FOLDER}_files/0
            shopt -s dotglob
            mv -- * ../..
            shopt -u dotglob
            cd ../..
            rm -r ./${FOLDER}_files
            mv *.dzi ../
            cd ..
        fi
    done
fi
shopt -u nullglob

cd ${oldDir}

echo "done"
