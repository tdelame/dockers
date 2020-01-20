#!/usr/bin/env sh
# setup
set -x
set -e

# install
yum -y -q --setopt=tsflags=nodocs install https://centos7.iuscommunity.org/ius-release.rpm
yum -y -q --setopt=tsflags=nodocs install python36u python36u-libs

# config: use python3 instead of python2 by default and fix yum
alternatives --install /usr/bin/python python /usr/bin/python2 50
alternatives --install /usr/bin/python python /usr/bin/python3.6 60
alternatives --set python /usr/bin/python3.6
sed -i 's/#!\/usr\/bin\/python/#!\/usr\/bin\/python2/' /usr/bin/yum
sed -i 's/#! \/usr\/bin\/python/#!\/usr\/bin\/python2/' /usr/libexec/urlgrabber-ext-down

# clean
yum -y -q clean all && rm -rf /var/cache/yum
