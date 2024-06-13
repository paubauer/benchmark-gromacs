#!/bin/bash
#export MPICH_DIR=/opt/ompi-5.0.0

export GPUID=01234567
export ROOT=$(pwd)

export GMX_ENABLE_DIRECT_GPU_COMM=1
export AMD_DIRECT_DISPATCH=1
export GMX_GPU_PME_DECOMPOSITION=1
export GMX_GPU_DD_COMMS=true
export GMX_GPU_PME_PP_COMMS=true
export GMX_FORCE_GPU_AWARE_MPI=true
export GMX_FORCE_UPDATE_DEFAULT_GPU=true

$ROOT/Gromacs/build-threads/bin/gmx mdrun -resethway -nsteps -1 -maxh 0.1 -v -stepout 1000 -noconfout -nstlist 300 -nb gpu -bonded gpu -pme gpu -update gpu -pin on -ntmpi 8 -ntomp 14 -npme 1 -g md_1gpu.log -gpu_id $GPUID -s stmv/topol.tpr -tunepme no 
