FROM centos:7

# grab basic tools and clean yum afterward
RUN yum -y -q --setopt=tsflags=nodocs install tar wget bzip2 make git gcc gcc-c++ which patch libffi-devel m4 \
  && yum -y -q clean all                                                                                      \
  && rm -rf /var/cache/yum

# variables to setup the build of the image
ARG TOOLCHAIN_PREFIX=/usr/local
ARG TOOLCHAIN_BUILD_DIR=/building_tmp
ARG TOOLCHAIN_BUILD_THREADS=24

# setup a default python 3
COPY python.sh ${TOOLCHAIN_BUILD_DIR}/scripts/
RUN ${TOOLCHAIN_BUILD_DIR}/scripts/python.sh

# install a modern gcc (9.2)
COPY gcc.sh ${TOOLCHAIN_BUILD_DIR}/scripts/
RUN ${TOOLCHAIN_BUILD_DIR}/scripts/gcc.sh

# install conan (used by llvm to fetch cmake and ninja)
COPY conan.sh ${TOOLCHAIN_BUILD_DIR}/scripts/
RUN ${TOOLCHAIN_BUILD_DIR}/scripts/conan.sh

# install a modern llvm
COPY llvm.sh ${TOOLCHAIN_BUILD_DIR}/scripts/
RUN ${TOOLCHAIN_BUILD_DIR}/scripts/llvm.sh

# install a modern clang
COPY clang.sh clang.patch ${TOOLCHAIN_BUILD_DIR}/scripts/
RUN ${TOOLCHAIN_BUILD_DIR}/scripts/clang.sh

# install a modern linker: ldd
COPY lld.sh ${TOOLCHAIN_BUILD_DIR}/scripts/
RUN ${TOOLCHAIN_BUILD_DIR}/scripts/lld.sh

# install clang compiler runtime
COPY compiler-rt.sh ${TOOLCHAIN_BUILD_DIR}/scripts/
RUN ${TOOLCHAIN_BUILD_DIR}/scripts/compiler-rt.sh

# default conan setup
RUN printf "[settings]\nos=Linux\nos_build=Linux\narch=x86_64\narch_build=x86_64\ncompiler=clang\ncompiler.version=9\ncompiler.libcxx=libstdc++11\nbuild_type=Release\n[env]\nCC=${TOOLCHAIN_PREFIX}/bin/clang\nCXX=${TOOLCHAIN_PREFIX}/bin/clang++\nLD_LIBRARY_PATH=[${TOOLCHAIN_PREFIX}/lib64]\nCONAN_CMAKE_GENERATOR=Ninja" > ~/.conan/profiles/default

# remove unneeded tools and dirs
RUN yum autoremove -y -q gcc gcc-c++                                        \
  && yum install -y -q --setopt=tsflags=nodocs glibc-devel mesa-libGL-devel \
  && yum -y -q clean all                                                    \
  && rm -rf ${TOOLCHAIN_BUILD_DIR}                                          \
  && rm -rf /root/.cache                                                    \
  && rm -rf /root/.conan/data                                               \
  && rm -rf /var/gopher                                                     \
  && rm -rf /var/games                                                      \
  && rm -rf /var/cache                                                      \
  && rpm --rebuilddb                                                        

# setting up environment variables
ENV LD_LIBRARY_PATH ${TOOLCHAIN_PREFIX}/lib64:${TOOLCHAIN_PREFIX}/lib
ENV CC ${TOOLCHAIN_PREFIX}/bin/clang
ENV CXX ${TOOLCHAIN_PREFIX}/bin/clang++
