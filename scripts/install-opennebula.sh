#!/bin/bash

set -ve

COMMIT=${1-master}

ONE_HOME=/var/lib/one

cd $ONE_HOME

git clone https://github.com/OpenNebula/one.git  one.git
git clone https://github.com/jmelis/one-tools.git one-tools.git

cd $ONE_HOME/one.git
sed -i "s/\(url = \).*/\1git@git.opennebula.org:one.git/" .git/config
git checkout $COMMIT
scons -j5 mysql=yes
sudo ./install.sh -l -u oneadmin -g oneadmin

#sed -i 's%^.*EMULATOR.*%EMULATOR = /usr/bin/qemu-system-x86_64%' /etc/one/vmm_exec/vmm_exec_kvm.conf

mkdir -p /var/lib/one/.one
echo "oneadmin:-" > /var/lib/one/.one/one_auth

sudo chown -R oneadmin /etc/one
find /etc/one -type f -execdir sed -i "s/127\.0\.0\.1/0.0.0.0/g" '{}' \;

sed -i "s/^#\(.*dummy\)/\1/" /etc/one/oned.conf

one start

cat <<EOF > $ONE_HOME/dummy.yaml
---
- :class: :host
  :name: dummy
  :im: dummy
  :vm: dummy
  :net: dummy

- :class: :image
  :name: test-image
  :type: OS
  :path: /etc/hosts
  :datastore: default

- :class: :net
  :name: private
  :type: fixed
  :bridge: br0
  :dns: 8.8.8.8 8.8.4.4
  :leases:
    - 192.168.101.1
    - 192.168.101.2
    - 192.168.101.3
    - 192.168.101.4
    - 192.168.101.5


- :class: :template
  :name: test
  :cpu: 1
  :memory: 512
  :arch: x86_64
  :disk: test
  :nic: private
  :vnc:
  :ssh:
  :net_context:
EOF

$ONE_HOME/one-tools.git/onebootstrap $ONE_HOME/dummy.yaml
