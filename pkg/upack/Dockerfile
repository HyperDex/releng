FROM        ubuntu:14.04
MAINTAINER  robert@hyperdex.org

RUN sudo apt-get update
RUN sudo apt-get install -y python python-setuptools python-ply zsh
RUN sudo easy_install-2.7 --upgrade upack
ADD build.sh /root/build.sh

CMD /root/build.sh
