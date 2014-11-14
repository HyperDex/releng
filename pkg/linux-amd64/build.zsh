#!/bin/zsh

set -e

HYPERDEX_ROOT=$(basename ${MINION_ARTIFACT_DIST_HYPERDEX_TAR_GZ} | sed -e 's/.tar.gz//')
OUTPUT=/root/${HYPERDEX_ROOT}-linux-amd64.tar.gz

cd /tmp

export CUSTOM_PREFIX=/usr/local/hyperdex
export CUSTOM_CPPFLAGS="-I${CUSTOM_PREFIX}/include"
export CUSTOM_CFLAGS="-fPIC -fpic -O2"
export CUSTOM_CXXFLAGS="-fPIC -fpic -O2"
export CUSTOM_LDFLAGS="-L${CUSTOM_PREFIX}/lib -fPIC -fpic"
export CUSTOM_PO6_CFLAGS="-I${CUSTOM_PREFIX}/include"
export CUSTOM_PO6_LIBS="-L${CUSTOM_PREFIX}/lib"
export CUSTOM_E_CFLAGS="-I${CUSTOM_PREFIX}/include"
export CUSTOM_E_LIBS="-L${CUSTOM_PREFIX}/lib /usr/local/hyperdex/lib/libe.a"
export CUSTOM_BUSYBEE_CFLAGS="-I${CUSTOM_PREFIX}/include"
export CUSTOM_BUSYBEE_LIBS="-L${CUSTOM_PREFIX}/lib /usr/local/hyperdex/lib/libbusybee.a"
export CUSTOM_HYPERLEVELDB_CFLAGS="-I${CUSTOM_PREFIX}/include"
export CUSTOM_HYPERLEVELDB_LIBS="-L${CUSTOM_PREFIX}/lib /usr/local/hyperdex/lib/libhyperleveldb.a"
export CUSTOM_REPLICANT_CFLAGS="-I${CUSTOM_PREFIX}/include"
export CUSTOM_REPLICANT_LIBS="-L${CUSTOM_PREFIX}/lib /usr/local/hyperdex/lib/libreplicant.a"
export CUSTOM_SODIUM_CFLAGS="-I${CUSTOM_PREFIX}/include"
export CUSTOM_SODIUM_LIBS="-L${CUSTOM_PREFIX}/lib /usr/local/hyperdex/lib/libsodium.a"
export CUSTOM_MACAROONS_CFLAGS="-I${CUSTOM_PREFIX}/include ${CUSTOM_SODIUM_CFLAGS}"
export CUSTOM_MACAROONS_LIBS="-L${CUSTOM_PREFIX}/lib /usr/local/hyperdex/lib/libmacaroons.a ${CUSTOM_SODIUM_LIBS}"
export LIBTOOL_EXTRA_FLAGS="${CUSTOM_LDFLAGS}"

# build po6
cd /tmp
tar xzvf "${MINION_ARTIFACT_DIST_PO6_TAR_GZ}"
cd /tmp/libpo6*
./configure \
    CPPFLAGS="${CUSTOM_CPPFLAGS}" \
    CFLAGS="${CUSTOM_CFLAGS}" \
    CXXFLAGS="${CUSTOM_CXXFLAGS}" \
    LDFLAGS="${CUSTOM_LDFLAGS}" \
    --prefix=${CUSTOM_PREFIX}
make -j
make install

# build e
cd /tmp
tar xzvf "${MINION_ARTIFACT_DIST_E_TAR_GZ}"
cd /tmp/libe*
./configure \
    CPPFLAGS="${CUSTOM_CPPFLAGS}" \
    CFLAGS="${CUSTOM_CFLAGS}" \
    CXXFLAGS="${CUSTOM_CXXFLAGS}" \
    LDFLAGS="${CUSTOM_LDFLAGS}" \
    PO6_CFLAGS="${CUSTOM_PO6_CFLAGS}" \
    PO6_LIBS="${CUSTOM_PO6_LIBS}" \
    --prefix=${CUSTOM_PREFIX}
make -j
make install

# build BusyBee
cd /tmp
tar xzvf "${MINION_ARTIFACT_DIST_BUSYBEE_TAR_GZ}"
cd /tmp/busybee*
./configure \
    CPPFLAGS="${CUSTOM_CPPFLAGS}" \
    CFLAGS="${CUSTOM_CFLAGS}" \
    CXXFLAGS="${CUSTOM_CXXFLAGS}" \
    LDFLAGS="${CUSTOM_LDFLAGS}" \
    PO6_CFLAGS="${CUSTOM_PO6_CFLAGS}" \
    PO6_LIBS="${CUSTOM_PO6_LIBS}" \
    E_CFLAGS="${CUSTOM_E_CFLAGS}" \
    E_LIBS="${CUSTOM_E_LIBS}" \
    --prefix=${CUSTOM_PREFIX}
make -j
make install

# build HyperLevelDB
cd /tmp
tar xzvf "${MINION_ARTIFACT_DIST_LEVELDB_TAR_GZ}"
cd /tmp/hyperleveldb*
./configure \
    CPPFLAGS="${CUSTOM_CPPFLAGS}" \
    CFLAGS="${CUSTOM_CFLAGS}" \
    CXXFLAGS="${CUSTOM_CXXFLAGS}" \
    LDFLAGS="${CUSTOM_LDFLAGS}" \
    --prefix=${CUSTOM_PREFIX}
make -j
make install

# build popt
cd /tmp
tar xzvf "${MINION_SOURCE_POPT_TAR_GZ}"
cd /tmp/popt*
./configure \
    CPPFLAGS="${CUSTOM_CPPFLAGS}" \
    CFLAGS="${CUSTOM_CFLAGS}" \
    CXXFLAGS="${CUSTOM_CXXFLAGS}" \
    LDFLAGS="${CUSTOM_LDFLAGS}" \
    --disable-nls \
    --prefix=${CUSTOM_PREFIX}
make
make install

# build glog
cd /tmp
tar xzvf "${MINION_SOURCE_GLOG_TAR_GZ}"
cd /tmp/glog*
./configure \
    CPPFLAGS="${CUSTOM_CPPFLAGS}" \
    CFLAGS="${CUSTOM_CFLAGS}" \
    CXXFLAGS="${CUSTOM_CXXFLAGS}" \
    LDFLAGS="${CUSTOM_LDFLAGS}" \
    --prefix=${CUSTOM_PREFIX}
make
make install

# build Replicant
cd /tmp
tar xzvf "${MINION_ARTIFACT_DIST_REPLICANT_TAR_GZ}"
cd /tmp/replicant*
./configure \
    CPPFLAGS="${CUSTOM_CPPFLAGS}" \
    CFLAGS="${CUSTOM_CFLAGS}" \
    CXXFLAGS="${CUSTOM_CXXFLAGS}" \
    LDFLAGS="${CUSTOM_LDFLAGS}" \
    PO6_CFLAGS="${CUSTOM_PO6_CFLAGS}" \
    PO6_LIBS="${CUSTOM_PO6_LIBS}" \
    E_CFLAGS="${CUSTOM_E_CFLAGS}" \
    E_LIBS="${CUSTOM_E_LIBS} -lrt" \
    BUSYBEE_CFLAGS="${CUSTOM_BUSYBEE_CFLAGS}" \
    BUSYBEE_LIBS="${CUSTOM_BUSYBEE_LIBS}" \
    HYPERLEVELDB_CFLAGS="${CUSTOM_HYPERLEVELDB_CFLAGS}" \
    HYPERLEVELDB_LIBS="${CUSTOM_HYPERLEVELDB_LIBS}" \
    --prefix=${CUSTOM_PREFIX}
patch Makefile < /root/replicant-makefile.patch
make -j
make install
chrpath -r '$ORIGIN/../lib' "${CUSTOM_PREFIX}"/libexec/replicant*/replicant-daemon

# build sodium
cd /tmp
tar xzvf "${MINION_SOURCE_SODIUM_TAR_GZ}"
cd /tmp/libsodium*
sed -i -e 's/-fPIE/-fPIC/g' configure.ac configure ltmain.sh
./configure --disable-shared \
    CPPFLAGS="${CUSTOM_CPPFLAGS}" \
    CFLAGS="${CUSTOM_CFLAGS}" \
    CXXFLAGS="${CUSTOM_CXXFLAGS}" \
    LDFLAGS="${CUSTOM_LDFLAGS}" \
    --prefix=${CUSTOM_PREFIX}
make
make install

# build macaroons
cd /tmp
tar xzvf "${MINION_ARTIFACT_DIST_MACAROONS_TAR_GZ}"
cd /tmp/libmacaroons*
./configure \
    CPPFLAGS="${CUSTOM_CPPFLAGS}" \
    CFLAGS="${CUSTOM_CFLAGS}" \
    CXXFLAGS="${CUSTOM_CXXFLAGS}" \
    LDFLAGS="${CUSTOM_LDFLAGS}" \
    SODIUM_CFLAGS="${CUSTOM_SODIUM_CFLAGS}" \
    SODIUM_LIBS="${CUSTOM_SODIUM_LIBS}" \
    --prefix=${CUSTOM_PREFIX}
make -j
make install

# build json-c
cd /tmp
tar xzvf "${MINION_SOURCE_JSON_TAR_GZ}"
cd /tmp/json*
./configure \
    CPPFLAGS="${CUSTOM_CPPFLAGS}" \
    CFLAGS="${CUSTOM_CFLAGS}" \
    CXXFLAGS="${CUSTOM_CXXFLAGS}" \
    LDFLAGS="${CUSTOM_LDFLAGS}" \
    --prefix=${CUSTOM_PREFIX}
make
make install

# build HyperDex
cd /tmp
tar xzvf "${MINION_ARTIFACT_DIST_HYPERDEX_TAR_GZ}"
cd /tmp/hyperdex*
./configure \
    CPPFLAGS="${CUSTOM_CPPFLAGS}" \
    CFLAGS="${CUSTOM_CFLAGS}" \
    CXXFLAGS="${CUSTOM_CXXFLAGS}" \
    LDFLAGS="${CUSTOM_LDFLAGS}" \
    PO6_CFLAGS="${CUSTOM_PO6_CFLAGS}" \
    PO6_LIBS="${CUSTOM_PO6_LIBS}" \
    E_CFLAGS="${CUSTOM_E_CFLAGS}" \
    E_LIBS="${CUSTOM_E_LIBS}" \
    BUSYBEE_CFLAGS="${CUSTOM_BUSYBEE_CFLAGS}" \
    BUSYBEE_LIBS="${CUSTOM_BUSYBEE_LIBS}" \
    HYPERLEVELDB_CFLAGS="${CUSTOM_HYPERLEVELDB_CFLAGS}" \
    HYPERLEVELDB_LIBS="${CUSTOM_HYPERLEVELDB_LIBS}" \
    REPLICANT_CFLAGS="${CUSTOM_REPLICANT_CFLAGS}" \
    REPLICANT_LIBS="${CUSTOM_REPLICANT_LIBS}" \
    SODIUM_CFLAGS="${CUSTOM_SODIUM_CFLAGS}" \
    SODIUM_LIBS="${CUSTOM_SODIUM_LIBS}" \
    MACAROONS_CFLAGS="${CUSTOM_MACAROONS_CFLAGS}" \
    MACAROONS_LIBS="${CUSTOM_MACAROONS_LIBS}" \
    --prefix=${CUSTOM_PREFIX}
patch Makefile < /root/hyperdex-makefile.patch
make -j
make install

# cleanup and generate the tarball
rm -r "${CUSTOM_PREFIX}/include"
rm -r "${CUSTOM_PREFIX}/lib/pkgconfig"
rm "${CUSTOM_PREFIX}"/lib/libbusybee.*
rm "${CUSTOM_PREFIX}"/lib/libe.*
rm "${CUSTOM_PREFIX}"/lib/libglog.*
rm "${CUSTOM_PREFIX}"/lib/libhyperdex-admin.*
rm "${CUSTOM_PREFIX}"/lib/libhyperdex-client.*
rm "${CUSTOM_PREFIX}"/lib/libhyperleveldb.*
rm "${CUSTOM_PREFIX}"/lib/libjson*
rm "${CUSTOM_PREFIX}"/lib/libpopt.*
rm "${CUSTOM_PREFIX}"/lib/libreplicant.*
rm "${CUSTOM_PREFIX}"/share/man/man3/popt.3
rm "${CUSTOM_PREFIX}"/libexec/hyperdex-*/libhyperdex-coordinator.a
rm "${CUSTOM_PREFIX}"/libexec/hyperdex-*/libhyperdex-coordinator.la
rmdir "${CUSTOM_PREFIX}"/share/java

tar czvf ${OUTPUT} -C /usr/local hyperdex/

# report

echo "================================================================================"
echo "Report on the various files shipped in the tarball, and what they link"
echo "================================================================================"

find "${CUSTOM_PREFIX}" -print0 \
| xargs -0 ldd 2>/dev/null \
| grep -v 'not a dynamic executable' \
| grep -v 'linux-vdso.so.1 =>' \
| grep -v 'libpthread.so.0 =>' \
| grep -v 'librt.so.1 =>' \
| grep -v 'libstdc++.so.6 =>' \
| grep -v 'libm.so.6 =>' \
| grep -v 'libgcc_s.so.1 =>' \
| grep -v 'libc.so.6 =>' \
| grep -v '/lib64/ld-linux-x86-64.so.2'

echo "================================================================================"
echo "SUCCESS"
echo "The built binaries are available at ${OUTPUT}"
echo "================================================================================"
echo MINION_ARTIFACT_PKG_LINUX_AMD64_TAR_GZ=${OUTPUT}
