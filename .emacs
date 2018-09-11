;; don't backup files
(setq make-backup-files nil)
(setq auto-save-default nil)

;; Ctrl-H is BackSpace
(global-set-key "\C-h" 'delete-backward-char)

(load-theme 'wombat t)

;; C++ style
(add-hook 'c++-mode-hook
	  '(lambda()
	     (c-set-style "cc-mode")))
