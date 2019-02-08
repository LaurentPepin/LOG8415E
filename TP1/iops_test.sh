#!/bin/bash

INSTANCE=$1

if [[ "$INSTANCE" == "" ]]; then
  echo "First parameter is INSTANCE"
  exit 1
fi

mkdir -p iopsTestFiles
directory="./iopsTestFiles"

for n1024Files in {1..5}; do
  for iteration in {1..5}; do
    bonnie++ -d $directory -s 0 -n $n1024Files:10000:1000 -m $INSTANCE -x 1 | bon_csv2html > iopsResultsHTML.html 
  done
done
