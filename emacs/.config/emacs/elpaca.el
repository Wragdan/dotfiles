(setq read-process-output-max (* 1024 1024 4))
(setq native-comp-jit-compilation nil)
(setq gc-cons-threshold 10000000)
(setq byte-compile-warnings '(not obsolete))
(setq warning-suppress-log-types '((comp) (bytecomp)))
(setq native-comp-async-report-warnings-errors 'silent)

(setopt initial-major-mode 'fundamental-mode)  ; default mode for the *scratch* buffer
(setopt display-time-default-load-average 1) ; this information is useless for most

(setq package-enable-at-startup nil) ;; Disables the default package manager.

;; Elpaca init
(defvar elpaca-installer-version 0.12)
(defvar elpaca-directory (expand-file-name "elpaca/" user-emacs-directory))
(defvar elpaca-builds-directory (expand-file-name "builds/" elpaca-directory))
(defvar elpaca-sources-directory (expand-file-name "sources/" elpaca-directory))
(defvar elpaca-order '(elpaca :repo "https://github.com/progfolio/elpaca.git"
                              :ref nil :depth 1 :inherit ignore
                              :files (:defaults "elpaca-test.el" (:exclude "extensions"))
                              :build (:not elpaca-activate)))
(let* ((repo  (expand-file-name "elpaca/" elpaca-sources-directory))
       (build (expand-file-name "elpaca/" elpaca-builds-directory))
       (order (cdr elpaca-order))
       (default-directory repo))
  (add-to-list 'load-path (if (file-exists-p build) build repo))
  (unless (file-exists-p repo)
    (make-directory repo t)
    (when (<= emacs-major-version 28) (require 'subr-x))
    (condition-case-unless-debug err
        (if-let* ((buffer (pop-to-buffer-same-window "*elpaca-bootstrap*"))
                  ((zerop (apply #'call-process `("git" nil ,buffer t "clone"
                                                  ,@(when-let* ((depth (plist-get order :depth)))
                                                      (list (format "--depth=%d" depth) "--no-single-branch"))
                                                  ,(plist-get order :repo) ,repo))))
                  ((zerop (call-process "git" nil buffer t "checkout"
                                        (or (plist-get order :ref) "--"))))
                  (emacs (concat invocation-directory invocation-name))
                  ((zerop (call-process emacs nil buffer nil "-Q" "-L" "." "--batch"
                                        "--eval" "(byte-recompile-directory \".\" 0 'force)")))
                  ((require 'elpaca))
                  ((elpaca-generate-autoloads "elpaca" repo)))
            (progn (message "%s" (buffer-string)) (kill-buffer buffer))
          (error "%s" (with-current-buffer buffer (buffer-string))))
      ((error) (warn "%s" err) (delete-directory repo 'recursive))))
  (unless (require 'elpaca-autoloads nil t)
    (require 'elpaca)
    (elpaca-generate-autoloads "elpaca" repo)
    (let ((load-source-file-function nil)) (load "./elpaca-autoloads"))))
(add-hook 'after-init-hook #'elpaca-process-queues)
(elpaca `(,@elpaca-order))

;; Install use-package support
(elpaca elpaca-use-package
  ;; Enable use-package :ensure support for Elpaca.
  (elpaca-use-package-mode))

;; In Emacs, a package is a collection of Elisp code that extends the editor's functionality,
;; much like plugins do in Neovim. We need to import this package to add package archives.
;;(require 'package)

(use-package which-key
  :ensure t
  :config
  (which-key-mode))

;;; EMACS
;;  This is biggest one. Keep going, plugins (oops, I mean packages) will be shorter :)
(use-package emacs
  :ensure nil
  :custom                         ;; Set custom variables to configure Emacs behavior.
  (auto-save-default nil)          ;; Disable automatic saving of buffers.
  (column-number-mode t)           ;; Display the column number in the mode line.
  (create-lockfiles nil)           ;; Prevent the creation of lock files when editing.
  (delete-by-moving-to-trash t)    ;; Move deleted files to the trash instead of permanently deleting them.
  (delete-selection-mode 1)        ;; Enable replacing selected text with typed text.
  (display-line-numbers-type 'relative)   ;; Use relative line numbering in programming modes.
  (global-auto-revert-non-file-buffers t) ;; Automatically refresh non-file buffers.
  (history-length 25)              ;; Set the length of the command history.
  (indent-tabs-mode nil)           ;; Disable the use of tabs for indentation (use spaces instead).
  (inhibit-startup-message t)      ;; Disable the startup message when Emacs launches.
  (initial-scratch-message "")     ;; Clear the initial message in the *scratch* buffer.
  (ispell-dictionary "en_US")      ;; Set the default dictionary for spell checking.
  (make-backup-files nil)          ;; Disable creation of backup files.
  (pixel-scroll-precision-mode t)  ;; Enable precise pixel scrolling.
  (pixel-scroll-precision-use-momentum nil) ;; Disable momentum scrolling for pixel precision.
  (ring-bell-function 'ignore)     ;; Disable the audible bell.
  (split-width-threshold 300)      ;; Prevent automatic window splitting if the window width exceeds 300 pixels.
  (switch-to-buffer-obey-display-actions t) ;; Make buffer switching respect display actions.
  (tab-always-indent 'complete)    ;; Make the TAB key complete text instead of just indenting.
  (tab-width 4)                    ;; Set the tab width to 4 spaces.
  (treesit-font-lock-level 4)      ;; Use advanced font locking for Treesit mode.
  (truncate-lines t)               ;; Enable line truncation to avoid wrapping long lines.
  (use-dialog-box nil)             ;; Disable dialog boxes in favor of minibuffer prompts.
  (use-short-answers t)            ;; Use short answers in prompts for quicker responses (y instead of yes)
  (warning-minimum-level :emergency) ;; Set the minimum level of warnings to display.
  (x-select-enable-clipboard t)    ;; Enable clipboard

  
  :hook                                           ;; Add hooks to enable specific features in certain modes.
  (prog-mode . display-line-numbers-mode)         ;; Enable line numbers in programming modes.

  :config
  ;; Save manual customizations to a separate file instead of cluttering `init.el'.
  ;; You can M-x customize, M-x customize-group, or M-x customize-themes, etc.
  ;; The saves you do manually using the Emacs interface would overwrite this file.
  ;; The following makes sure those customizations are in a separate file.
  (setq custom-file (expand-file-name "customs.el" user-emacs-directory))
  (add-hook 'elpaca-after-init-hook (lambda () (load custom-file 'noerror)))

  ;; Set font, same i use on different systems

  (set-face-attribute 'default nil
                      :font "MesloLGS NF Regular"
                      :height 140
                      :weight 'normal)

  (when (eq system-type 'darwin)       ;; Check if the system is macOS.
    (setq mac-command-modifier 'meta))  ;; Set the Command key to act as the Meta key.
   
  :init                        ;; Initialization settings that apply before the package is loaded.
  (tool-bar-mode 0)           ;; Disable the tool bar for a cleaner interface.
  (menu-bar-mode 0)           ;; Disable the menu bar for a more streamlined look.

  (when scroll-bar-mode
    (scroll-bar-mode 0))      ;; Disable the scroll bar if it is active.

  (global-hl-line-mode -1)     ;; Disable highlight of the current line
  (global-auto-revert-mode 1)  ;; Enable global auto-revert mode to keep buffers up to date with their corresponding files.
  (recentf-mode 1)             ;; Enable tracking of recently opened files.
  (savehist-mode 1)            ;; Enable saving of command history.
  (save-place-mode 1)          ;; Enable saving the place in files for easier return.
  (winner-mode 1)              ;; Enable winner mode to easily undo window configuration changes.
  (xterm-mouse-mode 1)         ;; Enable mouse support in terminal mode.
  (file-name-shadow-mode 1)    ;; Enable shadowing of filenames for clarity.

  ;; Set the default coding system for files to UTF-8.
  (modify-coding-system-alist 'file "" 'utf-8)
)

;;(add-hook 'elpaca-after-init-hook
;;            (lambda ()
;;              (message "Emacs and Elpaca have fully loaded.")
;;              (with-current-buffer (get-buffer-create "*scratch*")
;;                ;; Optional: Clear the buffer first if you want to get rid of default text
;;                (erase-buffer) 
;;                (insert (format
;;                         ";;    Welcome to Emacs!
;;;;
;;;;    Loading time : %s
;;"
;;                         (emacs-init-time))))))

(add-hook 'emacs-startup-hook
          (lambda ()
            (global-text-scale-adjust 12)))

(use-package catppuccin-theme
  :ensure (:host github :repo "catppuccin/emacs")
  :config
  ;; Set your preferred flavor: 'latte, 'frappe, 'macchiato, or 'mocha
  (setq catppuccin-flavor 'mocha) 
  (load-theme 'catppuccin t))

(use-package dired
  :ensure nil
  :custom
  (dired-listing-switches "-lah --group-directories-first")
  (dired-dwim-target t)
  :config
  (when (eq system-type 'darwin)
    (let ((gls (executable-find "gls")))                     ;; Use GNU ls on macOS if available.
      (when gls
        (setq insert-directory-program gls)))))

(use-package org
  :ensure nil     ;; This is built-in, no need to fetch it.
  :defer t)       ;; Defer loading Org-mode until it's needed.

(use-package compat
  :ensure t)

(use-package vertico
  ;;:ensure (:host github :repo "minad/vertico" :version (lambda (_) "1.11"))
  :ensure t
  :hook
  (elpaca-after-init-hook . vertico-mode)           ;; Enable vertico after Emacs has initialized.
  :custom
  (vertico-count 10)                    ;; Number of candidates to display in the completion list.
  (vertico-resize nil)                  ;; Disable resizing of the vertico minibuffer.
  (vertico-cycle nil)                   ;; Do not cycle through candidates when reaching the end of the list.
  :config
  ;; Customize the display of the current candidate in the completion list.
  ;; This will prefix the current candidate with “» ” to make it stand out.
  ;; Reference: https://github.com/minad/vertico/wiki#prefix-current-candidate-with-arrow
  (advice-add #'vertico--format-candidate :around
              (lambda (orig cand prefix suffix index _start)
                (setq cand (funcall orig cand prefix suffix index _start))
                (concat
                 (if (= vertico--index index)
                     (propertize "» " 'face '(:foreground "#80adf0" :weight bold))
                   "  ")
                 cand))))

(use-package rainbow-delimiters
  :ensure (:host github :repo "Fanael/rainbow-delimiters")
  :defer t
  :hook
  (prog-mode . rainbow-delimiters-mode))

(use-package magit
  :ensure (:host github :repo "magit/magit"))

(use-package orderless
  :ensure (:host github :repo "oantolin/orderless")
  :defer t                                    ;; Load Orderless on demand.
  :after vertico                              ;; Ensure Vertico is loaded before Orderless.
  :init
  (setq completion-styles '(orderless basic)  ;; Set the completion styles.
        completion-category-defaults nil      ;; Clear default category settings.
        completion-category-overrides '((file (styles partial-completion))))) ;; Customize file completion styles.

(use-package marginalia
  :ensure (:host github :repo "minad/marginalia")
  :hook
  (elpaca-after-init-hook . marginalia-mode))

(use-package consult
  :ensure (:host github :repo "minad/consult")
  :defer t
  :init
  ;; Enhance register preview with thin lines and no mode line.
  (advice-add #'register-preview :override #'consult-register-window)

  ;; Use Consult for xref locations with a preview feature.
  (setq xref-show-xrefs-function #'consult-xref
        xref-show-definitions-function #'consult-xref))

(use-package exec-path-from-shell
  :ensure (:host github :repo "purcell/exec-path-from-shell")
  :init
  (when (memq window-system '(mac ns x))
    (exec-path-from-shell-initialize)))

(use-package diff-hl
  :defer (:host github :repo "dgutov/diff-hl")
  :ensure t
  :hook
  (find-file . (lambda ()
                 (global-diff-hl-mode)           ;; Enable Diff-HL mode for all files.
                 (diff-hl-flydiff-mode)          ;; Automatically refresh diffs.
                 (diff-hl-margin-mode)))         ;; Show diff indicators in the margin.
  :custom
  (diff-hl-side 'left)                           ;; Set the side for diff indicators.
  (diff-hl-margin-symbols-alist '((insert . "┃") ;; Customize symbols for each change type.
                                  (delete . "-")
                                  (change . "┃")
                                  (unknown . "┆")
                                  (ignored . "i"))))

