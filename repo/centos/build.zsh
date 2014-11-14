#!/bin/zsh

set -e

BASE=/tmp/centos

. /root/common.zsh

update_rpm centos 6
update_rpm centos 7

tar czvf /tmp/centos.tar.gz -C /tmp/centos centos
echo MINION_ARTIFACT_REPO_CENTOS_TAR_GZ=/tmp/centos.tar.gz
