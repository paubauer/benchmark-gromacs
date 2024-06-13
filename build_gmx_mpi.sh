#!/bin/bash
export ROCM_PATH=/opt/rocm
#export MPICH_DIR=/opt/ompi-5.0.0
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

# --with-mpi = /opt/ompi
# then $mpi =  /opt/ompi

# if --with-mpi is not passed, $mpi is empty

#if mpi is not set, do auto check
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

export PATH=$PATH:$MPICH_DIR/bin
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$MPICH_DIR/lib

export ARCH_BUILDS=gfx908,gfx90a,gfx940,gfx941,gfx942

if [ ! -d ./Gromacs-mpi ]; then
  git clone https://github.com/ROCmSoftwarePlatform/Gromacs.git -b develop_2023_amd_sprint_rocm6 Gromacs-mpi
  mkdir Gromacs-mpi/build-mpi && cd Gromacs-mpi/build-mpi


    # runs cmake on GROMACS to produce a tmpi build of gromacs
  echo "cmake ../ -DBUILD_SHARED_LIBS=off \
   -DCMAKE_BUILD_TYPE=Release \
   -DCMAKE_C_FLAGS=\"-Ofast -ggdb -I$MPICH_DIR/include -I${ROCM_PATH}/roctracer/include\" \
   -DCMAKE_CXX_FLAGS=\"-Ofast -ggdb -I$MPICH_DIR/include -I${ROCM_PATH}/roctracer/include\" \
   -DGMX_BUILD_OWN_FFTW=ON \
   -DGMX_BUILD_FOR_COVERAGE=off \
   -DCMAKE_C_COMPILER=mpicc \
   -DCMAKE_CXX_COMPILER=mpicxx \
   -DGMX_MPI=on \
   -DGMX_GPU=HIP \
   -DGMX_OPENMP=on \
   -DGMX_SIMD=AVX2_256 \
   -DREGRESSIONTEST_DOWNLOAD=OFF \
   -DBUILD_TESTING=off \
   -DGMXBUILD_UNITTESTS=off \
   -DGMX_GPU_USE_VKFFT=on \
   -DHIP_HIPCC_FLAGS=\"-O3 -ggdb --offload-arch=$ARCH_BUILDS --save-temps -I${MPICH_DIR}/include -I${ROCM_PATH}/roctracer/include\" \
   -DCMAKE_EXE_LINKER_FLAGS=\"-L${ROCM_PATH}/lib -L${ROCM_PATH}/roctracer/lib -fopenmp\"

    make -j" > build_gmx_mpi.sh
  chmod u+x build_gmx_mpi.sh
	./build_gmx_mpi.sh
	wait
  cd ../../
fi

# Extracts the stmv topology if we didn't do that already
if [ -e stmv/stmv.tar.gz ] && [ ! -e stmv/topol.tpr ]; then
  tar xzvf stmv/stmv.tar.gz -C stmv/
fi

if [ "$1" = "test" ]; then
  ./run_stmv.sh
fi

