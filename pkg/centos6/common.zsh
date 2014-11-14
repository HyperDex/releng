#!/bin/zsh

set -e

WORKDIR=/tmp/upack
ARCHIVE=${WORKDIR}/archive
OUTPUT=${WORKDIR}/output

# Prepare the archive of dependencies
mkdir -p ${ARCHIVE}
if test -n  "$(find /deps/ -maxdepth 2 -name '*pkgs.tar.gz' -print -quit)"
then
    for x in /deps/**/*pkgs.tar.gz
    do
        tar xzvf ${x} -C ${ARCHIVE}
    done
fi
createrepo ${ARCHIVE}

# Run upack
mkdir -p ${OUTPUT}
chown mock:mock ${OUTPUT}
cd ${WORKDIR}
upack -t fedora -t rpm -t centos6 -t centos-6 rpm /deps/*.upack

# Make srpm
mkdir SOURCES
cp /deps/*.tar.gz SOURCES
rpmbuild --define='%_topdir .' -bs *.spec

# Run mock
cp /etc/mock/* .
cp /root/default.cfg .
sed -i -e s,XXXBASEURLXXX,${ARCHIVE}, default.cfg
su -c "/usr/bin/mock -r default --resultdir=${OUTPUT} --configdir=${WORKDIR} ${WORKDIR}/SRPMS/*.src.rpm" mock

# Copy results
chown -R root:root ${OUTPUT}
tar czvf /tmp/pkgs.tar.gz -C ${OUTPUT} .

# Echo the Artifact
echo ${ARTIFACT_NAME}=/tmp/pkgs.tar.gz
