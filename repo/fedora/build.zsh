#!/bin/zsh

set -e

BASE=/tmp/fedora

. /root/common.zsh

update_rpm fedora 20

tar czvf /tmp/fedora.tar.gz -C /tmp/fedora fedora
echo MINION_ARTIFACT_REPO_FEDORA_TAR_GZ=/tmp/fedora.tar.gz
