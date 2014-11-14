FROM        ubuntu:14.04
MAINTAINER  robert@hyperdex.org

RUN sudo apt-get update
RUN sudo apt-get install -y build-essential
RUN sudo apt-get install -y autoconf automake libtool
RUN sudo apt-get install -y pkg-config
RUN sudo apt-get install -y libpopt-dev libgoogle-glog-dev
RUN sudo apt-get install -y autoconf-archive libjson-c-dev
RUN sudo apt-get install -y gperf flex bison cython
RUN sudo apt-get install -y pandoc help2man
RUN sudo apt-get install -y python-dev
RUN sudo apt-get install -y ruby-dev
RUN sudo apt-get install -y default-jdk
ADD build.sh /root/build.sh

CMD /root/build.sh
