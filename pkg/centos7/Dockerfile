FROM        centos:centos7
MAINTAINER  robert@hyperdex.org

RUN rpm -Uvh http://mirror.symnds.com/distributions/fedora-epel/7/x86_64/e/epel-release-7-2.noarch.rpm
RUN yum install --enablerepo=epel -y createrepo mock rpmdevtools python-setuptools zsh
RUN easy_install argparse
RUN easy_install ply
RUN easy_install upack
RUN useradd -m -g mock mock
ADD common.zsh /root/common.zsh
ADD default.cfg /root/default.cfg
ADD build.zsh /root/build.zsh

CMD /root/build.zsh
