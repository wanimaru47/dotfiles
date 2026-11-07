# Dotfiles

## Requirements

- macOS（Apple Silicon）
- [Homebrew](https://brew.sh/)
- [1Password](https://1password.com/downloads/mac/)（SSH agent を有効にする）

## Setup

```sh
git clone https://github.com/wanimaru47/dotfiles.git ~/dev/github.com/wanimaru47/dotfiles
cd ~/dev/github.com/wanimaru47/dotfiles
make install
```

## Usage

```sh
make diff
make apply
```

## Homebrew

- マシン固有・非公開のパッケージは `~/.Brewfile.local` に書く

## zsh

- マシン固有・非公開の設定は `~/.zshrc.local` に書く
