#!/bin/bash

save() {
	echo "Saving manifest..."
	apt-mark showmanual | while read -r pkg; do
		if ! apt-cache show "$pkg" | grep -q '^Essential: yes'; then
			echo "$pkg"
		fi
	done | sort > $HOME/manifest/apt-manifest.txt
}

case "$1" in
    save)
		save
        ;;
    install)
        echo "Installing packages..."
        ;;
    diff)
        echo "Comparing..."
        ;;
    help)
        echo "Usage: manifest {save|install|diff}"
        ;;
    *)
        echo "Unknown command: $1"
        exit 1
        ;;
esac
