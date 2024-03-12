#!/bin/bash

export HIP_VISIBLE_DEVICES=$OMPI_COMM_WORLD_LOCAL_RANK
case $OMPI_COMM_WORLD_LOCAL_RANK in
  [0]) cpus=0-23; memory=0;;
  [1]) cpus=24-47; memory=1;;
  [2]) cpus=48-71; memory=2;;
  [3]) cpus=72-95; memory=3;;
esac
export GOMP_CPU_AFFINITY=$cpus
numactl -C $cpus -m $memory $@
