FROM        ubuntu:14.04
MAINTAINER  robert@hyperdex.org

RUN sudo apt-get update
rUN sudo apt-get install -y build-essential
RUN sudo apt-get install -y autoconf automake libtool
RUN sudo apt-get install -y pkg-config
RUN sudo apt-get install -y cython
RUN sudo apt-get install -y libpopt-dev libgoogle-glog-dev
ADD build.sh /root/build.sh

CMD /root/build.sh
