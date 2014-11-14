FROM        centos:centos6
MAINTAINER  robert@hyperdex.org

RUN rpm -Uvh http://mirror.pnl.gov/epel/6/i386/epel-release-6-8.noarch.rpm
RUN yum install --enablerepo=epel -y createrepo mock rpmdevtools python-setuptools zsh
RUN easy_install argparse
RUN easy_install ply
RUN easy_install upack
RUN useradd -m -g mock mock
ADD common.zsh /root/common.zsh
ADD default.cfg /root/default.cfg
ADD build.zsh /root/build.zsh

CMD /root/build.zsh
