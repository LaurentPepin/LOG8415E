#!/bin/bash

INSTANCE=$1
RESULTS_FILE_NAME="cpu_test_results.csv"

if [[ "$INSTANCE" == "" ]]; then
  echo "First parameter is INSTANCE"
  exit 1
fi

if [ ! -f $RESULTS_FILE_NAME ]; then
  echo "instance,max_prime,time" > $RESULTS_FILE_NAME
fi

for power in {1..9}; do
  maxPrime=$((10**$power))
  for iteration in {1..5}; do
    totalTime=$(python -c "print $(sysbench --test=cpu --cpu-max-prime=$maxPrime run | grep "total time:" | grep -oP "\d+\.\d+") + $totalTime")
  done
  totalTime=$(python -c "print $totalTime / 5.0")
  echo $INSTANCE,$maxPrime,$totalTime >> $RESULTS_FILE_NAME
done
