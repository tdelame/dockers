#!/usr/bin/env sh
# setup
set -x
set -e

mkdir -p "${TOOLCHAIN_BUILD_DIR}/conan" && cd "${TOOLCHAIN_BUILD_DIR}/conan"
wget -q -O - "https://bootstrap.pypa.io/get-pip.py" > get-pip.py
python get-pip.py
python -m pip install --upgrade setuptools
pip install conan

mkdir -p ~/.conan/profiles
conan remote add conan_packages "https://api.bintray.com/conan/tdelame/conan_packages" --insert 0
rm -rf "${TOOLCHAIN_BUILD_DIR}/conan"
