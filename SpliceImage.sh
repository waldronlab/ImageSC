#!/bin/bash

convert $1 -crop $2@ +repage +adjoin $1_$2@_%d.jpg
echo done
