;; make lines unique recursively.
(defun uniquify-all-lines-region (start end)
  "Find duplicate lines in region START to END keeping first occurrence."
  (interactive "*r")
  (save-excursion
    (let ((end (copy-marker end)))
      (while
          (progn
            (goto-char start)
            (re-search-forward "^\\(.*\\)\n\\(\\(.*\n\\)*\\)\\1\n" end t))
        (replace-match "\\1\n\\2")))))

(defun uniquify-all-lines-buffer ()
  "Delete duplicate lines in buffer and keep first occurrence."
  (interactive "*")
  (uniquify-all-lines-region (point-min) (point-max)))

(defun bf-pretty-print-xml-region (begin end)
  "Pretty format XML markup in region. You need to have nxml-mode
http://www.emacswiki.org/cgi-bin/wiki/NxmlMode installed to do
this.  The function inserts linebreaks to separate tags that have
nothing but whitespace between them.  It then indents the markup
by using nxml's indentation rules."
  (interactive "r")
  (save-excursion
    (nxml-mode)
    (goto-char begin)
    (while (search-forward-regexp "\>[ \\t]*\<" nil t)
      (backward-char) (insert "\n"))
    (indent-region begin end))
  (message "Ah, much better!"))

;; format json
(defun json-format ()
  (interactive)
  (let ((b (if mark-active (min (point) (mark)) (point-min)))
        (e (if mark-active (max (point) (mark)) (point-max))))
    (shell-command-on-region b e
                             "python -mjson.tool" (current-buffer) t)))

(defun sudo-edit (&optional arg)
  (interactive "p")
  (if (not buffer-file-name)
      (find-file (concat "/sudo:root@localhost:" (ido-read-file-name "File: ")))
    (find-alternate-file (concat "/sudo:root@localhost:" buffer-file-name))))

(setq help-location "~/.emacs.d/users/help/")
(setq helps `("magit" "vi" "shell" "org"))

(dolist (x helps)
  (let (help-func (make-symbol (concat x "-help")))
    (defun help-func ()
      (interactive)
      (print help-func)
      (find-file (concat help-location (concat x ".org"))))))

(defun magit-help ()
  (interactive)
  (find-file (concat help-location "magit.org")))

(defun vi ()
  (interactive)
  (find-file "~/.emacs.d/users/help/vi.org"))

(defun shell-help ()
  (interactive)
  (find-file "~/.emacs.d/users/help/shell.org"))

(defun org-help ()
  (interactive)
  (find-file "~/.emacs.d/users/help/org.org"))

(defun todo ()
  (interactive)
  (find-file "~/Dropbox/Personal/org/todo.org"))

(provide 'my-func)
