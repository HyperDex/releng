#!/bin/zsh

set -e

BASE=/tmp/ubuntu

. /root/common.zsh

update_deb ubuntu precise ubuntu12.04
update_deb ubuntu trusty ubuntu14.04

rm -rf /tmp/ubuntu/conf
rm -rf /tmp/ubuntu/db
rm -rf /tmp/ubuntu/incoming

tar czvf /tmp/ubuntu.tar.gz -C /tmp ubuntu
echo MINION_ARTIFACT_REPO_UBUNTU_TAR_GZ=/tmp/ubuntu.tar.gz
