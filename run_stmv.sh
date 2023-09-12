# runs just STMV for validation on a single GPU and the 24 first cores
export GPUID=0
export ROOT=$(pwd)

$ROOT/Gromacs/build-threads/bin/gmx mdrun -resetstep 8000 -nsteps 10000 -v -stepout 1000 -noconfout -nstlist 300 -nb gpu -bonded gpu -pme gpu -update gpu -pin on -ntmpi 1 -ntomp 24 -g md_1gpu.log -gpu_id $GPUID -s stmv/topol.tpr -tunepme no


