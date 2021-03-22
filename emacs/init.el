(require 'package)

;; optional. makes unpure packages archives unavailable
(setq package-archives nil)

(setq package-enable-at-startup nil)
(package-initialize)

(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("402eea0f7f9a150eb52c4936f486045aaef62066743cca314868684102347350" "6fc18b6b991926ea5debf205ee144b1a1fdcfcb69236024cc0bd863b666a1a11" default)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(load-theme 'zerodark)
(load-file "~/dotfiles/emacs/lsp.el")

(use-package flycheck
  :init (global-flycheck-mode))

(use-package counsel
  :init 
  (ivy-mode 1)
  (counsel-mode 1))

(use-package projectile
  :init
  (projectile-mode +1)
  :bind-keymap
  ("C-c p" . projectile-command-map))

(use-package avy
  :init
  (avy-setup-default))

(use-package fira-code-mode
  :init (global-fira-code-mode))

(use-package multiple-cursors
  :bind
  ("C-S-c C-S-c" . mc/edit-lines)
  ("C->" . mc/mark-next-like-this)
  ("C-<" . mc/mark-previous-like-this)
  ("C-c C-<" . mc/mark-all-like-this))

(use-package which-key
  :init
  (which-key-setup-side-window-right-bottom)
  (which-key-mode))

(use-package undo-tree
  :init
  (global-undo-tree-mode))
