#!/bin/zsh

set -e

mkdir -p /etc/pbuilder/hook.d
cat > /etc/pbuilder/hook.d/D05deps << EOF
#!/bin/sh
apt-get update
EOF
chmod a+x /etc/pbuilder/hook.d/D05deps
pbuilder create --distribution wheezy 
