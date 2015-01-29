;; Ring navigation:
;; M-g ]         Go to next search results buffer, restore its current search context
;; M-g [         Ditto, but selects previous buffer.
;;               Navigation is cyclic.
;;
;; Stack navigation:
;; M-g -         Pop to previous search results buffer (kills top search results buffer)
;; M-g _         Clear the search results stack (kills all grep-a-lot buffers!)
;;
;; Other:
;; M-g =         Restore buffer and position where current search started
(require 'grep-a-lot)
(grep-a-lot-setup-keys)

;; customize find-grep
(setq grep-find-command "find . -name 'target' -prune -o -name 'webapp*assets' -prune -o -name '.bundle' -prune -o -path '*/tmp/*' -prune -o -name 'public' -prune -o -name 'cache' -prune -o -name '*' ! -name '*~' ! -name 'old-*.js' ! -name 'old-*.css' ! -name 'ext*.js' ! -name 'yui*.js' ! -name '*.dll' ! -name '*.pdb' ! -name 'development.log' -type f -print0 | xargs -0 grep -H -n ")

(provide 'setup-grep)
