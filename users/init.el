(let ((default-directory "~/liveaccounts/frontend/"))
  (shell "ruby"))
(let ((default-directory "~/liveaccounts/"))
  (shell "1"))

(add-to-list 'auto-mode-alist '("buildfile" . ruby-mode))
(SET-DEFAULT 'TRUNCATE-LINES NIL)

(require 'my-func)
(require 'my-key-bindings)
(provide 'my-init)
