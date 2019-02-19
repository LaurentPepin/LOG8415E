#!/bin/bash

INSTANCE=$1
DISK_PARTITION=$2

if [[ "$INSTANCE" == "" || "$DISK_PARTITION" == "" ]]; then
  echo "First parameter is INSTANCE"
  echo "Second parameter is DISK_PARTITION"
  exit 1
fi

yes | ./installation.sh

for iteration in {1..5}; do
  echo "\n************************ Starting CPU test"
  # CPU
  ./cpu_test.sh $INSTANCE

  echo "************************ Starting IO test"
  # IO
  ./IO_write_test.sh $INSTANCE $DISK_PARTITION
  
  echo "************************ Starting IO latency test"
  #IO latency
  ./IO_latency_test.sh $INSTANCE
  
  echo "************************ Starting IOPS test"
  # IOPS
  ./iops_test.sh $INSTANCE

  echo "************************ Starting Memory test"
  # Memory
  ./memory_test.sh $INSTANCE

  echo "************************ Starting Disk test"
  # Disk
  ./io_read_test.sh $INSTANCE $DISK_PARTITION

  echo "************************ Starting Network test"
  # Network
  ./network_test.sh $INSTANCE 911
done

git pull
git add ./results/cpu_results_$INSTANCE.csv
git add ./results/IO_latency_test_result_$INSTANCE.csv
git add ./results/io_read_test_results_$INSTANCE.csv
git add ./results/IO_write_results_$INSTANCE.csv
git add ./results/iops_test_results_$INSTANCE.csv
git add ./results/network_test_results_$INSTANCE.csv
git add ./results/memory_test_results_$INSTANCE.csv
git add ./results/network_test_results_$INSTANCE.csv
git commit -m "benchmarking results for instance : $INSTANCE"
git push 