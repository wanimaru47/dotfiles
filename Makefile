MAKEFLAGS += --no-print-directory

MISE := $(shell command -v mise 2>/dev/null || echo $(HOME)/.local/bin/mise)
BREW := $(shell command -v brew 2>/dev/null || echo /opt/homebrew/bin/brew)

.PHONY: install diff apply require-brew

install: require-brew
	@echo "== mise =="
	@if [ -x "$(MISE)" ]; then \
	  echo "already installed: $(MISE)"; \
	else \
	  curl -fsSL https://mise.run | sh; \
	fi
	@echo "== chezmoi init =="
	@$(MISE) exec chezmoi@latest -- chezmoi init --source="$(CURDIR)"
	@$(MISE) exec chezmoi@latest -- $(MAKE) apply

diff: require-brew
	@echo "== chezmoi =="
	@chezmoi diff
	@echo "== brew =="
	@$(BREW) bundle check --file=Brewfile --verbose || true
# </dev/null が無いまま TTY で動くと、cleanup の確認プロンプトに y と答えた時点でアンインストールされる
	@$(BREW) bundle cleanup --file=Brewfile </dev/null | sed '/^Would .brew cleanup.:/,$$d'
	@echo "== mise =="
	@$(MISE) install --dry-run

apply: require-brew
	@echo "== chezmoi =="
	@chezmoi apply -v
	@echo "== brew =="
	@$(BREW) bundle install --file=Brewfile
	@echo "== mise =="
	@$(MISE) install --yes

require-brew:
	@if [ ! -x "$(BREW)" ]; then \
	  echo "error: Homebrew not found. See Requirements in README.md" >&2; \
	  exit 1; \
	fi
