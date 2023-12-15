# runs just STMV for validation on a single GPU and the 24 first cores
export GPUID=0123
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

numactl -C 0-95 $ROOT/Gromacs/build-threads/bin/gmx mdrun -resethway -nsteps 10000 -v -stepout 1000 -noconfout -nstlist 300 -nb gpu -bonded gpu -pme gpu -update gpu -ntmpi 4 -ntomp 24 -npme 1 -g md_1gpu.log -gpu_id $GPUID -s stmv/topol.tpr -tunepme no 
