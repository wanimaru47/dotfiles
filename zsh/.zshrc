# Completion
autoload -Uz compinit
zmodload zsh/complist

ZSH_COMPDUMP="$HOME/.cache/zsh/zcompdump-$ZSH_VERSION"
[[ -d "${ZSH_COMPDUMP:h}" ]] || mkdir -p "${ZSH_COMPDUMP:h}"
compinit -d "$ZSH_COMPDUMP"

setopt auto_menu          # Tab twice starts cycling through candidates
setopt auto_list          # Show the candidate list on an ambiguous completion
setopt auto_param_slash   # Append / after a completed directory name
setopt complete_in_word   # Complete from the cursor, not only at end of word
setopt always_to_end      # Move the cursor to the end after completing
setopt list_packed        # Pack the candidate list into fewer lines
setopt magic_equal_subst  # Complete after --opt=<here>
unsetopt list_beep

# Colors used by both `ls --color` and the completion candidate list
[[ -x /usr/bin/dircolors ]] && eval "$(dircolors -b)"

zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
# Case-insensitive, then partial-word (fb -> foo/bar), then substring matching
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'
zstyle ':completion:*:warnings' format '%F{red}-- no matches --%f'
zstyle ':completion:*' squeeze-slashes true
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$HOME/.cache/zsh/zcompcache"
zstyle ':completion:*:cd:*' ignore-parents parent pwd
zstyle ':completion:*:*:kill:*:processes' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# Shift-Tab cycles backwards through the candidates
bindkey '^[[Z' reverse-menu-complete

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

# Select and edit files
function fnv() {
  local files

  files=("${(@f)$(fzf --prompt="File > " --query="$*" \
    --multi --select-1 --exit-0)}") || return

  [[ -n "$files" ]] || return

  nvim "${files[@]}"
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
