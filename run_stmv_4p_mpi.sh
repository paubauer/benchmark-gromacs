#!/bin/bash
for i in "$@"; do
    case "$1" in     
        -with-mpi=*|--with-mpi=*)
	    mpi="${i#*=}"
	    shift # past argument=value
	    ;;
	--)
            shift
            break
            ;;
    esac
done
echo $mpi


if [ -z ${mpi+x} ];#check if value is passed as an arg
then
  echo "checking for existing /opt/ompi"
  #attempt to read any ompi version in /opt
  mpi=$(readlink -f /opt/omp*)
  if test -d $mpi; then
    echo "Found" $mpi"! exporting as MPICH_DIR"
	  export PATH=$mpi/bin/:$PATH
    export MPICH_DIR=$mpi
  else
    echo "Could NOT find MPI Path. Exiting"
    exit 1
  fi
else
    if test -d $mpi/; #check value of passed argument
    then
      export PATH=$mpi/bin/:$PATH
      export MPICH_DIR=$mpi
    else
      echo "MPI arg not a real path. Exiting"
      exit 1
    fi
fi

#export MPICH_DIR=/opt/ompi-5.0.0
export PATH=$PATH:$MPICH_DIR/bin
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$MPICH_DIR/lib

export BINDIR=$1

export MPICH_GPU_SUPPORT_ENABLED=1
export GMX_ENABLE_DIRECT_GPU_COMM=1
export AMD_DIRECT_DISPATCH=1
export GMX_GPU_PME_DECOMPOSITION=1
export GMX_FORCE_CUDA_AWARE_MPI=1
export GMX_GPU_DD_COMMS=true
export GMX_GPU_PME_PP_COMMS=true
export GMX_FORCE_GPU_AWARE_MPI=true
export GMX_FORCE_UPDATE_DEFAULT_GPU=true

mpirun -x --mca pml ucx -x UCX_MM_SEG_SIZE=60k --mca coll_ucc_enable 1 --mca coll_ucc_priority 100 -x UCX_ROCM_COPY_H2D_THRESH=256 -np 4 ./set_mpi_affinities.sh $BINDIR/gmx_mpi mdrun -resethway -nsteps -1 -maxh 0.2 -v -stepout 1000 -noconfout -nstlist 300 -nb gpu -bonded gpu -pme gpu -update gpu -pin off -ntomp 24 -npme 1 -g md_4gpu-mpi.log -s stmv/topol.tpr -tunepme no
