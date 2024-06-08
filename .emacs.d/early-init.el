;;; -*- mode: emacs-lisp; coding:utf-8; fill-column: 80 -*-
;;
;; Author: @clflushopt
;;
;; Copyright 2022.
;;
;; Some early initializations for startup speed and UI convenience.
;;
;; Startup speed, annoyance suppression
(setq gc-cons-threshold 10000000)
(setq byte-compile-warnings '(not obsolete))
(setq warning-suppress-log-types '((comp) (bytecomp)))
(setq native-comp-async-report-warnings-errors 'silent)

;; Disable the menubar, toolbar and scrollbar.
(tool-bar-mode -1)
(menu-bar-mode -1)
(set-scroll-bar-mode nil)
;; Maximized window from the start.

;; Clean View
;;
;; UI - Disable visual cruft
;;
;; Resizing the Emacs frame can be an expensive part of changing the
;; font. By inhibiting this, we easily halve startup times with fonts that are
;; larger than the system default.
(setq frame-inhibit-implied-resize t
        ;; Skip the splash screen, for now.
        inhibit-splash-screen t
        ;; Disable start-up screen
        inhibit-startup-screen t
        inhibit-startup-message t
        ;; No message in initial scratch buffer
        initial-scratch-message nil
        ;; Disable file dialogs.
        use-file-dialog nil
        ;; Disable dialog box.
        use-dialog-box nil
        ;; Disable popup windows.
        pop-up-windows nil
        ;; Disable cursor in inactive windows.
        cursor-in-non-selected-windows nil
        ;; Use shorthand answers.
        use-short-answers t
        ;; No message in the initial echo area
        inhibit-startup-echo-area-message (user-login-name)
        ;; Pixelwise frame resizing.
        frame-resize-pixel-wise t
        ;; Start in fullscreen.
        default-frame-alist '((fullscreen . maximized)))

;; Disable beeping.
(setq ring-bell-function 'ignore)

;; Deletes go to the system's trash.
(setq delete-by-moving-to-trash t)
;; Disable backups; it is mostly litter, when did you ever need them ?
(setq make-backup-files nil)
;; Disable lockfiles; if this is a concern, change the way you work.
(setq create-lockfiles nil)
;; Disable classic auto save.
(setq auto-save-mode nil)
;; Enable `auto-save-visited-mode` to enable auto-saves to be in the same visiting
;; files instead of creating a new file each time.
(setq auto-save-visited-mode 1)

;; Fundamental mode at startup.
;;
;; Starting in fundamental mode is akin to lazy loading as it doesn't activate
;; any mode specific dependencies.
(setq initial-major-mode 'fundamental-mode)

;; Package management basics.
;;
;;
;; Load the package-system.
(require 'package)

;;;; Package Archives
;;
;;
;; See https://protesilaos.com/codelog/2022-05-13-emacs-elpa-devel/ for discussion
(add-to-list 'package-archives
             '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(setopt package-archives
        '(("elpa" . "https://elpa.gnu.org/packages/")
          ("elpa-devel" . "https://elpa.gnu.org/devel/")
          ("nongnu" . "https://elpa.nongnu.org/nongnu/")
          ("melpa" . "https://melpa.org/packages/")))
