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
  
  # CPU
  ./cpu_test.sh $INSTANCE

  # IO
  ./IO_write_test.sh $INSTANCE $DISK_PARTITION
  
  #IO latency
  ./IO_latency_test.sh $INSTANCE
  
  # IOPS
  ./iops_test.sh $INSTANCE

  # Memory
  ./memory_test.sh $INSTANCE

  # Disk
  ./io_read_test.sh $INSTANCE $DISK_PARTITION

  # Network
  ./network_test.sh $INSTANCE 911
done
