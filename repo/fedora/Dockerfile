FROM        fedora:20
MAINTAINER  robert@hyperdex.org

RUN yum install -y createrepo rpmdevtools zsh
ADD common.zsh /root/common.zsh
ADD build.zsh /root/build.zsh

CMD /root/build.zsh
