#!/bin/bash

export MPICH_DIR=/opt/ompi-5.0.0
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
export GMX_FORCE_GPU_AWARE_MPI=true
export GMX_FORCE_UPDATE_DEFAULT_GPU=true

mpirun --map-by package -x HIP_VISIBLE_DEVICES=0,1,2,3 --mca pml ucx -x UCX_MM_SEG_SIZE=60k --mca coll_ucc_enable 1 --mca coll_ucc_priority 100 -x UCX_ROCM_COPY_H2D_THRESH=256 -np 4 ./set_mpi_affinities.sh $ROOT/Gromacs/build-mpi/bin/gmx_mpi mdrun -resethway -nsteps -1 -maxh 0.1 -v -stepout 1000 -noconfout -nstlist 300 -nb gpu -bonded gpu -pme gpu -update gpu -pin off -ntomp 24 -npme 1 -g md_1gpu.log -gpu_id $GPUID -s stmv/topol.tpr -tunepme no
