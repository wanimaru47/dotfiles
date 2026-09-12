MAKEFLAGS += --no-print-directory

MISE := $(shell command -v mise 2>/dev/null || echo $(HOME)/.local/bin/mise)

.PHONY: diff apply

diff:
	@echo "== chezmoi =="
	@chezmoi diff
	@echo "== mise =="
	@$(MISE) install --dry-run
	@echo "== wezterm =="
	@$(MAKE) -C wezterm diff

apply:
	@echo "== chezmoi =="
	@chezmoi apply -v
	@echo "== mise =="
	@$(MISE) install --yes
	@echo "== wezterm =="
	@$(MAKE) -C wezterm apply
