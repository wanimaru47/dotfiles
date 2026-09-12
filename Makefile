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
