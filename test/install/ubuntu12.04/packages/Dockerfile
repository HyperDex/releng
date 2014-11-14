FROM        ubuntu:12.04
MAINTAINER  robert@hyperdex.org

RUN apt-get update
RUN apt-get install -y python wget zsh
ADD pub.asc /root/pub.asc
ADD priv.asc /root/priv.asc
RUN gpg --import /root/pub.asc
RUN gpg --import --allow-secret-key-import /root/priv.asc
ADD common.zsh /root/common.zsh
ADD sign.deb.zsh /root/sign.zsh
ADD install.zsh /root/install.zsh

CMD /root/install.zsh
