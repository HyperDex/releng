#!/bin/zsh

set -e

PO6_BASE=$(basename $(echo ${MINION_ARTIFACT_DIST_PO6_TAR_GZ} | sed -e 's/.tar.gz//')).upack
cp /deps/releng/pkg/${PO6_BASE} /tmp
echo MINION_ARTIFACT_UPACK_FILES_PO6_UPACK=/tmp/${PO6_BASE}

E_BASE=$(basename $(echo ${MINION_ARTIFACT_DIST_E_TAR_GZ} | sed -e 's/.tar.gz//')).upack
cp /deps/releng/pkg/${E_BASE} /tmp
echo MINION_ARTIFACT_UPACK_FILES_E_UPACK=/tmp/${E_BASE}

BUSYBEE_BASE=$(basename $(echo ${MINION_ARTIFACT_DIST_BUSYBEE_TAR_GZ} | sed -e 's/.tar.gz//')).upack
cp /deps/releng/pkg/${BUSYBEE_BASE} /tmp
echo MINION_ARTIFACT_UPACK_FILES_BUSYBEE_UPACK=/tmp/${BUSYBEE_BASE}

LEVELDB_BASE=$(basename $(echo ${MINION_ARTIFACT_DIST_LEVELDB_TAR_GZ} | sed -e 's/.tar.gz//')).upack
cp /deps/releng/pkg/${LEVELDB_BASE} /tmp
echo MINION_ARTIFACT_UPACK_FILES_LEVELDB_UPACK=/tmp/${LEVELDB_BASE}

REPLICANT_BASE=$(basename $(echo ${MINION_ARTIFACT_DIST_REPLICANT_TAR_GZ} | sed -e 's/.tar.gz//')).upack
cp /deps/releng/pkg/${REPLICANT_BASE} /tmp
echo MINION_ARTIFACT_UPACK_FILES_REPLICANT_UPACK=/tmp/${REPLICANT_BASE}

MACAROONS_BASE=$(basename $(echo ${MINION_ARTIFACT_DIST_MACAROONS_TAR_GZ} | sed -e 's/.tar.gz//')).upack
cp /deps/releng/pkg/${MACAROONS_BASE} /tmp
echo MINION_ARTIFACT_UPACK_FILES_MACAROONS_UPACK=/tmp/${MACAROONS_BASE}

HYPERDEX_BASE=$(basename $(echo ${MINION_ARTIFACT_DIST_HYPERDEX_TAR_GZ} | sed -e 's/.tar.gz//')).upack
cp /deps/releng/pkg/${HYPERDEX_BASE} /tmp
echo MINION_ARTIFACT_UPACK_FILES_HYPERDEX_UPACK=/tmp/${HYPERDEX_BASE}

WARP_BASE=$(basename $(echo ${MINION_ARTIFACT_DIST_WARP_TAR_GZ} | sed -e 's/.tar.gz//')).upack
cp /deps/releng/pkg/${WARP_BASE} /tmp
echo MINION_ARTIFACT_UPACK_FILES_WARP_UPACK=/tmp/${WARP_BASE}
