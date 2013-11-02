(let ((default-directory "~/liveaccounts/frontend/"))
  (shell "ruby"))
(let ((default-directory "~/liveaccounts/"))
  (shell "1"))

(add-to-list 'auto-mode-alist '("buildfile" . ruby-mode))
(set-default 'truncate-lines nil)

(require 'my-func)
(require 'my-key-bindings)
(provide 'my-init)
