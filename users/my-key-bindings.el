;; my customize key-bindings
(defun refresh-file ()
  (interactive)
  (revert-buffer t t t)
  )
(global-set-key [f5] 'refresh-file)
(global-set-key [(f1)] (lambda () (interactive) (manual-entry (current-word))))
(global-set-key [f2] 'find-name-dired)
(global-set-key [f6] 'find-grep)
(global-set-key [f7] 'replace-string)
(global-set-key (kbd "C-f") 'forward-word)
(global-set-key (kbd "C-b") 'backward-word)
(global-set-key (kbd "M-f") 'forward-char)
(global-set-key (kbd "M-b") 'backward-char)
(global-set-key (kbd "M-d") 'delete-region)

(global-set-key "\C-x[" 'comment-region)	
(global-set-key "\C-x]" 'uncomment-region)
(global-set-key "\C-x=" 'align-regexp)
(global-set-key "\C-x+" 'align-repeat)
(global-set-key "\C-x:" 'erase-buffer)

(global-set-key (kbd "S-C-<left>") 'shrink-window-horizontally)
(global-set-key (kbd "S-C-<right>") 'enlarge-window-horizontally)
(global-set-key (kbd "S-C-<down>") 'shrink-window)
(global-set-key (kbd "S-C-<up>") 'enlarge-window)

;; override killing emacs key
(global-unset-key "\C-xc")
(global-unset-key "\C-x\C-c")
(global-unset-key "\C-z")
(global-unset-key "\C-x\C-z")
;; Don't want emacs to die easily, so route it to far away key!!!!
(global-set-key [(f12)] 'save-buffers-kill-emacs)
;; Don't want to suspend easily
(global-set-key [(f11)] 'redraw-display)

(provide 'my-key-bindings)
