#!/bin/zsh

set -e

export REPO=${MINION_ARTIFACT_REPO_FEDORA_TAR_GZ}
export DIST=fedora
export INSTALL_SCRIPT=doc/install/fedora-packages.sh
/bin/zsh /root/common.zsh
yum remove -y '*hyperdex*'
yum install -y hyperdex-warp
