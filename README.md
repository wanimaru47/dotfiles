# Dotfiles

mac / WSL / Windows の設定を 1 つのリポジトリで管理する。

| 対象 | 管理方法 | 配置先 |
|---|---|---|
| zsh（今後 git / mise も） | [chezmoi](https://www.chezmoi.io/) | `$HOME` |
| wezterm | `wezterm/Makefile` | mac: `~/.config/wezterm/wezterm.lua`<br>Windows: `%USERPROFILE%\.wezterm.lua`（WSL から配置） |

## レイアウト

```
.
├── Makefile               # make diff / apply / update（chezmoi と wezterm をまとめて実行）
├── .chezmoi.toml.tmpl     # init 時に sourceDir と isWSL を確定
├── .chezmoiignore         # chezmoi の配布対象外（README.md, Makefile, wezterm/）
├── dot_zshrc.tmpl         # → ~/.zshrc（mac / WSL の差分はテンプレートで分岐）
└── wezterm/               # chezmoi 対象外
    ├── Makefile           # make diff / make apply
    ├── mac/wezterm.lua
    └── windows/wezterm.lua
```

ソース状態はリポジトリルートに直接置く。`.git` などドット始まりのエントリは chezmoi が元から無視するので、`.chezmoiignore` には非ドットのものだけ書く。

## 日常の運用

ルートの `Makefile` が chezmoi と wezterm をまとめて扱う。

```sh
make diff      # 配置先との差分を表示（chezmoi diff + wezterm の diff）
make apply     # 差分を表示してから配置（chezmoi apply -v + wezterm の apply）
git commit && git push
```

他の環境では `make update`（`git pull --ff-only` → `make apply`）で取り込む。

### chezmoi

ソースは `chezmoi edit ~/.zshrc` で編集する（リポジトリ内の `dot_zshrc.tmpl` を直接編集してもよい）。OS の判定は `.chezmoi.os`（`darwin` / `linux`）と、`.chezmoi.toml.tmpl` で一度だけ確定させる `.isWSL` を使う。

単体で動かすときは `chezmoi diff` / `chezmoi apply -v`。

### wezterm

OS ごとに独立したファイル `wezterm/<os>/wezterm.lua` を置き、`wezterm/Makefile` が `uname` で mac / WSL を判定して配置する。

| 環境 | 配置先 |
|---|---|
| mac | `~/.config/wezterm/wezterm.lua` |
| Windows | `%USERPROFILE%\.wezterm.lua`（WSL から `/mnt/c` 経由でコピー。Windows 側で行う操作はない） |

単体で動かすときは `make -C wezterm diff` / `make -C wezterm apply`。wezterm は設定ファイルの変更を自動で再読み込みする。
