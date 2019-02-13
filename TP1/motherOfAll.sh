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
  
  
  ./iops_test.sh $INSTANCE

  ./network_test.sh $INSTANCE 911
done

./cpu_test.sh $INSTANCE

./IO_latency_test.sh $INSTANCE

./IO_read_test.sh $INSTANCE $DISK_PARTITION

./IO_test.sh $INSTANCE

BLOCK_SIZE_1=$(./IO_write_blocksize_test.sh $INSTANCE)

./IO_write_load_test.sh $INSTANCE $BLOCK_SIZE_1

./iops_test.sh $INSTANCE

BLOCK_SIZE_2_READ=$(./memory_read_block_size_test.sh $INSTANCE)
BLOCK_SIZE_2_WRITE=$(./memory_write_block_size_test.sh $INSTANCE)

./memory_read_total_size_test.sh $INSTANCE $BLOCK_SIZE_2_READ
./memory_write_total_size_test.sh $INSTANCE $BLOCK_SIZE_2_WRITE

./network_test.sh $INSTANCE 911
