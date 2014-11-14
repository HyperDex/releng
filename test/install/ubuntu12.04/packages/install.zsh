#!/bin/zsh

set -e

export REPO=${MINION_ARTIFACT_REPO_UBUNTU_TAR_GZ}
export DIST=ubuntu
export INSTALL_SCRIPT=doc/install/ubuntu12.04-packages.sh
/bin/zsh /root/common.zsh
apt-get install -y hyperdex-warp
