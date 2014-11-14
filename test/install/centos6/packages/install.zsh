#!/bin/zsh

set -e

export REPO=${MINION_ARTIFACT_REPO_CENTOS_TAR_GZ}
export DIST=centos
export INSTALL_SCRIPT=doc/install/centos-packages.sh
/bin/zsh /root/common.zsh
yum remove -y '*hyperdex*'
yum install -y hyperdex-warp
