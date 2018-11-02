export LANG=ja_JP.UTF-8

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
export PATH="$HOME/.cargo/bin:$PATH"

autoload -Uz colors
colors

autoload -Uz compinit
compinit

bindkey -e

setopt share_history

setopt histignorealldups

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

if [ "$(uname)" = 'Darwin' ]; then
    export LSCOLORS=xbfxcxdxbxegedabagacad
    alias ls='ls -G'
    alias la='ls -laG'
else
    eval `dircolors ~/.colorrc`
    alias ls='ls --color=auto'
fi


PROMPT="%(?.%{${fg[green]}%}.%{${fg[red]}%})%n${reset_color}@${fg[blue]}%m %~%# "

