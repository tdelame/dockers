#!/usr/bin/env sh
# setup
set -x
set -e

rt_version=9.0.1
rt_directory=compiler-rt-${rt_version}.src
rt_source_url=https://github.com/llvm/llvm-project/releases/download/llvmorg-${rt_version}/${rt_directory}.tar.xz

printf "[settings]\nos=Linux\nos_build=Linux\narch=x86_64\narch_build=x86_64\ncompiler=gcc\ncompiler.version=9.2\ncompiler.libcxx=libstdc++11\nbuild_type=Release\n[env]\nCC=${TOOLCHAIN_PREFIX}/bin/gcc\nCXX=${TOOLCHAIN_PREFIX}/bin/g++\nLD_LIBRARY_PATH=[/${TOOLCHAIN_PREFIX}/lib64]\nCONAN_CMAKE_GENERATOR=Ninja" > ~/.conan/profiles/default
mkdir -p "${TOOLCHAIN_BUILD_DIR}/compiler-rt" && cd "${TOOLCHAIN_BUILD_DIR}/compiler-rt"
printf "[build_requires]\ncmake/3.15.4@tdelame/stable\nninja/1.9.0@tdelame/stable\n[generators]\nvirtualenv" > conanfile.txt
conan install .
source "${TOOLCHAIN_BUILD_DIR}/compiler-rt/activate.sh"

wget -q -O - ${rt_source_url} | tar -Jxf - && mv ${rt_directory} compiler-rt && cd compiler-rt
mkdir build && cd build 
cmake .. -G Ninja -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=$TOOLCHAIN_PREFIX                                                  \
  -DCMAKE_AR=${TOOLCHAIN_PREFIX}/bin/gcc-ar -DCMAKE_NM=${TOOLCHAIN_PREFIX}/bin/gcc-nm -DCMAKE_RANLIB=${TOOLCHAIN_PREFIX}/bin/gcc-ranlib
ninja
ninja install

mkdir -p "${TOOLCHAIN_PREFIX}"/lib/clang/${rt_version}/{lib,share}
mv "${TOOLCHAIN_PREFIX}"/lib/{linux,clang/${rt_version}/lib/}
mv "${TOOLCHAIN_PREFIX}"/{share/*.txt,lib/clang/${rt_version}/share/}

source ../../deactivate.sh
