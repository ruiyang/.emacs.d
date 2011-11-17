(defun er/mark-word ()
  (interactive)
  (let ((word-regexp "\\sw"))
    (when (or (looking-at word-regexp)
              (looking-back word-regexp))
      (while (looking-at word-regexp)
        (forward-char))
      (set-mark (point))
      (while (looking-back word-regexp)
        (backward-char)))))

(defun er/mark-symbol ()
  (interactive)
  (let ((symbol-regexp "\\s_\\|\\sw"))
    (when (or (looking-at symbol-regexp)
              (looking-back symbol-regexp))
      (while (looking-at symbol-regexp)
        (forward-char))
      (set-mark (point))
      (while (looking-back symbol-regexp)
        (backward-char)))))

;; Mark method call (can be improved further)

(defun er/mark-method-call ()
  (interactive)
  (let ((symbol-regexp "\\s_\\|\\sw\\|\\."))
    (when (or (looking-at symbol-regexp)
              (looking-back symbol-regexp))
      (while (looking-back symbol-regexp)
        (backward-char))
      (set-mark (point))
      (while (looking-at symbol-regexp)
        (forward-char))
      (if (looking-at "(")
          (forward-list))
      (exchange-point-and-mark))))

;; Quotes

(defun er--current-quotes-char ()
  (nth 3 (syntax-ppss)))

(defalias 'er--point-is-in-string-p 'er--current-quotes-char)

(defun er--move-point-forward-out-of-string ()
  (while (er--point-is-in-string-p) (forward-char)))

(defun er--move-point-backward-out-of-string ()
  (while (er--point-is-in-string-p) (backward-char)))

(defun er/mark-inside-quotes ()
 (interactive)
 (when (er--point-is-in-string-p)
   (er--move-point-backward-out-of-string)
   (forward-char)
   (set-mark (point))
   (er--move-point-forward-out-of-string)
   (backward-char)
   (exchange-point-and-mark)))

(defun er/mark-outside-quotes ()
 (interactive)
 (if (er--point-is-in-string-p)
   (er--move-point-backward-out-of-string))
 (when (looking-at "\\s\"")
   (set-mark (point))
   (forward-char)
   (er--move-point-forward-out-of-string)
   (exchange-point-and-mark)))

;; Pairs - ie [] () {} etc

(defun er--inside-pairs-p ()
  (> (car (syntax-ppss)) 0))

(defun er/mark-inside-pairs ()
  (interactive)
  (when (er--inside-pairs-p)
      (goto-char (nth 1 (syntax-ppss)))
      (set-mark (1+ (point)))
      (forward-list)
      (backward-char)
      (exchange-point-and-mark)))

(defun er--looking-at-pair ()
  (looking-at "\\s("))

(defun er--looking-at-marked-pair ()
  (and (er--looking-at-pair)
       (eq (mark)
           (save-excursion
             (forward-list)
             (point)))))

(defun er/mark-outside-pairs ()
  (interactive)
  (when (and (er--inside-pairs-p)
             (or (not (er--looking-at-pair))
                 (er--looking-at-marked-pair)))
    (goto-char (nth 1 (syntax-ppss))))
  (when (er--looking-at-pair)
    (set-mark(point))
    (forward-list)
    (exchange-point-and-mark)))

;; Methods to try expanding to

(setq er/try-expand-list '(er/mark-word
                           er/mark-symbol
                           er/mark-method-call
                           er/mark-inside-quotes
                           er/mark-outside-quotes
                           mark-paragraph
                           er/mark-inside-pairs
                           er/mark-outside-pairs))

;; The magic expand-region method

(defun er/expand-region ()
  (interactive)
  (let ((start (point))
        (end (if (region-active-p) (mark) (point)))
        (try-list er/try-expand-list)
        (best-start 0)
        (best-end (buffer-end 1)))
    (while try-list
      (save-excursion
        (condition-case nil
            (progn
              (funcall (car try-list))
              (when (and (region-active-p)
                         (<= (point) start)
                         (>= (mark) end)
                         (> (- (mark) (point)) (- end start))
                         (> (point) best-start))
                (setq best-start (point))
                (setq best-end (mark))
                (message "%S" (car try-list))))
          (error nil)))
      (setq try-list (cdr try-list)))
    (goto-char best-start)
    (set-mark best-end)))

;; Mode-specific expansions
(require 'js-mode-expansions)

(provide 'expand-region)
