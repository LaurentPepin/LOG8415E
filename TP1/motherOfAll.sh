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
