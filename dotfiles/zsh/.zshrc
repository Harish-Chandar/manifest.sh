export EDITOR='nvim'

# Load your recovered PATH
export PATH="$(cat ~/recovered_path.txt)"
export PATH="$HOME/.local/bin:$PATH"
export STARSHIP_CONFIG="$HOME/.config/starship.toml"

# Add conda/miniconda initialization if present in recovered_path
# (e.g. export PATH="$HOME/miniconda3/bin:$PATH")

# Load your aliases
source ~/recovered_aliases.txt

fzf () {
	case "$1" in
		("cat") shift
			command fzf --preview "cat {}" "$@" ;;
		(*) command fzf "$@" ;;
	esac
}

windows () {
        case "$1" in
                ("" | "home") cd "/mnt/c/Users/haris" ;;
                ("desktop") cd "/mnt/c/Users/haris/Desktop" ;;
                ("projects") cd "/mnt/c/Users/haris/Projects" ;;
                (*) echo "Shortcut '$1' not found." ;;
        esac
}

eval "$(zoxide init zsh)"
eval "$(starship init zsh)"

clear ; fastfetch -l ubuntu_old
