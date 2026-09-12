# dotfiles をまとめて配置する wrapper。
#   make diff    配置先との差分を表示（chezmoi + wezterm）
#   make apply   差分を表示してから配置（chezmoi + wezterm）
#   make update  git pull してから apply
MAKEFLAGS += --no-print-directory

.PHONY: diff apply update

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

update:
	@git pull --ff-only
	@$(MAKE) apply
