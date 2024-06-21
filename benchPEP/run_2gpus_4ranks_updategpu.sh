#!/bin/bash

export MPICH_DIR=/opt/ompi-5.0.3
export PATH=$PATH:$MPICH_DIR/bin
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$MPICH_DIR/lib

export GPUID=0
export ROOT=$(pwd)

export MPICH_GPU_SUPPORT_ENABLED=1
export GMX_ENABLE_DIRECT_GPU_COMM=1
export AMD_DIRECT_DISPATCH=1
export GMX_GPU_PME_DECOMPOSITION=1
export GMX_FORCE_CUDA_AWARE_MPI=1
export GMX_GPU_DD_COMMS=true
export GMX_GPU_PME_PP_COMMS=true
export GMX_USE_GPU_BUFFER_OPS=1
export GMX_FORCE_GPU_AWARE_MPI=true
export GMX_FORCE_UPDATE_DEFAULT_GPU=true


export HSA_XNACK=1
export HSA_ENABLE_SDMA=0
export HSA_ENABLE_SDMA_GANG=0

export GPUID=0
export ROOT=$(pwd)/..

mpirun -x HIP_VISIBLE_DEVICES=0,1,2,3 --mca pml ucx \
       -np 4 ./set_mpi_affinities_4ranks.sh \
       $ROOT/Gromacs-mpi/build-mpi/bin/gmx_mpi mdrun \
       -maxh 0.05 -resethway -nsteps -1 -v -stepout 100 -noconfout -nstlist 300 \
       -nb gpu -bonded gpu -pme gpu -update gpu -pin auto -ntomp 12 -npme 1 -g md_1gpu.log \
       -gpu_id $GPUID -s benchPEP.tpr -tunepme no
