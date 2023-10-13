#!/bin/bash

# langs=("tr" "pt" "de")
langs=("pt_BR")

if ! command -v xgettext &> /dev/null
then
	echo "xgettext could not be found."
	echo "you can install the package with 'apt install gettext' command on debian."
	exit
fi


echo "updating pot file"
xgettext -o po/mauna-update.pot --files-from=po/files

for lang in ${langs[@]}; do
	if [[ -f po/$lang.po ]]; then
		echo "updating $lang.po"
		msgmerge -o po/$lang.po po/$lang.po po/mauna-update.pot
	else
		echo "creating $lang.po"
		cp po/mauna-update.pot po/$lang.po
	fi
done
