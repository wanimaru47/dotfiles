# dotfiles をまとめて配置する wrapper。
#   make diff    配置先との差分を表示（chezmoi + wezterm）
#   make apply   差分を表示してから配置（chezmoi + wezterm）
MAKEFLAGS += --no-print-directory

.PHONY: diff apply

diff:
	@echo "== chezmoi =="
	@chezmoi diff
	@echo "== wezterm =="
	@$(MAKE) -C wezterm diff

apply:
	@echo "== chezmoi =="
	@chezmoi apply -v
	@echo "== wezterm =="
	@$(MAKE) -C wezterm apply
