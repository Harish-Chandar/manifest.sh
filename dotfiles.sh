packages=(
	"bash"
	"gitconfig"
	"starship"
	"tmux"
	"zsh"
)

# stow dotfiles

for package in "${packages[@]}"; do
	stow -v -t ~ "$package"
done
