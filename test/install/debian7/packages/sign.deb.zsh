#!/bin/zsh

set -e
setopt null_glob

for x in **/Release
do
    gpg --detach-sign --armor "${x}"
    mv "${x}.asc" "${x}.gpg"
done
