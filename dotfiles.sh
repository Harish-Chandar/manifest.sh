packages=(
	"bash"
	"gitconfig"
	"starship"
	"tmux"
	"zsh"
)

# stow dotfiles

if ! command -v stow &> /dev/null; then
	echo "gnu-stow could not be found. Would you like to install it? (y/n)"
	read -r answer
	if [[ "$answer" == "y" ]]; then
		if [[ "$OSTYPE" == "linux-gnu"* ]]; then
			sudo apt-get update
			sudo apt-get install stow
		else
			echo "Unsupported OS package manager. Please install stow manually."
			exit 1
		fi
	else
		echo "gnu-stow is required to run this script. Install manually and run this file."
		exit 1
	fi
fi

for package in "${packages[@]}"; do
	stow -v -t ~ "$package"
done
