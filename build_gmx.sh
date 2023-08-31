#!/bin/bash
export ARCH_BUILDS=gfx90a,gfx940
export ROOT=$(pwd)

if [ ! -d ./Gromacs ]; then
  git clone https://github.com/ROCmSoftwarePlatform/Gromacs.git -b develop_2023_amd_sprint_rocm6 Gromacs
  mkdir Gromacs/build-threads && cd Gromacs/build-threads


  # runs cmake on GROMACS to produce a tmpi build of gromacs

  cmake ../ -DBUILD_SHARED_LIBS=off \
   -DCMAKE_BUILD_TYPE=Release \
   -DCMAKE_C_FLAGS="-Ofast -ggdb -I${ROCM_PATH}/roctracer/include" \
   -DCMAKE_CXX_FLAGS="-Ofast -ggdb -I${ROCM_PATH}/roctracer/include" \
   -DGMX_BUILD_OWN_FFTW=ON \
   -DGMX_BUILD_FOR_COVERAGE=off \
   -DCMAKE_C_COMPILER=gcc \
   -DCMAKE_CXX_COMPILER=g++ \
   -DGMX_MPI=off \
   -DGMX_GPU=HIP \
   -DGMX_OPENMP=on \
   -DGMX_SIMD=AVX2_256 \
   -DREGRESSIONTEST_DOWNLOAD=OFF \
   -DBUILD_TESTING=off \
   -DGMXBUILD_UNITTESTS=off \
   -DGMX_GPU_USE_VKFFT=on \
   -DHIP_HIPCC_FLAGS="-O3 -ggdb --offload-arch=$ARCH_BUILDS --save-temps -I${MPICH_DIR}/include -I${ROCM_PATH}/roctracer/include" \
   -DCMAKE_EXE_LINKER_FLAGS="-L${ROCM_PATH}/lib -L${ROCM_PATH}/roctracer/lib -fopenmp"

    make -j
    cd ../../
fi

# Puts gmx bin into path for the script
export PATH=$PATH:${ROOT}/Gromacs/build-threads/bin

# Extracts the stmv topology if we didn't do that already
if [ -e stmv/stmv.tar.gz ] && [ ! -e stmv/topol.tpr ]; then
  tar xzvf stmv/stmv.tar.gz -C stmv/
fi

# runs just STMV for validation on a single GPU and the 24 first cores
export GPUID=0
$ROOT/Gromacs/build-threads/bin/gmx mdrun -resetstep 8000 -nsteps 10000 -v -stepout 1000 -noconfout -nstlist 300 -nb gpu -bonded gpu -pme gpu -update gpu -pin on -ntmpi 1 -ntomp 24 -g md_1gpu.log -gpu_id $GPUID -s stmv/topol.tpr -tunepme no

# runs tmpi benchmarks for validation
# ./run_benchmarks.sh -t tmpi 
