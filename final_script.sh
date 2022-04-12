#!/bin/bash
dnf config-manager --set-enabled crb
dnf install epel-release epel-next-releas
cat << EOT > /etc/yum.repos.d/fedora.repo
[fedora]
name=Fedora 34 - x86_64
metalink=https://mirrors.fedoraproject.org/metalink?repo=fedora-34&arch=x86_64
enabled=1
gpgcheck=0
type=rpm
EOT
dnf -y install arora xorg-x11-server-Xorg xinit mupdf twm
echo "xterm & exec twn" > .xinitrc
yum -y autoremove python less openssh
find /var/log -name "*.log*" -delete
rm -rfv /var/cache/*
rpm --rebuilddb

rm -rfv /user/share/doc/
rm -rfv /user/share/man/
rm -rfv /usr/share/info/

system_lang=`locale | cut -f2 -d= | cut -f1 -d. | head -n 1`

for target in `find /usr/share/locale -maxdepth 1 -not -name $system_lang*`; do
	rm -fv $target/LC_MESSAGES/*
done

function remove {
	for target in "$@"; do
		rm -fv $target
	done
}

DIR1=$HOME/all_modules.txt
DIR2=$HOME/current_modules.txt

find /lib/modules/$(uname -r) -type f -name `*.ko*` > $DIR1

for module in `lsmod | cut -f1 -d" " | tail -n +2`; do
	filename=`modinfo $module -n`
	echo "$filename" >> $DIR2
done

sort $DIR1 | uniq > file1.sorted
sort $DIR2 | uniq > file2.sorted

remove `comm -23 file1.sorted file2.sorted`

remove `find /usr/lib/firmware -atime +2`
echo "NetworkManager" > /etc/dnf/protected.d/NetworkManager.conf

for line in 'rpm –queryformat "%{NAME}\n"'; do 
    echo "What require package ${line}:"
        mapfile -t output < <(dnf repoquery –installed –queryformat \
        "%{name}" –whatrequires $line) 
    echo "${output[@]}"

    if [ ${#output[@]} -eq 0 ] 
    then
        echo "Remove package ${line}"
        dnf -y remove $line
    elif [ ${#output[@]} -eq 1 ]
    then
        if [ "${output[0]}" == "$line" ]
        then
            36
            echo "Remove package ${line}"
            dnf -y remove $line
        fi 
    fi
done
