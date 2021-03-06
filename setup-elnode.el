;; Some basic elnode setup that should probably have been the default
(setq elnode-do-init nil) ;; don't start a server on port 8000 when starting emacs
(setq elnode-error-log-to-messages nil) ;; mute the crazy logging
(setq elnode-log-files-directory nil) ;; don't clutter my file system with logs either

;; Some more nice autoloads
(autoload 'elnode-webserver-handler-maker "elnode")

;; Set docroot to custom path, not bothering dropbox version
(or (file-exists-p "~/.elnode")
    (make-directory "~/.elnode"))

(setq elnode-webserver-docroot "~/.elnode/")
(setq elnode-webserver-docroot-default "~/.elnode/")
(provide 'setup-elnode)
