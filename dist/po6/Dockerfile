FROM        ubuntu:14.04
MAINTAINER  robert@hyperdex.org

RUN sudo apt-get update
RUN sudo apt-get install -y build-essential
RUN sudo apt-get install -y autoconf automake libtool
ADD build.sh /root/build.sh

CMD /root/build.sh
