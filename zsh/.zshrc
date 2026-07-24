autoload -Uz compinit
compinit

# Zsh options
setopt auto_cd
setopt interactive_comments

# History
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000

setopt hist_ignore_dups
setopt share_history

# Windows executables
alias ssh='ssh.exe'
alias ssh-add='ssh-add.exe'

# ls
alias ls='ls --color=auto'
alias ll='ls -alFh --color=auto'
alias la='ls -A --color=auto'
alias emacs='emacs -nw'

# Select and move to a ghq repository
function cdr() {
  local repo

  repo=$(ghq list --full-path | fzf --prompt="Repository > ") || return

  cd "$repo"
}

# PATH
typeset -U path PATH
path=(
       /snap/bin
       $path
)
export PATH

# Rust
[[ -f "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"

# mise
eval "$("$HOME/.local/bin/mise" activate zsh)"

# Starship
eval "$(starship init zsh)"
