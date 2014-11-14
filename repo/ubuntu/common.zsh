#!/bin/zsh

setopt null_glob

function update_deb
{
    DIST=$1
    shift
    RELEASE=$1
    shift
    MINIONNAME=$1
    shift

    # Unpack packages
    rm -rf /tmp/tmp
    mkdir -p /tmp/tmp
    for x in /deps/pkg*${MINIONNAME}/pkgs.tar.gz /deps/*${MINIONNAME}.pkgs.tar.gz
    do
        tar xzvf ${x} -C /tmp/tmp
    done

    # Repo structure
    mkdir -p ${BASE}/conf

    cd ${BASE}
    for x in /tmp/tmp/*.deb
    do
        reprepro includedeb ${RELEASE} ${x}
    done
}
