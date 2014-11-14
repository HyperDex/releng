#!/bin/zsh

set -e
setopt null_glob

mkdir -p /tmp/repo
cd /tmp/repo
tar xzvf ${REPO}
cd ${DIST}
/root/sign.zsh
cp /root/pub.asc ./hyperdex.gpg.key
python2 -m SimpleHTTPServer &> /dev/null &|

mkdir -p /tmp/tarball
cd /tmp/tarball
tar xzvf ${MINION_ARTIFACT_DIST_HYPERDEX_TAR_GZ}
cd *
if test ! -f ${INSTALL_SCRIPT}
then
    echo could not find install script at ${INSTALL_SCRIPT} in the HyperDex tarball
    exit 1
fi

sed -i -e "s/${DIST}.hyperdex.org/localhost:8000/g" ${INSTALL_SCRIPT}
sleep 1
/bin/sh ${INSTALL_SCRIPT}
