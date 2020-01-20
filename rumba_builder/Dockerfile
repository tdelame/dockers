FROM atom_base:3.3

# grab Xvfb to run graphic applications in a virtual environment + clean
RUN yum -y -q --setopt=tsflags=nodocs install xorg-x11-server-Xvfb \
  && yum -y -q clean all                                           \
  && rm -rf /var/cache                                             \
  && rpm --rebuilddb

# make sure any command in launched in a virtual X environment
ENV DISPLAY=:99.0
ENTRYPOINT ["xvfb-run", "--server-args=\"-screen 0 1024x768x24\""]
