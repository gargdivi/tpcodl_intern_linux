#!/bin/bash

# sudo apt udate 
# sudo apt install qemu-kvm libvirt-daemon-system virtinst bridge-utils -y
# kvm-ok

read -p "enter the VM name : " vm_name 
read -p "Ram to allocate (MB) :" ram
read -p " number of cpu's :" cpus
read -p "size of disk (GB) :" disk_size
read -p "path to OS ISO : " iso_path

# disk image 
disk_path= "var/lib/libvirt/images/${vm_name}.qcow2"
qemu-img create -f qcow2 "$disk_path" "${disk_size}G"

sudo virt-install \
	--name "$vm_name" \
	--ram "$ram" \
	--vcpus "$cpus" \
	--disk path="$disk_path",format=qcow2 \
	--os-type linux \
	--os-variant ubuntu20.04 \
	--cdrom "$iso_path" \
	--network network=defalut \
	--graphic none \
	--console pty,traget_type=serial \
	--noautoconsle


