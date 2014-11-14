FROM        fedora:20
MAINTAINER  robert@hyperdex.org

RUN yum install -y createrepo gnupg rpm-sign tar zsh
ADD pub.asc /root/pub.asc
ADD priv.asc /root/priv.asc
RUN gpg --import /root/pub.asc
RUN gpg --import --allow-secret-key-import /root/priv.asc
ADD common.zsh /root/common.zsh
ADD sign.rpm.zsh /root/sign.zsh
ADD install.zsh /root/install.zsh

CMD /root/install.zsh
