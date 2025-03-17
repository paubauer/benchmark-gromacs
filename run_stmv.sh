#!/bin/bash

# runs just STMV for validation on a single GPU and the 24 first cores
export GPUID=0
export BINDIR=$(pwd)/$1


$BINDIR/gmx mdrun -resethway -nsteps -1 -maxh 0.2 -v -stepout 1000 -noconfout -nstlist 300 -nb gpu -bonded gpu -pme gpu -update gpu -pin on -ntomp 24 -g md_1gpu.log -gpu_id $GPUID -s stmv/topol.tpr -tunepme no


