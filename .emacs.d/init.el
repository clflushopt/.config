;;; -*- mode: emacs-lisp; coding:utf-8; fill-column: 80 -*-
;;
;; Author: @clflushopt
;;
;; Copyright 2022.
;;
;; One `init.el` to rule them all.

;; Package management made simple.

;; Use-Package Settings
(use-package use-package
  :custom
  ;; Don't automatically defer
  (use-package-always-defer nil)
  ;; Report loading details
  (use-package-verbose t)
  ;; This is really helpful for profiling
  (use-package-minimum-reported-time 0)
  ;; Expand normally
  (use-package-expand-minimally nil)
  ;; Unless otherwise set, manually handle package install -- see early-config.el
  (use-package-always-ensure t)
  ;; Navigate use-package declarations w/imenu
  (use-package-enable-imenu-support t))

;; Opinionated UX/UI changes.
;;
;;
;; Theme and font.
(load-theme 'leuven)

;; Show the buffer's filename as the frame title, no icon.
(setq frame-title-format
      (list (format "%s %%S: %%j " (user-full-name))
            '(buffer-file-name "%f" (dired-directory dired-directory "%b"))))

;; Use `RET` to follow Org mode links.
(setq org-return-follows-link t)

;; Disable the empty line indicator.
(setq indicate-empty-lines nil)

;; Use `C-` and arrow keys for window movement.
(windmove-default-keybindings 'control)

;; Show the help buffer after startup
(add-hook 'after-init-hook 'help-quick)

;; C-x/C-c/C-v do what you think they do.
(cua-mode)

;; Make right-click do something sensible
(when (display-graphic-p)
  (context-menu-mode))

;; Follow symlinks.
(setq vc-follow-symlinks t)

;; Only two packages exit by default, `which-key` and `exec-shell-from-path`.
;;
;; which-key: shows a popup of available keybindings when typing a long key
;; sequence (e.g. C-x ...)
(use-package which-key
  :ensure t
  :config
  (which-key-mode))

;; Properly load $PATH into emacs.
(use-package exec-path-from-shell
 :init
 (exec-path-from-shell-initialize))

;; Buffer and minibuffer things.
;;
;;
;; Save minibuffer histroy.
(setq history-length 25)
(savehist-mode)

;; Enable `recentf-mode`.
(setq recentf-mode 1)

;; Remember your place in the buffer.
(setq save-place-mode 1)

;; Revert buffer changes when the underlying file has changed; a bit tricky
;; but teaches good habits.
(global-auto-revert-mode)

;; Do the same but for non-file buffers e.g Dired.
(setq global-auto-revert-non-file-buffers 1)

;; No tabs
(setq-default indent-tabs-mode nil)

;; Tab.space equivalence
(setq-default tab-width 4)

;; Size of temporary buffers
(temp-buffer-resize-mode)
(setq temp-buffer-max-height 8)

;; Minimum window height
(setq window-min-height 1)

;; Buffer encoding
(prefer-coding-system       'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-language-environment   'utf-8)

;; Unique buffer names
(require 'uniquify)
(setq uniquify-buffer-name-style 'reverse
      uniquify-separator " • "
      uniquify-after-kill-buffer-p t
      uniquify-ignore-buffers-re "^\\*")

;; Modeline changes, nothing crazy.
;;
;; Show both column and line numbers.
(setq column-number-mode t)
(setq line-number-mode t)

;; Improved completion and minibuffer experience.
;;
;;
;; Optional, but I prefer to have recursive minibuffers.
(setopt enable-recursive-minibuffers t)
;; Cycle candidates with `TAB~ (also `C-n` and `C-p`).
(setopt completion-cycle-threshold 1)                  ; TAB cycles candidates
;; Annotations, superseeded by marginalia.
(setopt completions-detailed t)                        ; Show annotations
;; Trigger completion, then indentation when `TAB` is pushed.
(setopt tab-always-indent 'complete)
;; Enable as many as you prefer, superseeded by `orderless` later.
(setopt completion-styles '(basic initials substring))

; Open completion lazily.
(setopt completion-auto-help 'lazy)
;; Cap completion mini-buffer size, make them details; mostly UI changes.
(setopt completions-max-height 20)
(setopt completions-detailed t)
(setopt completions-format 'one-column)
(setopt completions-group t)
;; If this is set to `t` it will switch to `completions` tab immediately
;; with `'second-tab` it waits for a second push on the tab key.
(setopt completion-auto-select 'second-tab)

;; Makes `TAB` acts similarly to the shell, but only in the `minibuffer` keymap.
(keymap-set minibuffer-mode-map "TAB" 'minibuffer-complete)

;; Programming mode hooks, nothing crazy again just some good defaults.
;;
;; Line numbers in all `prog-mode` and `text-mode` buffers, make them useful
;; i.e "relative" and set the width to 3.
;;
(add-hook 'prog-mode-hook 'display-line-numbers-mode)
(add-hook 'text-mode-hook 'display-line-numbers-mode)

(setq display-line-numbers-type 'relative)
(setq display-line-numbers-width 3)

;; Always show trailing whitespaces.
;;
(setq show-trailing-whitespace t)
;; Automatically delete whitespace on saves.
;;
(add-hook 'write-contents-functions 'delete-trailing-whitespace t)

;; Highlight current line.
(let ((hl-line-hooks '(text-mode-hook prog-mode-hook)))
  (setq hl-line-sticky-flag nil)
  (mapc (lambda (hook) (add-hook hook 'hl-line-mode)) hl-line-hooks))

;; Enable Treesitter on default extensions.
;;
;; Enable `rust-ts-mode` on `*.rs` files.
(add-to-list 'auto-mode-alist '("\\.rs\\'" . rust-ts-mode))

;; Enable LSP on certain modes by default.
(use-package emacs
  :hook (rust-ts-mode . eglot-ensure))

;; Configure eglot behavior outside normal buffers.
(use-package eglot
  :custom
  (eglot-send-changes-idle-time 0.1)
  ;; Trigger eglot in referenced non-project files (`xref` buffer).
  (eglot-extend-to-xref t)

  :config
  ;; Disable log events.
  (fset #'jsonrpc--log-event #'ignore))

;; Eglot keybindings, the `C-c` prefix uses lowercase `c` as a mnemonic for code
;; actions.
;;
(define-key eglot-mode-map (kbd "C-c r") 'eglot-rename)
(define-key eglot-mode-map (kbd "C-c o") 'eglot-code-action-organize-imports)
(define-key eglot-mode-map (kbd "C-c f") 'eglot-format-buffer)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Realm of extras, from here on we leave the realm of emacs configuration
;;; and venture into package configuration.
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Vi emulation, modal editing is superior.
;;
;; Evil: vi emulation
(use-package evil
  :ensure t
  :init
  (setq evil-cross-lines t)
  (setq evil-want-keybinding nil)
  (setq evil-respect-visual-line-mode t)
  (setq evil-undo-system 'undo-redo)
  (setq evil-want-C-u-scroll t)
  (setq evil-respect-visual-line-mode t)
  (setq evil-undo-system 'undo-redo)
  :demand
  :config
  ;; Make emacs own `C-g` more useful.
  (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
  ;; Configuring initial major mode for some modes; if you are feeling weak.
  ;; (evil-set-initial-state 'vterm-mode 'emacs))
  (evil-mode 1))

;; Evil extras.
;;
;;
(use-package evil-collection
  :ensure t
  :after evil
  :init
  (evil-collection-init))

;; Evil keybindings for less arrow based movement.
;;
;; In insert mode use C-hjkl to move around but use emacs functions instead
;; of evil movement functions for a better experience.
(evil-define-key 'insert global-map (kbd "C-h") 'backward-char)
(evil-define-key 'insert global-map (kbd "C-j") 'next-line)
(evil-define-key 'insert global-map (kbd "C-k") 'previous-line)
(evil-define-key 'insert global-map (kbd "C-l") 'forward-char)

;; One last goodness, when yanking pulse the yanked region.
(defun evil-pulse-on-yank-advice (orig-fn beg end &rest args)
  (pulse-momentary-highlight-region beg end)
  (apply orig-fn beg end args))

(advice-add 'evil-yank :around 'evil-pulse-on-yank-advice)

;; Custom plugins, these are loaded on demand and can be enabled or disabled
;; optionally.
;;
;; Completion stack with avy, embark, consult and corfu provides a much better
;; completion and minibuffer U/X than native emacs.
(load-file (expand-file-name "plugins/base.el" user-emacs-directory))
