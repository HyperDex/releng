#!/bin/bash

set -e

cd /tmp
tar xzvf ${MINION_SOURCE_LIBSODIUM_TAR_GZ}
cd libsodium-*

export PATH=/tmp/install/bin:${PATH}
export PKG_CONFIG_PATH=/tmp/install/lib/pkgconfig

./configure --prefix=/tmp/install
make -j
make -j distcheck
make -j install

tar czvf /tmp/install.tar.gz -C /tmp install
echo MINION_ARTIFACT_PREREQS_MACAROONS_INSTALL_DIR=/tmp/install.tar.gz
