FROM        ubuntu:12.04
MAINTAINER  robert@hyperdex.org

RUN apt-get update
RUN apt-get install -y apt-utils build-essential debhelper pbuilder python-setuptools zsh
RUN easy_install argparse
RUN easy_install ply
RUN easy_install upack
ADD common.zsh /root/common.zsh
ADD build.zsh /root/build.zsh

CMD /root/build.zsh
