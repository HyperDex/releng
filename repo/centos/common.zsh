#!/bin/zsh

setopt null_glob

function update_rpm
{
    DIST=$1
    shift
    RELEASE=$1
    shift

    # Unpack packages
    rm -rf /tmp/tmp
    mkdir -p /tmp/tmp
    for x in /deps/pkg*${DIST}${RELEASE}/pkgs.tar.gz /deps/*${DIST}${RELEASE}.pkgs.tar.gz
    do
        tar xzvf ${x} -C /tmp/tmp
    done

    # Remove Warp source and debug
    find /tmp/tmp -iname '*warp*src*rpm' -delete
    find /tmp/tmp -iname '*warp*debuginfo*rpm' -delete

    # Repo structure
    mkdir -p ${BASE}/${DIST}/src/x86_64/${RELEASE}
    mkdir -p ${BASE}/${DIST}/debug/x86_64/${RELEASE}
    mkdir -p ${BASE}/${DIST}/base/x86_64/${RELEASE}

    # Populate packages
    mv /tmp/tmp/*.src.rpm ${BASE}/${DIST}/src/x86_64/${RELEASE}
    mv /tmp/tmp/*debuginfo*.rpm ${BASE}/${DIST}/debug/x86_64/${RELEASE}
    mv /tmp/tmp/*.rpm ${BASE}/${DIST}/base/x86_64/${RELEASE}

    # create the repo
    createrepo -d ${BASE}/${DIST}/src/x86_64/${RELEASE}
    createrepo -d ${BASE}/${DIST}/debug/x86_64/${RELEASE}
    createrepo -d ${BASE}/${DIST}/base/x86_64/${RELEASE}
}
