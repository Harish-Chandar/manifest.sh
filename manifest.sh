#!/bin/bash

save() {
	echo "Saving manifest..."
	apt-mark showmanual | while read -r pkg; do
		if ! apt-cache show "$pkg" | grep -q '^Essential: yes'; then
			echo "$pkg"
		fi
	done | sort > $HOME/manifest/apt-manifest.txt
}

install() {
	echo "Installing packages from manifest..."
	if [ ! -f $HOME/manifest/apt-manifest.txt ]; then
		echo "Manifest file not found. Please run 'manifest save' first."
		exit 1
	fi
	xargs -a $HOME/manifest/apt-manifest.txt sudo apt-get install -y
}

case "$1" in
    save)
		save
        ;;
    install)
        echo "Installing packages..."
        ;;
    help)
        echo "Usage: manifest {save|install}"
        ;;
    *)
        echo "Unknown command: $1"
        exit 1
        ;;
esac


