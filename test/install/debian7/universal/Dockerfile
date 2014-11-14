FROM        debian:wheezy
MAINTAINER  robert@hyperdex.org

RUN apt-get update
RUN apt-get install -y tar zsh
ADD install.zsh /root/install.zsh

CMD /root/install.zsh
