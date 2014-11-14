#!/bin/bash

set -e

tar xzvf ${MINION_ARTIFACT_PREREQS_REPLICANT_INSTALL_DIR} -C /tmp

export PATH=/tmp/install/bin:${PATH}
export PKG_CONFIG_PATH=/tmp/install/lib/pkgconfig
export PYTHON=/usr/bin/python2
export PYTHONPATH=/tmp/install/lib/python2.7/site-packages:${PYTHONPATH}

# install replicant
cd /tmp
tar xzvf ${MINION_ARTIFACT_DIST_REPLICANT_TAR_GZ}
cd replicant-*

./configure --prefix=/tmp/install
make -j
make -j distcheck
make -j install

# install libsodium
cd /tmp
tar xzvf ${MINION_SOURCE_LIBSODIUM_TAR_GZ}
cd libsodium-*

./configure --prefix=/tmp/install
make -j
make -j distcheck
make -j install

# install libmacaroons
cd /tmp
tar xzvf ${MINION_ARTIFACT_DIST_MACAROONS_TAR_GZ}
cd libmacaroons-*

./configure --prefix=/tmp/install --enable-python-bindings PYTHON=/usr/bin/python2
make -j
make -j distcheck
make -j install

# build tarball
tar czvf /tmp/install.tar.gz -C /tmp install
echo MINION_ARTIFACT_PREREQS_HYPERDEX_INSTALL_DIR=/tmp/install.tar.gz
