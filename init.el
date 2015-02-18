;; Turn off mouse interface early in startup to avoid momentary display
(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))

;; No splash screen please ... jeez
(setq inhibit-startup-message t)

;; Set path to dependencies
(setq site-lisp-dir
      (expand-file-name "site-lisp" user-emacs-directory))

;; Set up load path
(add-to-list 'load-path user-emacs-directory)
(add-to-list 'load-path site-lisp-dir)
(add-to-list 'load-path (expand-file-name "github" user-emacs-directory))

;; Keep emacs Custom-settings in separate file
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(load custom-file)

;; Settings for currently logged in user
(setq user-settings-dir
      (expand-file-name "users" user-emacs-directory))

(setq user-themes-dir
      (expand-file-name "users/themes" user-emacs-directory))

(dolist (f (directory-files user-settings-dir))
  (let ((name (concat user-settings-dir "/" f)))
    (when (and (file-directory-p name)
               (not (equal f ".."))
               (not (equal f ".")))
      (add-to-list 'load-path name))))

(add-to-list 'load-path user-themes-dir)
(add-to-list 'load-path user-settings-dir)

;; Set up appearance early
(require 'appearance)

;; sudo related
;; C-x C-f /sudo::/etc/hosts
(require 'tramp)

;; Make Text mode the default mode for new buffers
(setq-default major-mode 'text-mode)

;; cua selection mode
(cua-selection-mode t)

;; Add external projects to load path
(dolist (project (directory-files site-lisp-dir t "\\w+"))
  (when (file-directory-p project)
    (add-to-list 'load-path project)))

;; Write backup files to own directory
(setq backup-file-folder (expand-file-name
                           (concat user-emacs-directory "backups")))
(setq backup-directory-alist
      `(("." . ,backup-file-folder)))

(setq auto-save-file-name-transforms
      `((".*" ,backup-file-folder t)))
(setq create-lockfiles nil)

;; Make backups of files, even when they're in version control
(setq vc-make-backup-files t)

;; Save point position between sessions
(require 'saveplace)
(setq-default save-place t)
(setq save-place-file (expand-file-name ".places" "~/.emacs_tmp"))

;; Are we on a mac?
(setq is-mac (equal system-type 'darwin))

;; Setup packages
(require 'package)
(set 'package-archives '())

(add-to-list 'package-archives
  '("melpa-stable" . "http://melpa-stable.milkbox.net/packages/") t)
(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/") t)
(add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/") t)

(package-initialize)
(unless (file-exists-p "~/.emacs.d/elpa/archives/melpa-stable")
  (package-refresh-contents))

(when (not (package-installed-p 'dash))
      (package-install 'dash))
(require 'setup-package)

;; Install extensions if they're missing
(defun init--install-packages ()
  (packages-install
   '(magit
     paredit
     gist
     tagedit
     simplezen
     flycheck
     flx
     flx-ido
     yasnippet
     simple-httpd
     js2-mode
;;     js2-refactor
     whitespace-cleanup-mode
     clojure-mode
     clojure-cheatsheet
     cider
     clj-refactor
     angular-snippets
     perspective
     find-file-in-project
     expand-region
     multiple-cursors
     browse-kill-ring
     smex
     ido-ubiquitous
     elfeed
     smartparens
     ggtags
     company
     solarized-theme
     moz
     skewer-mode)))

(condition-case nil
    (init--install-packages)
  (error
   (package-refresh-contents)
   (init--install-packages)))

;; Lets start with a smattering of sanity
(require 'sane-defaults)

;; Setup environment variables from the user's shell.
(when is-mac
  (require-package 'exec-path-from-shell)
  (exec-path-from-shell-initialize))

;; Setup extensions
(eval-after-load 'ido '(require 'setup-ido))
(eval-after-load 'dired '(require 'setup-dired))
(eval-after-load 'magit '(require 'setup-magit))
(eval-after-load 'grep '(require 'setup-rgrep))
(eval-after-load 'shell '(require 'setup-shell))
(require 'setup-hippie)
(require 'setup-yasnippet)
(require 'setup-perspective)
(require 'setup-ffip)
(require 'setup-html-mode)
(require 'setup-paredit)

;; Language specific setup files
(eval-after-load 'js2-mode '(require 'setup-js2-mode))
(eval-after-load 'ruby-mode '(require 'setup-ruby-mode))
(eval-after-load 'clojure-mode '(require 'setup-clojure-mode))
(eval-after-load 'markdown-mode '(require 'setup-markdown-mode))

;; Load stuff on demand
(autoload 'skewer-start "setup-skewer" nil t)
(autoload 'skewer-demo "setup-skewer" nil t)
(autoload 'flycheck-mode "setup-flycheck" nil t)
(autoload 'auto-complete-mode "auto-complete" nil t)

;; Map files to modes
(require 'mode-mappings)

;; Functions (load all files in defuns-dir)
(setq defuns-dir (expand-file-name "defuns" user-emacs-directory))
(dolist (file (directory-files defuns-dir t "\\w+"))
  (when (file-regular-p file)
    (load file)))

(require 'expand-region)
(require 'multiple-cursors)
(require 'delsel)
(require 'eproject)
(require 'setup-grep)

;; Fill column indicator
(require 'fill-column-indicator)
(setq fci-rule-color "#111122")

;; Browse kill ring
(require 'browse-kill-ring)
(setq browse-kill-ring-quit-action 'save-and-restore)

;; Smart M-x is smart
(require 'smex)
(smex-initialize)

;; Setup key bindings
(require 'key-bindings)

;; setup yaml
(require 'setup-yaml)
;; Misc
(require 'project-archetypes)
(require 'my-misc)
(when is-mac (require 'mac))

;; Emacs server
(require 'server)
(unless (server-running-p)
  (server-start))

;; Run at full power please
(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)
(put 'narrow-to-region 'disabled nil)

;; Conclude init by setting up specifics for the current user
(when (file-exists-p user-settings-dir)
  (mapc 'load (directory-files user-settings-dir nil "^[^#].*el$")))

;;
(require 'my-init)
;; Setup org
(require 'setup-org)
(require 'setup-elnode)
