#!/bin/bash -x

# export HIP_VISIBLE_DEVICES=$OMPI_COMM_WORLD_LOCAL_RANK
case $OMPI_COMM_WORLD_LOCAL_RANK in
  0) cpus=0-7; memory=0; hip_devices=0;;
  1) cpus=8-15; memory=0; hip_devices=0;;
  2) cpus=16-23; memory=0; hip_devices=0;;
  3) cpus=24-31; memory=1; hip_devices=1;;
  4) cpus=32-39; memory=1; hip_devices=1;;
  5) cpus=40-47; memory=1; hip_devices=1;;
  6) cpus=48-55; memory=2; hip_devices=2;;
  7) cpus=56-63; memory=2; hip_devices=2;;
  8) cpus=64-71; memory=2; hip_devices=2;;
  9) cpus=72-79; memory=3; hip_devices=3;;
  10) cpus=80-87; memory=3; hip_devices=3;;
  11) cpus=88-95; memory=3; hip_devices=3;;
esac

export HIP_VISIBLE_DEVICES=$hip_devices
export GOMP_CPU_AFFINITY=$cpus
numactl --all -C $cpus -m $memory $@
