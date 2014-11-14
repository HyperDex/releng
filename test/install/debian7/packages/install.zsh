#!/bin/zsh

set -e

export REPO=${MINION_ARTIFACT_REPO_DEBIAN_TAR_GZ}
export DIST=debian
export INSTALL_SCRIPT=doc/install/debian7-packages.sh
/bin/zsh /root/common.zsh
apt-get install -y hyperdex-warp
