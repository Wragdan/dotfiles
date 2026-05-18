;;; Code:

;; Performance Hacks
;; Emacs is an Elisp interpreter, and when running programs or packages,
;; it can occasionally experience pauses due to garbage collection.
;; By increasing the garbage collection threshold, we reduce these pauses
;; during heavy operations, leading to smoother performance.
(setq gc-cons-threshold #x40000000)

;; Set the maximum output size for reading process output, allowing for larger data transfers.
(setq read-process-output-max (* 1024 1024 4))

;; Disable JIT native compilation during normal usage.
;; All native compilation is handled upfront during installation
;; (e.g., via `ek-reinstall.sh' or `ek/first-install').
;; This prevents Emacs from compiling packages in the background
;; while you're working, which can cause occasional stutters.
(setq native-comp-jit-compilation nil)
;; If you find Emacs slow for your usage, JIT native compilation increases
;; performance dramatically.  Its default behavior, however, can be confusing
;; for newcomers since it compiles things in the background unpredictably.
;; To enable it, change the value above to `t'.  After that, every time you
;; first use a feature, JIT will compile it in the background, so expect
;; things to be sluggish for a bit.  Once everything is compiled, it's
;; speed all the way.

;; Do I really need a speedy startup?
;; Well, this config launches Emacs in about ~0.3 seconds,
;; which, in modern terms, is a miracle considering how fast it starts
;; with external packages.
;; It wasn’t until the recent introduction of tools for lazy loading
;; that a startup time of less than 20 seconds was even possible.
;; Other fast startup methods were introduced over time.
;; You may have heard of people running Emacs as a server,
;; where you start it once and open multiple clients instantly connected to that server.
;; Some even run Emacs as a systemd or sysV service, starting when the machine boots.
;; While this is a great way of using Emacs, we WON’T be doing that here.
;; I think 0.3 seconds is fast enough to avoid issues that could arise from
;; running Emacs as a server, such as 'What version of Node is my LSP using?'.
;; Again, this setup configures Emacs much like how a Vimmer would configure Neovim.


;; We will use Elpaca
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

(add-hook 'elpaca-after-init-hook
            (lambda ()
              (message "Emacs and Elpaca have fully loaded.")
              (with-current-buffer (get-buffer-create "*scratch*")
                ;; Optional: Clear the buffer first if you want to get rid of default text
                (erase-buffer) 
                (insert (format
                         ";;    Welcome to Emacs!
;;
;;    Loading time : %s
"
                         (emacs-init-time))))))

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

;;; VERTICO
;; Vertico enhances the completion experience in Emacs by providing a
;; vertical selection interface for both buffer and minibuffer completions.
;; Unlike traditional minibuffer completion, which displays candidates
;; in a horizontal format, Vertico presents candidates in a vertical list,
;; making it easier to browse and select from multiple options.
;;
;; In buffer completion, `switch-to-buffer' allows you to select from open buffers.
;; Vertico streamlines this process by displaying the buffer list in a way that
;; improves visibility and accessibility. This is particularly useful when you
;; have many buffers open, allowing you to quickly find the one you need.
;;
;; In minibuffer completion, such as when entering commands or file paths,
;; Vertico helps by showing a dynamic list of potential completions, making
;; it easier to choose the correct one without typing out the entire string.
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

(use-package magit
  :ensure (:host github :repo "magit/magit")
  :custom
  (custom-set-faces
     '(magit-diff-hunk-heading-highlight ((t (:background "#282c34"))))
     '(magit-diff-context-highlight ((t (:background "#3e4452"))))))


;;(use-package evil
;;  :ensure t
;;  :defer t
;;  :hook
;;  (after-init . evil-mode)
;;  :init
;;  (setq evil-want-integration t)      ;; Integrate `evil' with other Emacs features (optional as it's true by default).
;;  (setq evil-want-keybinding nil)     ;; Disable default keybinding to set custom ones.
;;  (setq evil-want-C-u-scroll t)       ;; Makes C-u scroll
;;  (setq evil-want-C-u-delete t)       ;; Makes C-u delete on insert mode
;;  :config
;;  (evil-set-undo-system 'undo-tree)   ;; Uses the undo-tree package as the default undo system
;;
;;  ;; Set the leader key to space for easier access to custom commands. (setq evil-want-leader t)
;;  (setq evil-leader/in-all-states t)  ;; Make the leader key available in all states.
;;  (setq evil-want-fine-undo t)        ;; Evil uses finer grain undoing steps
;;
;;  ;; Define the leader key as Space
;;  (evil-set-leader 'normal (kbd "SPC"))
;;  (evil-set-leader 'visual (kbd "SPC"))
;;
;;  ;; Keybindings for searching and finding files.
;;  ;;(evil-define-key 'normal 'global (kbd "<leader> s f") 'consult-find)
;;  ;;(evil-define-key 'normal 'global (kbd "<leader> s g") 'consult-grep)
;;  ;;(evil-define-key 'normal 'global (kbd "<leader> s G") 'consult-git-grep)
;;  ;;(evil-define-key 'normal 'global (kbd "<leader> s r") 'consult-ripgrep)
;;  ;;(evil-define-key 'normal 'global (kbd "<leader> s h") 'consult-info)
;;  ;;(evil-define-key 'normal 'global (kbd "<leader> /") 'consult-line)
;;
;;  ;;;; Flymake navigation
;;  ;;(evil-define-key 'normal 'global (kbd "<leader> x x") 'consult-flymake);; Gives you something like `trouble.nvim'
;;  ;;(evil-define-key 'normal 'global (kbd "] d") 'flymake-goto-next-error) ;; Go to next Flymake error
;;  ;;(evil-define-key 'normal 'global (kbd "[ d") 'flymake-goto-prev-error) ;; Go to previous Flymake error
;;
;;  ;;;; Dired commands for file management
;;  ;;(evil-define-key 'normal 'global (kbd "<leader> x d") 'dired)
;;  ;;(evil-define-key 'normal 'global (kbd "<leader> x j") 'dired-jump)
;;  ;;(evil-define-key 'normal 'global (kbd "<leader> x f") 'find-file)
;;
;;  ;;;; Diff-HL navigation for version control
;;  ;;(evil-define-key 'normal 'global (kbd "] c") 'diff-hl-next-hunk) ;; Next diff hunk
;;  ;;(evil-define-key 'normal 'global (kbd "[ c") 'diff-hl-previous-hunk) ;; Previous diff hunk
;;
;;  ;;;; NeoTree command for file exploration
;;  ;;(evil-define-key 'normal 'global (kbd "<leader> e e") 'neotree-toggle)
;;  ;;(evil-define-key 'normal 'global (kbd "<leader> e d") 'dired-jump)
;;
;;  ;;;; Magit keybindings for Git integration
;;  ;;(evil-define-key 'normal 'global (kbd "<leader> g g") 'magit-status)      ;; Open Magit status
;;  ;;(evil-define-key 'normal 'global (kbd "<leader> g l") 'magit-log-current) ;; Show current log
;;  ;;(evil-define-key 'normal 'global (kbd "<leader> g d") 'magit-diff-buffer-file) ;; Show diff for the current file
;;  ;;(evil-define-key 'normal 'global (kbd "<leader> g D") 'diff-hl-show-hunk) ;; Show diff for a hunk
;;  ;;(evil-define-key 'normal 'global (kbd "<leader> g b") 'vc-annotate)       ;; Annotate buffer with version control info
;;
;;  ;;;; Buffer management keybindings
;;  ;;(evil-define-key 'normal 'global (kbd "] b") 'switch-to-next-buffer) ;; Switch to next buffer
;;  ;;(evil-define-key 'normal 'global (kbd "[ b") 'switch-to-prev-buffer) ;; Switch to previous buffer
;;  ;;(evil-define-key 'normal 'global (kbd "<leader> b i") 'consult-buffer) ;; Open consult buffer list
;;  ;;(evil-define-key 'normal 'global (kbd "<leader> b b") 'ibuffer) ;; Open Ibuffer
;;  ;;(evil-define-key 'normal 'global (kbd "<leader> b d") 'kill-current-buffer) ;; Kill current buffer
;;  ;;(evil-define-key 'normal 'global (kbd "<leader> b k") 'kill-current-buffer) ;; Kill current buffer
;;  ;;(evil-define-key 'normal 'global (kbd "<leader> b x") 'kill-current-buffer) ;; Kill current buffer
;;  ;;(evil-define-key 'normal 'global (kbd "<leader> b s") 'save-buffer) ;; Save buffer
;;  ;;(evil-define-key 'normal 'global (kbd "<leader> b l") 'consult-buffer) ;; Consult buffer
;;  ;;(evil-define-key 'normal 'global (kbd "<leader>SPC") 'consult-buffer) ;; Consult buffer
;;
;;  ;;;; Project management keybindings
;;  ;;(evil-define-key 'normal 'global (kbd "<leader> p b") 'consult-project-buffer) ;; Consult project buffer
;;  ;;(evil-define-key 'normal 'global (kbd "<leader> p p") 'project-switch-project) ;; Switch project
;;  ;;(evil-define-key 'normal 'global (kbd "<leader> p f") 'project-find-file) ;; Find file in project
;;  ;;(evil-define-key 'normal 'global (kbd "<leader> p g") 'project-find-regexp) ;; Find regexp in project
;;  ;;(evil-define-key 'normal 'global (kbd "<leader> p k") 'project-kill-buffers) ;; Kill project buffers
;;  ;;(evil-define-key 'normal 'global (kbd "<leader> p D") 'project-dired) ;; Dired for project
;;
;;  ;;;; Yank from kill ring
;;  ;;(evil-define-key 'normal 'global (kbd "P") 'consult-yank-from-kill-ring)
;;  ;;(evil-define-key 'normal 'global (kbd "<leader> P") 'consult-yank-from-kill-ring)
;;
;;  ;;;; Embark actions for contextual commands
;;  ;;(evil-define-key 'normal 'global (kbd "<leader> .") 'embark-act)
;;
;;  ;;;; Undo tree visualization
;;  ;;(evil-define-key 'normal 'global (kbd "<leader> u") 'undo-tree-visualize)
;;
;;  ;;;; Help keybindings
;;  ;;(evil-define-key 'normal 'global (kbd "<leader> h m") 'describe-mode) ;; Describe current mode
;;  ;;(evil-define-key 'normal 'global (kbd "<leader> h f") 'describe-function) ;; Describe function
;;  ;;(evil-define-key 'normal 'global (kbd "<leader> h v") 'describe-variable) ;; Describe variable
;;  ;;(evil-define-key 'normal 'global (kbd "<leader> h k") 'describe-key) ;; Describe key
;;
;;  ;;;; Tab navigation
;;  ;;(evil-define-key 'normal 'global (kbd "] t") 'tab-next) ;; Go to next tab
;;  ;;(evil-define-key 'normal 'global (kbd "[ t") 'tab-previous) ;; Go to previous tab
;;
;;
;;  ;;;; Custom example. Formatting with prettier tool.
;;  ;;(evil-define-key 'normal 'global (kbd "<leader> m p")
;;  ;;                 (lambda ()
;;  ;;                   (interactive)
;;  ;;                   (shell-command (concat "prettier --write " (shell-quote-argument (buffer-file-name))))
;;  ;;                   (revert-buffer t t t)))
;;
;;  ;;;; LSP commands keybindings
;;  ;;(evil-define-key 'normal lsp-mode-map
;;  ;;                 ;; (kbd "gd") 'lsp-find-definition                ;; evil-collection already provides gd
;;  ;;                 (kbd "gr") 'lsp-find-references                   ;; Finds LSP references
;;  ;;                 (kbd "<leader> c a") 'lsp-execute-code-action     ;; Execute code actions
;;  ;;                 (kbd "<leader> r n") 'lsp-rename                  ;; Rename symbol
;;  ;;                 (kbd "gI") 'lsp-find-implementation               ;; Find implementation
;;  ;;                 (kbd "<leader> l f") 'lsp-format-buffer)          ;; Format buffer via lsp
;;
;;
;;  ;;(defun ek/lsp-describe-and-jump ()
;;  ;;  "Show hover documentation and jump to *lsp-help* buffer."
;;  ;;  (interactive)
;;  ;;  (lsp-describe-thing-at-point)
;;  ;;  (let ((help-buffer "*lsp-help*"))
;;  ;;    (when (get-buffer help-buffer)
;;  ;;      (switch-to-buffer-other-window help-buffer))))
;;
;;  ;;;; Emacs 31 finaly brings us support for 'floating windows' (a.k.a. "child frames")
;;  ;;;; to terminal Emacs. If you're still using 30, docs will be shown in a buffer at the
;;  ;;;; inferior part of your frame.
;;  ;;(evil-define-key 'normal 'global (kbd "K")
;;  ;;  (if (>= emacs-major-version 31)
;;  ;;      #'eldoc-box-help-at-point
;;  ;;      #'ek/lsp-describe-and-jump))
;;
;;  ;;;; Commenting functionality for single and multiple lines
;;  ;;(evil-define-key 'normal 'global (kbd "gcc")
;;  ;;                 (lambda ()
;;  ;;                   (interactive)
;;  ;;                   (if (not (use-region-p))
;;  ;;                       (comment-or-uncomment-region (line-beginning-position) (line-end-position)))))
;;
;;  ;;(evil-define-key 'visual 'global (kbd "gc")
;;  ;;                 (lambda ()
;;  ;;                   (interactive)
;;  ;;                   (if (use-region-p)
;;  ;;                       (comment-or-uncomment-region (region-beginning) (region-end)))))
;;
;;  ;; Enable evil mode
;;  (evil-mode 1))
