#!/bin/bash

INSTANCE=$1

RESULTS_FILE_NAME="iops_test_results.csv"

if [[ "$INSTANCE" == "" ]]; then
  echo "First parameter is INSTANCE"
  exit 1
fi

if [ ! -f $RESULTS_FILE_NAME ]; then
	echo Instance,numFiles,sequentialCreateBySec,sequentialCreateCPU%,\
  sequentialReadBySec,sequentialReadCPU%,sequentialDeleteBySec,sequentialDeleteCPU%,\
  randomCreateBySec,randomCreateCPU%,randomReadBySec,randomReadCPU%,randomDeleteBySec,randomDeleteCPU%,\
  sequentialCreateLatency,sequentialReadLatency,sequentialDeleteLatency,randomCreateLatency,randomReadLatency,\
  randomDeleteLatency > $RESULTS_FILE_NAME
fi

mkdir -p iopsTestFiles
directory="./iopsTestFiles"

for n1024Files in {1..1}; do

  results=(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)

  for iteration in {1..1}; do
	  rawResults=$(bonnie++ -d $directory -s 0 -n $n1024Files:10000:1000 -m $INSTANCE -x 1)
    echo rawResults
    for index in {1..18}; do
      if [[ $index -qt 12 ]]; do
        substring=$(30+$index)
      else
        substring=$(24+$index)
      fi
      subResult=$(echo $rawResults | cut -d ',' -f $substring)
      if [[ "$subResult" == *"+"* ]]; then
        subResult=0
      fi
      subResult=$(echo subResult | cut -d 'u' -f 1)
      rawResults[$index]=$(python -c "print $subResult + ${results[$index]}")
    done
  done
  echo ${results[@]}
done

rm -rf iopsTestFiles