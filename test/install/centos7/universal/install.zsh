#!/bin/zsh

set -e
setopt null_glob

INSTALL_SCRIPT=doc/install/linux-amd64.sh

mkdir -p /tmp/tarball
cd /tmp/tarball
tar xzvf ${MINION_ARTIFACT_DIST_HYPERDEX_TAR_GZ}
cd *
if test ! -f ${INSTALL_SCRIPT}
then
    echo could not find install script at ${INSTALL_SCRIPT} in the HyperDex tarball
    exit 1
fi

cp ${MINION_ARTIFACT_PKG_LINUX_AMD64_TAR_GZ} .
/bin/sh ${INSTALL_SCRIPT}
