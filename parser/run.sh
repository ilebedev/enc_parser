#!/bin/bash

CURRDIR=$(pwd)

FILE=13246

mkdir -p .tmp
cp ../bench/${FILE}.zip .tmp/
cd .tmp; unzip ${FILE}.zip
cd $CURRDIR


