#!/bin/bash

set -e

tar xzvf ${MINION_ARTIFACT_PREREQS_HYPERDEX_INSTALL_DIR} -C /tmp

cp -R ${MINION_SOURCE_WARP} /tmp
cd /tmp/warp

export PATH=/tmp/install/bin:${PATH}
export PKG_CONFIG_PATH=/tmp/install/lib/pkgconfig

autoreconf -ivf
./configure --prefix=/tmp/install
make -j
make -j distcheck
echo MINION_ARTIFACT_DIST_WARP_TAR_GZ=$(find $(pwd) -iname '*'.tar.gz)
echo MINION_ARTIFACT_DIST_WARP_TAR_BZ2=$(find $(pwd) -iname '*'.tar.bz2)
