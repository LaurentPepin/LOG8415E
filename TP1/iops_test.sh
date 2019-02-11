#!/bin/bash

INSTANCE=$1

RESULTS_FILE_NAME="./results/iops_test_results.csv"

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

for n1024Files in {1..5}; do

  results=(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)

  for iteration in {1..5}; do
	  rawResults=$(bonnie++ -d $directory -s 0 -n $n1024Files:10000:1000 -m $INSTANCE -x 1)
	  echo $rawResults
    for index in {1..18}; do
      if [[ "$index" -gt 12 ]]; then
	      substring=$((30+$index))
      else
	      substring=$((24+$index))
      fi
      subResult=$(echo $rawResults | cut -d ',' -f $substring)
      if [[ "$subResult" == *"+"* ]]; then
        subResult=0
      fi
      subResult=$(echo $subResult | cut -d 'u' -f 1)
      results[$index-1]=$(python -c "print float($subResult) + ${results[$index-1]}")
    done
  done
  for i in {1..18}; do
	  results[$i-1]=$(python -c "print ${results[$i-1]} / 5.0")
  done
  stringResults=${results[@]}
  echo ${stringResults// /,} >> $RESULTS_FILE_NAME
done

rm -rf iopsTestFiles
