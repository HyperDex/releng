FROM        ubuntu:14.04
MAINTAINER  robert@hyperdex.org

RUN apt-get update
RUN apt-get install -y reprepro zsh

ADD override.precise /tmp/ubuntu/conf/override.precise
ADD override.trusty /tmp/ubuntu/conf/override.trusty
ADD distributions /tmp/ubuntu/conf/distributions
ADD options /tmp/ubuntu/conf/options

ADD common.zsh /root/common.zsh
ADD build.zsh /root/build.zsh

CMD /root/build.zsh
