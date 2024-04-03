#!/bin/bash

# export HIP_VISIBLE_DEVICES=$OMPI_COMM_WORLD_LOCAL_RANK
case $OMPI_COMM_WORLD_LOCAL_RANK in
  [0]) cpus=0-15; memory=0; hip_devices=0;;
  [1]) cpus=16-31; memory=0; hip_devices=0;;
  [2]) cpus=32-46; memory=1; hip_devices=1;;
  [3]) cpus=47-47; memory=1; hip_devices=1;;
esac

export HIP_VISIBLE_DEVICES=$hip_devices
export GOMP_CPU_AFFINITY=$cpus
numactl --all -C $cpus -m $memory $@
