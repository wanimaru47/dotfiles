# wezterm の設定を OS ごとに配置する。chezmoi の対象外。
#   make diff   配置先との差分を表示
#   make apply  配置先へコピー
MAKEFLAGS += --no-print-directory
UNAME := $(shell uname -s)

ifeq ($(UNAME),Darwin)
  SRC := mac/wezterm.lua
  DST := $(HOME)/.config/wezterm/wezterm.lua
  DIFF := diff -u
else ifneq ($(shell grep -il microsoft /proc/sys/kernel/osrelease 2>/dev/null),)
  WIN_HOME := $(shell wslpath "$$(cmd.exe /c 'echo %USERPROFILE%' 2>/dev/null | tr -d '\r')")
  SRC := windows/wezterm.lua
  DST := $(WIN_HOME)/.wezterm.lua
  DIFF := diff -u --strip-trailing-cr
else
  $(error unsupported platform: $(UNAME))
endif

.PHONY: diff apply

diff:
	@if $(DIFF) "$(DST)" "$(SRC)"; then echo "up to date: $(DST)"; fi

apply:
	mkdir -p "$(dir $(DST))"
	cp "$(SRC)" "$(DST)"
	@echo "installed: $(DST)"
