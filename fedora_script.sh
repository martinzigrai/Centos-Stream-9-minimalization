#!/usr/bin/bash
cat << EOT > /etc/yum.repos.d/fedora.repo
[fedora]
name=Fedora 34 - x86_64
metalink=https://mirrors.fedoraproject.org/metalink?repo=fedora-34&arch=x86_64
enabled=1
gpgcheck=0
type=rpm
EOT

