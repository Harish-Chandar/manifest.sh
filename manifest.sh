#!/bin/bash

save() {
    echo "Saving manifest..."

    apt-mark showmanual | while read -r pkg; do
        info=$(apt-cache show "$pkg")

        grep -q '^Essential: yes' <<< "$info" && continue
        grep -q '^Section: metapackages' <<< "$info" && continue
        grep -qi 'transitional package' <<< "$info" && continue

        echo "$pkg"
    done | sort > "$HOME/manifest/apt-manifest.txt"
}

add() {
	if [ -z "$2" ]; then
		echo "Please provide a package name to add."
		exit 1
	fi

	echo "$2" >> "$HOME/manifest/apt-manifest.txt"
	sort -u -o "$HOME/manifest/apt-manifest.txt" "$HOME/manifest/apt-manifest.txt"
	echo "Package '$2' added to manifest."
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
	add)
		add
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


