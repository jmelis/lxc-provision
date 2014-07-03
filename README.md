LXC Provision
=============

This is a repo useful for myself as an OpenNebula developer. I usually need several OpenNebula versions at the same time and LXC is a good match for this requirements.

This repo performs the following actions:

* Uses lxc-download to create a scratch Centos installation (other OSs will be added in the future)
* Configures the lxc with a name and an IP and other stuff, like adding SSH public key, disabling root password, disable dhcp, etc...
* Ansible playbook to bootstrap an OpenNebula dev environment (installs all required packages, etc)
* Script that downloads and installs an OpenNebula

This repo is quite specific to my personal environment, the idea is to generalize it at some point so other people can use it (hardcoded path to SSH key, etc)
