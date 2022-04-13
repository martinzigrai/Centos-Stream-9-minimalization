#!/bin/bash

#zmazanie logovacích súborov, súborov medzipamäti a obnovenie databáze rpm
find /var/log -name "*.log*" -delete
rm -rfv /var/cache/*
rpm --rebuilddb

#zmazanie manuálových stránok, informácií a dokumentácie k programom
rm -rfv /user/share/doc/
rm -rfv /user/share/man/
rm -rfv /usr/share/info/

#rozparsovanie výstupu príkazu locale
system_lang=`locale | cut -f2 -d= | cut -f1 -d. | head -n 1`

#odstránenie nepoužitých lokalizácií
for target in `find /usr/share/locale -maxdepth 1 -not -name $system_lang*`; do
	rm -fv $target/LC_MESSAGES/*
done

#vytvorenie funkcie remove
function remove {
	for target in "$@"; do
		rm -fv $target
	done
}

DIR1=$HOME/all_modules.txt
DIR2=$HOME/current_modules.txt

#hladanie dostupných modulov jadra
find /lib/modules/$(uname -r) -type f -name `*.ko*` > $DIR1

#hladanie cesty k modulom jadra
for module in `lsmod | cut -f1 -d" " | tail -n +2`; do
	filename=`modinfo $module -n`
	echo "$filename" >> $DIR2
done

sort $DIR1 | uniq > file1.sorted
sort $DIR2 | uniq > file2.sorted

#odstránenie nepoužitých modulov pomocou funkcie remove
remove `comm -23 file1.sorted file2.sorted`

#odstránenie nepoužívaného firmware
remove `find /usr/lib/firmware -atime +2`
