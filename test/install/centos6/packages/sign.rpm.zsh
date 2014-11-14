#!/bin/zsh

set -e
setopt null_glob

for x in **/*.rpm
do
    rpm --addsign -D "%_gpg_name HyperDex Automatic Testing Key" "${x}"
done
for x in **/repomd.xml
do
    createrepo -d "$(dirname $(dirname ${x}))"
    gpg --detach-sign --armor "${x}"
done
