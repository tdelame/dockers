#!/usr/bin/env bash
#^^^ GCC documentation discourage the use of /bin/sh

# setup
set -x
set -e

# zstd
mkdir -p "${TOOLCHAIN_BUILD_DIR}/gcc" && cd "${TOOLCHAIN_BUILD_DIR}/gcc"
wget -q -O - "http://codeload.github.com/facebook/zstd/tar.gz/v1.4.1" | tar zxf -
cd zstd-1.4.1 && make -j${TOOLCHAIN_BUILD_THREADS} && make install

# gcc
cd "${TOOLCHAIN_BUILD_DIR}/gcc"
wget -q -O - "https://ftp.gnu.org/gnu/gcc/gcc-9.2.0/gcc-9.2.0.tar.gz" | tar zxf -
cd gcc-9.2.0 && ./contrib/download_prerequisites && mkdir build && cd build
CC='gcc' CFLAGS='-m64 -O3' ../configure                                          \
    --build=x86_64-linux-gnu --host=x86_64-linux-gnu --target=x86_64-linux-gnu   \
    --prefix=${TOOLCHAIN_PREFIX} --enable-lto --enable-languages=c,c++           \
    --disable-multilib --disable-checking --enable-gcov
make -j${TOOLCHAIN_BUILD_THREADS}
make install

# clean
rm -rf "${TOOLCHAIN_BUILD_DIR}/gcc"
