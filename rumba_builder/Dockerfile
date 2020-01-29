FROM atom_base:3.3
LABEL maintainer="tdelame@gmail.com"
ENV CONAN_USER_HOME=/builder

# 1. install the requirements to launch Qt for tests
# 2. clean everything
# 3. setup a conan installation every user can use
RUN yum -y -q --setopt=tsflags=nodocs install xorg-x11-server-Xvfb fontconfig-devel libxkbcommon-x11   \
  && yum -y -q clean all && rm -rf /var/cache && rpm --rebuilddb                                       \
  && rm -rf /root/.conan                                                                               \
  && mkdir -p /builder/.conan/profiles                                                                 \
  && conan remote add conan_packages "https://api.bintray.com/conan/tdelame/conan_packages" --insert 0 \
  && printf "[settings]\nos=Linux\nos_build=Linux\narch=x86_64\narch_build=x86_64\ncompiler=clang\ncompiler.version=9\ncompiler.libcxx=libstdc++11\nbuild_type=Release\n" > /builder/.conan/profiles/default \
  && chmod 777 -R /builder    

ENTRYPOINT ["/usr/bin/xvfb-run", "-e", "/dev/stdout", "--server-args='1280x1024x24'"]
