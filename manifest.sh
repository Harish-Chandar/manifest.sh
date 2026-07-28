#!/bin/bash

commit() {
	git -C "$HOME/manifest" add apt-manifest.txt
    git -C "$HOME/manifest" commit -m "autoupdate manifest"
    git -C "$HOME/manifest" push

	echo 'https://github.com/Harish-Chandar/manifest.sh/blob/main/apt-manifest.txt'
}

save() {
    echo "Saving manifest..."

    apt-mark showmanual | while read -r pkg; do
        info=$(apt-cache show "$pkg")
		echo "$info" | grep -q '^Essential: yes' && continue
		echo "$info" | grep -q '^Section: metapackages' && continue
		echo "$info" | grep -qi 'transitional package' && continue

        echo "$pkg"
    done | sort > "$HOME/manifest/apt-manifest.txt"

	commit
}

add() {
	if [ -z "$2" ]; then
		echo "Please provide a package name to add."
		exit 1
	fi

	apt-cache show "$2" >/dev/null 2>&1 || {
		echo "Unknown package: $2"
		exit 1
	}

	if grep -q "^$2$" "$HOME/manifest/apt-manifest.txt"; then
		echo "Package '$2' is already in the manifest."
		exit 0
	fi

	echo "$2" >> "$HOME/manifest/apt-manifest.txt"
	sort -u -o "$HOME/manifest/apt-manifest.txt" "$HOME/manifest/apt-manifest.txt"
	echo "Package '$2' added to manifest."

	commit
}

install() {
	echo "Installing packages from manifest..."
	if [ ! -f $HOME/manifest/apt-manifest.txt ]; then
		echo "Manifest file not found. Please run 'manifest save' first."
		exit 1
	fi
	xargs -a $HOME/manifest/apt-manifest.txt sudo apt install -y
}

edit() {
    "${EDITOR:-vim}" "$HOME/manifest/apt-manifest.txt"
}

case "$1" in
    save)
		save
        ;;
	add)
		add
		;;
    install)
		install
        ;;
	edit)
		edit
		;;
    help)
        echo "Usage: manifest {save|install}"
        ;;
    *)
        echo "Unknown command: $1"
        exit 1
        ;;
esac


