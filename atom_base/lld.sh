#!/usr/bin/env sh
# setup
set -x
set -e

lld_version=9.0.1
lld_directory=lld-${lld_version}.src
lld_source_url=https://github.com/llvm/llvm-project/releases/download/llvmorg-${lld_version}/${lld_directory}.tar.xz

printf "[settings]\nos=Linux\nos_build=Linux\narch=x86_64\narch_build=x86_64\ncompiler=gcc\ncompiler.version=9.2\ncompiler.libcxx=libstdc++11\nbuild_type=Release\n[env]\nCC=${TOOLCHAIN_PREFIX}/bin/gcc\nCXX=${TOOLCHAIN_PREFIX}/bin/g++\nLD_LIBRARY_PATH=[/${TOOLCHAIN_PREFIX}/lib64]\nCONAN_CMAKE_GENERATOR=Ninja" > ~/.conan/profiles/default
mkdir -p "${TOOLCHAIN_BUILD_DIR}/lld" && cd "${TOOLCHAIN_BUILD_DIR}/lld"
printf "[build_requires]\ncmake/3.15.4@tdelame/stable\nninja/1.9.0@tdelame/stable\n[generators]\nvirtualenv" > conanfile.txt
conan install .
source "${TOOLCHAIN_BUILD_DIR}/lld/activate.sh"

wget -q -O - ${lld_source_url} | tar -Jxf - && mv ${lld_directory} lld
mkdir lld/build && cd lld/build 
cmake .. -G Ninja -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=$TOOLCHAIN_PREFIX                                                  \
  -DCMAKE_AR=${TOOLCHAIN_PREFIX}/bin/gcc-ar -DCMAKE_NM=${TOOLCHAIN_PREFIX}/bin/gcc-nm -DCMAKE_RANLIB=${TOOLCHAIN_PREFIX}/bin/gcc-ranlib\
  -DBUILD_SHARED_LIBS=ON -DLLVM_LINK_LLVM_DYLIB=ON -DCLANG_LINK_CLANG_DYLIB=OFF -DLLVM_ENABLE_RTTI=ON                                  \
  -DLLVM_BUILD_DOCS=OFF -DLLVM_BUILD_TESTS=OFF -DLLVM_BUILD_INSTRUMENTED_COVERAGE=OFF                                                  \
  -DLLVM_INCLUDE_EXAMPLES=OFF -DLLVM_INCLUDE_DOCS=OFF -DLLVM_INCLUDE_TESTS=OFF -DLLVM_INCLUDE_BENCHMARKS=OFF                           \
  -DLLVM_ENABLE_DOXYGEN=OFF -DLLVM_ENABLE_SPHINX=OFF -DLLVM_ENABLE_BINDINGS=OFF                                                        \
  -DLLVM_MAIN_SRC_DIR=${TOOLCHAIN_BUILD_DIR}/llvm/llvm
ninja
ninja install

source ../../deactivate.sh
