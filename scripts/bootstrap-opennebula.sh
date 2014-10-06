#!/bin/bash

set -ve

COMMIT=${1-master}

ONE_HOME=/var/lib/one

cd $ONE_HOME

git clone https://github.com/jmelis/one-tools.git one-tools.git

mkdir -p /var/lib/one/.one
echo "oneadmin:-" > /var/lib/one/.one/one_auth

sudo chown -R oneadmin /etc/one
find /etc/one -type f -execdir sed -i "s/127\.0\.0\.1/0.0.0.0/g" '{}' \;

sed -i "s/^#\(.*dummy\)/\1/" /etc/one/oned.conf

one start

cat <<EOF > $ONE_HOME/kvm.yaml
---
- :class: :host
  :name: localhost
  :im: kvm
  :vm: kvm
  :net: dummy

- :class: :image
  :name: ttylinux
  :type: OS
  :path: http://appliances.c12g.com/ttylinux/ttylinux.img
  :datastore: default

- :class: :net
  :name: private
  :bridge: br0
  :dns: 8.8.8.8 8.8.4.4
  :ar:
    - :ip: 192.168.101.10
      :size: 10
      :type: IP4

- :class: :template
  :name: ttylinux
  :cpu: 0.01
  :memory: 64
  :arch: x86_64
  :disk: ttylinux
  :nic: private
  :vnc:
  :ssh:
  :net_context:
EOF

$ONE_HOME/one-tools.git/onebootstrap $ONE_HOME/kvm.yaml
