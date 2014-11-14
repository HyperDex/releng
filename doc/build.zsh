#!/bin/sh

set -e

mkdir /tmp/doc
cd /tmp/doc
tar xzvf ${MINION_ARTIFACT_DIST_HYPERDEX_TAR_GZ}
cd hyperdex-*/doc
make
HYPERDEX_ROOT=$(basename ${MINION_ARTIFACT_DIST_HYPERDEX_TAR_GZ} | sed -e 's/.tar.gz//')

mv hyperdex.pdf ${HYPERDEX_ROOT}.pdf
echo MINION_ARTIFACT_DOC_PDF=`pwd`/${HYPERDEX_ROOT}.pdf

python /root/html.py
mv html ${HYPERDEX_ROOT}-html
tar czvf ${HYPERDEX_ROOT}-html.tar.gz ${HYPERDEX_ROOT}-html
echo MINION_ARTIFACT_DOC_HTML=`pwd`/${HYPERDEX_ROOT}-html.tar.gz
