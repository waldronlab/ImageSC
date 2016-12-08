#!/bin/bash
# Arguments
# 1. An SVS file

# This script shows you things you can do to SVS images.
# The SVS file type is a pyramidal (multipage) TIFF file. 

# See list contents of an SVS image
identify '$1'

# to convert an SVS image
convert '$1[3]' $1-1.png

# to display an image
display '$1[3]'
