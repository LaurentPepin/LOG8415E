#!/bin/bash

INSTANCE=$1
N_1024_FILES=$2
RESULTS_FILE_NAME="./results/iops_test_results.csv"

if [[ "$INSTANCE" == "" || "$N_1024_FILES" == "" ]]; then
  echo "First parameter is INSTANCE"
  echo "Second parameter is N_1024_FILES"
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

results=(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
rawResults=$(bonnie++ -d $directory -s 0 -n $N_1024_FILES:10000:1000 -m $INSTANCE -x 1)
for index in {1..18}
do
  if [[ "$index" -gt 12 ]]; then
    substring=$((30+$index))
  else
    substring=$((24+$index))
  fi
  subResult=$(echo $rawResults | cut -d ',' -f $substring)
  if [[ "$subResult" == *"+"* ]]; then
    subResult=0
  fi
  if [[ "$subResult" == *"m"* ]]; then
    subResult=$(echo $subResult | cut -d 'm' -f 1)
    results[$index-1]=$(python -c "print float($subResult) * 1000")
  else
    subResult=$(echo $subResult | cut -d 'u' -f 1)
    results[$index-1]=$(python -c "print float($subResult)")
  fi  
done

stringResults=${results[@]}
echo $INSTANCE,$N_1024_FILES,${stringResults// /,}
echo $INSTANCE,$N_1024_FILES,${stringResults// /,} >> $RESULTS_FILE_NAME

rm -rf iopsTestFiles
