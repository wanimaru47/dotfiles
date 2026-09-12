# Dotfiles

mac / WSL / Windows の設定を 1 つのリポジトリで管理する。

| 対象 | 管理方法 | 配置先 |
|---|---|---|
| zsh（今後 git / mise も） | [chezmoi](https://www.chezmoi.io/) | `$HOME` |
| wezterm | `wezterm/Makefile` | mac: `~/.config/wezterm/wezterm.lua`<br>Windows: `%USERPROFILE%\.wezterm.lua`（WSL から配置） |

## レイアウト

```
.
├── .chezmoi.toml.tmpl     # init 時に sourceDir と isWSL を確定
├── .chezmoiignore         # chezmoi の配布対象外（README.md, wezterm/）
├── dot_zshrc.tmpl         # → ~/.zshrc（mac / WSL の差分はテンプレートで分岐）
└── wezterm/               # chezmoi 対象外
    ├── Makefile           # make diff / make apply
    ├── mac/wezterm.lua
    └── windows/wezterm.lua
```

ソース状態はリポジトリルートに直接置く。`.git` などドット始まりのエントリは chezmoi が元から無視するので、`.chezmoiignore` には非ドットのものだけ書く。

## chezmoi の運用

```sh
chezmoi edit ~/.zshrc   # ソースを編集
chezmoi diff            # 配置先との差分を確認
chezmoi apply -v        # 適用
git commit && git push
```

他の環境では `chezmoi update` で pull と apply をまとめて行う。事前に差分だけ見たい場合は `git pull` してから `chezmoi diff`。

OS の判定は `.chezmoi.os`（`darwin` / `linux`）と、`.chezmoi.toml.tmpl` で一度だけ確定させる `.isWSL` を使う。

## wezterm の運用

OS ごとに独立したファイルを置き、Makefile が `uname` で mac / WSL を判定して配置する。

```sh
make -C wezterm diff    # 配置先との差分を確認
make -C wezterm apply   # 配置先へコピー
git commit && git push
```

Windows の設定は WSL から実行すると `/mnt/c` 経由で `%USERPROFILE%\.wezterm.lua` に配置される。Windows 側で行う操作はない。wezterm は設定ファイルの変更を自動で再読み込みする。
