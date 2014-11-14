#!/bin/bash

set -e

tar xzvf ${MINION_ARTIFACT_PREREQS_HYPERDEX_INSTALL_DIR} -C /tmp

cp -R ${MINION_SOURCE_HYPERDEX} /tmp
cd /tmp/hyperdex

export PATH=/tmp/install/bin:${PATH}
export PKG_CONFIG_PATH=/tmp/install/lib/pkgconfig
export PYTHON=/usr/bin/python2
export PYTHONPATH=/tmp/install/lib/python2.7/site-packages

autoreconf -ivf
./configure --prefix=/tmp/install
make -j
make -j distcheck
echo MINION_ARTIFACT_DIST_HYPERDEX_TAR_GZ=$(find $(pwd) -iname '*'.tar.gz)
echo MINION_ARTIFACT_DIST_HYPERDEX_TAR_BZ2=$(find $(pwd) -iname '*'.tar.bz2)
