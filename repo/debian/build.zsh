#!/bin/zsh

set -e

BASE=/tmp/debian

. /root/common.zsh

update_deb debian wheezy debian7

rm -rf /tmp/debian/conf
rm -rf /tmp/debian/db
rm -rf /tmp/debian/incoming

tar czvf /tmp/debian.tar.gz -C /tmp debian
echo MINION_ARTIFACT_REPO_DEBIAN_TAR_GZ=/tmp/debian.tar.gz
