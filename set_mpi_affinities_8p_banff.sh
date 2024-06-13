#!/bin/bash

export HIP_VISIBLE_DEVICES=$OMPI_COMM_WORLD_LOCAL_RANK
case $OMPI_COMM_WORLD_LOCAL_RANK in
  0) cpus=0-13; memory=0;;
  1) cpus=14-27; memory=0;;
  2) cpus=28-41; memory=0;;
  3) cpus=42-55; memory=0;;
  4) cpus=56-69; memory=1;;
  5) cpus=70-83; memory=1;;
  6) cpus=84-97; memory=1;;
  7) cpus=98-111; memory=1;;
esac
export GOMP_CPU_AFFINITY=$cpus
numactl --all -C $cpus -m $memory $@
