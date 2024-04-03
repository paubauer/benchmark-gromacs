#!/bin/bash

# export HIP_VISIBLE_DEVICES=$OMPI_COMM_WORLD_LOCAL_RANK
case $OMPI_COMM_WORLD_LOCAL_RANK in
  [0]) cpus=0-11; memory=0; hip_devices=0;;
  [1]) cpus=12-23; memory=0; hip_devices=0;;
  [2]) cpus=24-35; memory=1; hip_devices=1;;
  [3]) cpus=36-47; memory=1; hip_devices=1;;
  [4]) cpus=48-59; memory=2; hip_devices=2;;
  [5]) cpus=60-71; memory=2; hip_devices=2;;
  [6]) cpus=72-83; memory=3; hip_devices=3;;
  [7]) cpus=84-95; memory=3; hip_devices=3;;
esac

export HIP_VISIBLE_DEVICES=$hip_devices
export GOMP_CPU_AFFINITY=$cpus
numactl --all -C $cpus -m $memory $@
