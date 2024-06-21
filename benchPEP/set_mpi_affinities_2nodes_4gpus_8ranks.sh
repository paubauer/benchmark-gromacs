#!/bin/bash

export MPICH_GPU_SUPPORT_ENABLED=1
export GMX_ENABLE_DIRECT_GPU_COMM=1
export AMD_DIRECT_DISPATCH=1
export GMX_GPU_PME_DECOMPOSITION=1
export GMX_FORCE_CUDA_AWARE_MPI=1
export GMX_GPU_DD_COMMS=true
export GMX_GPU_PME_PP_COMMS=true
export GMX_FORCE_GPU_AWARE_MPI=true
export GMX_FORCE_UPDATE_DEFAULT_GPU=true


# export HIP_VISIBLE_DEVICES=$OMPI_COMM_WORLD_LOCAL_RANK
case $OMPI_COMM_WORLD_LOCAL_RANK in
  [0]) cpus=0-11; memory=0; hip_devices=0;  tasks=0000;;
  [1]) cpus=12-23; memory=0; hip_devices=0; tasks=0000;;
  [2]) cpus=24-35; memory=1; hip_devices=1; tasks=0000;;
  [3]) cpus=36-47; memory=1; hip_devices=1; tasks=0000;;
  [4]) cpus=0-11;  memory=0; hip_devices=0; tasks=0001;;
  [5]) cpus=12-23; memory=0; hip_devices=0; tasks=0001;;
  [6]) cpus=24-35; memory=1; hip_devices=1; tasks=0001;;
  [7]) cpus=36-47; memory=1; hip_devices=1; tasks=0001;;
esac

export TASKS=$tasks
#export HIP_VISIBLE_DEVICES=$hip_devices
export GOMP_CPU_AFFINITY=$cpus
numactl --all -C $cpus -m $memory $@
