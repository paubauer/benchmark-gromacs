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
  [0]) cpus=0-23; memory=0; hip_devices=0;;
  [1]) cpus=24-47; memory=1; hip_devices=1;;
  [2]) cpus=0-23; memory=0; hip_devices=0;;
  [3]) cpus=24-47; memory=1; hip_devices=1;;
esac

export HIP_VISIBLE_DEVICES=$hip_devices
export GOMP_CPU_AFFINITY=$cpus
numactl --all -C $cpus -m $memory $@
