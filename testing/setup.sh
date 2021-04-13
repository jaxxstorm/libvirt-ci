#!/usr/bin/env bash
set -x -ef -o pipefail

sudo apt-get update
sudo apt-get install -y lxc libvirt-daemon libvirt-dev libvirt-daemon-driver-lxc libvirt-daemon-system

sudo sed -i 's#unix_sock_group = "libvirt"#unix_sock_group = "docker"#g' /etc/libvirt/libvirtd.conf
sudo systemctl restart libvirtd.service

cat /etc/libvirt/libvirtd.conf

groups $(whoami)

mkdir -p ~/.config/lxc
cat << EOF > ~/.config/lxc/default.conf
lxc.include = /etc/lxc/default.conf
lxc.idmap = u 0 165536 65536
lxc.idmap = g 0 165536 65536
EOF

lxc-create -t download -n foo -- --dist ubuntu --release bionic --arch amd64 --no-validate

virsh -c lxc:// list

