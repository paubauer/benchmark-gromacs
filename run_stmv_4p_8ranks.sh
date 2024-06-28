#!/bin/bash

export MPICH_DIR=/opt/ompi-5.0.3
export PATH=$PATH:$MPICH_DIR/bin
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$MPICH_DIR/lib

#export GPUID=0123
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

mpirun --mca pml ucx -np 8 ./set_mpi_affinities_8ranks.sh $ROOT/Gromacs-mpi/build-mpi/bin/gmx_mpi mdrun -resethway -nsteps -1 -maxh 0.4 -v -stepout 1000 -noconfout -nstlist 400 -dlb yes -nb gpu -bonded gpu -pme gpu -update gpu -pin off -ntomp 8 -npme 1 -g md_1gpu.log -s stmv/topol.tpr -tunepme  -gpu_id $GPUID
