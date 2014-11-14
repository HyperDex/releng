FROM        fedora:20
MAINTAINER  robert@hyperdex.org

RUN yum install -y createrepo mock rpmdevtools python-setuptools zsh
RUN easy_install argparse
RUN easy_install ply
RUN easy_install upack
RUN useradd -m -g mock mock
ADD common.zsh /root/common.zsh
ADD default.cfg /root/default.cfg
ADD build.zsh /root/build.zsh

CMD /root/build.zsh
