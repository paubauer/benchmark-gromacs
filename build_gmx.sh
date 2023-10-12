#!/bin/bash
export ARCH_BUILDS=gfx908,gfx90a,gfx940,gfx942

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

# Extracts the stmv topology if we didn't do that already
if [ -e stmv/stmv.tar.gz ] && [ ! -e stmv/topol.tpr ]; then
  tar xzvf stmv/stmv.tar.gz -C stmv/
fi

if [ "$1" = "test" ]; then
  ./run_stmv.sh
fi

