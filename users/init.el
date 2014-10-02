;; (let ((default-directory "~/liveaccounts/frontend/"))
;;   (shell "ruby"))
;; (let ((default-directory "~/liveaccounts/"))
;;   (shell "1"))

(add-to-list 'auto-mode-alist '("buildfile" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.hbs$" . web-mode))
(set-default 'truncate-lines nil)

(setq backup-directory-alist `(("." . "~/.saves")))
(setq auto-save-file-name-transforms
      `((".*" "~/.saves" t)))

;; resume the window config via revive
(require 'revive)
(if (file-exists-p "~/.revive.el")
    (resume))

(put 'erase-buffer 'disabled nil)

(require 'sanityinc-theme-init)
(dark)
(set-face-attribute 'default nil :height 150)

(require 'my-func)
(require 'my-key-bindings)
(require 'my-setup-ffip)


;;(require 'org-trello)
;; (add-hook 'org-mode-hook 'org-trello-mode)

(require 'setup-elfeed)
(require 'setup-tab)

(require 'setup-ggtags)
(require 'setup-cider)

(require 'setup-company)
(require 'setup-mozrepl)
(provide 'my-init)
