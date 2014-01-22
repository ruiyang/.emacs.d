;; (let ((default-directory "~/liveaccounts/frontend/"))
;;   (shell "ruby"))
;; (let ((default-directory "~/liveaccounts/"))
;;   (shell "1"))

(add-to-list 'auto-mode-alist '("buildfile" . ruby-mode))
(set-default 'truncate-lines nil)

(setq backup-directory-alist `(("." . "~/.saves")))
(setq auto-save-file-name-transforms
      `((".*" "~/.saves" t)))

;; resume the window config via revive
(if (file-exists-p "~/.revive.el")
    (resume))

(put 'erase-buffer 'disabled nil)

(require 'molokai-theme)
(load-theme 'molokai t)
(set-face-attribute 'default nil :height 150)

(require 'my-func)
(require 'my-key-bindings)
(require 'my-setup-ffip)
(require 'org-mobile)

(require 'org-trello)
(add-hook 'org-mode-hook 'org-trello-mode)

(require 'ob-clojure)
(setq org-babel-clojure-backend 'cider)

(require 'ob-js)

(provide 'my-init)
