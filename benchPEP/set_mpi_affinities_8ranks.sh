#!/bin/bash

# export HIP_VISIBLE_DEVICES=$OMPI_COMM_WORLD_LOCAL_RANK
case $OMPI_COMM_WORLD_LOCAL_RANK in
  [0]) cpus=0-5; memory=0; hip_devices=0;;
  [1]) cpus=6-11; memory=0; hip_devices=0;;
  [2]) cpus=12-17; memory=0; hip_devices=0;;
  [3]) cpus=18-23; memory=0; hip_devices=0;;
  [4]) cpus=24-29; memory=1; hip_devices=1;;
  [5]) cpus=30-35; memory=1; hip_devices=1;;
  [6]) cpus=36-41; memory=1; hip_devices=1;;
  [7]) cpus=42-47; memory=1; hip_devices=1;;
esac

export HIP_VISIBLE_DEVICES=$hip_devices
export GOMP_CPU_AFFINITY=$cpus
numactl --all -C $cpus -m $memory $@
