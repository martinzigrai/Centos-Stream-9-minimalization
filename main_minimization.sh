#!/bin/bash

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
