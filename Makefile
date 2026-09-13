MAKEFLAGS += --no-print-directory

MISE := $(shell command -v mise 2>/dev/null || echo $(HOME)/.local/bin/mise)

.PHONY: install diff apply

install:
	@echo "== mise =="
	@if [ -x "$(MISE)" ]; then \
	  echo "already installed: $(MISE)"; \
	else \
	  curl -fsSL https://mise.run | sh; \
	fi
	@echo "== chezmoi init =="
	@$(MISE) exec chezmoi@latest -- chezmoi init --source="$(CURDIR)"
	@$(MISE) exec chezmoi@latest -- $(MAKE) apply

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
