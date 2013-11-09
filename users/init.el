(let ((default-directory "~/liveaccounts/frontend/"))
  (shell "ruby"))
(let ((default-directory "~/liveaccounts/"))
  (shell "1"))

(add-to-list 'auto-mode-alist '("buildfile" . ruby-mode))
(set-default 'truncate-lines nil)

(setq backup-directory-alist `(("." . "~/.saves")))
(setq auto-save-file-name-transforms
      `((".*" "~/.saves" t)))

(require 'my-func)
(require 'my-key-bindings)
(require 'my-setup-ffip)
(provide 'my-init)
