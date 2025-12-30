PATH=$PATH:$HOME/.local/share/scripts
# Path to your oh-my-zsh installation.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Oh-my-zsh installation path
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

# Enable zoxide
eval "$(zoxide init zsh)"

export EDITOR="nvim"

# Setup fzf
if [[ ! "$PATH" == */home/mateus/.fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/home/mateus/.fzf/bin"
fi

source <(fzf --zsh)

# List of plugins used
plugins=( git sudo zsh-256color zsh-autosuggestions zsh-syntax-highlighting fzf-tab )
source $ZSH/oh-my-zsh.sh


# Helpful aliases
alias c='clear' # clear terminal
alias l='eza -lh --icons=auto' # long list
alias ls='eza -1 --icons=auto' # short list
alias cd='z'
alias cat='bat'
alias top='btop'

# Directory navigation shortcuts
alias ..='cd ..'
alias ...='cd ../..'
alias .3='cd ../../..'

alias mkdir='mkdir -p'

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Function to change directory using yazi and update the shell's current directory
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}

# SSH agent setup
if ! pgrep -u "$USER" ssh-agent > /dev/null; then
  eval "$(ssh-agent -s)" > /dev/null
  ssh-add ~/.ssh/id_rsa > /dev/null 2>&1
fi
