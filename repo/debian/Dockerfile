FROM        debian:wheezy
MAINTAINER  robert@hyperdex.org

RUN apt-get update
RUN apt-get install -y reprepro zsh

ADD override.wheezy /tmp/debian/conf/override.wheezy
ADD distributions /tmp/debian/conf/distributions
ADD options /tmp/debian/conf/options

ADD common.zsh /root/common.zsh
ADD build.zsh /root/build.zsh

CMD /root/build.zsh
