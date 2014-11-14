#!/bin/zsh

set -e

WORKDIR=/tmp/upack
ARCHIVE=${WORKDIR}/archive

# Prepare the archive of dependencies
mkdir -p ${ARCHIVE}
if test -n  "$(find /deps/ -maxdepth 2 -name '*pkgs.tar.gz' -print -quit)"
then
    for x in /deps/**/*pkgs.tar.gz
    do
        tar xzvf ${x} -C ${ARCHIVE}
    done
fi
cd ${ARCHIVE}
apt-ftparchive packages . > Packages

# Run upack
cd ${WORKDIR}
upack -t debian -t deb -t precise -p dist=+precise1 deb /deps/*.upack

# Make debs
cp ${TARBALL} .
make -f Makefile.deb.*
cd */*/
sudo pdebuild --buildresult .. --debbuildopts '-us -uc -b' -- \
    --components "main universe multiverse restricted" \
    --othermirror "deb [trusted=yes] file://${ARCHIVE} /" \
    --bindmounts "${ARCHIVE}" \
    --hookdir /etc/pbuilder/hook.d \
    --override-config --distribution precise
TODEL=`pwd`
cd ..
rm -rf ${TODEL}
chmod a+rw *
chown -R root:root *

# Copy results
tar czvf /tmp/pkgs.tar.gz *

# Echo the Artifact
echo ${ARTIFACT_NAME}=/tmp/pkgs.tar.gz
