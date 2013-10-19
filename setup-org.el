(defun myorg-update-parent-cookie ()
  (when (equal major-mode 'org-mode)
    (save-excursion
      (ignore-errors
        (org-back-to-heading)
        (org-update-parent-todo-statistics)))))

(defadvice org-kill-line (after fix-cookies activate)
  (myorg-update-parent-cookie))

(defadvice kill-whole-line (after fix-cookies activate)
  (myorg-update-parent-cookie))

;; Setup for org
;; Set to the location of your Org files on your local system
(setq org-directory "~/Dropbox/Personal/org")
(setq org-todo-keywords
      '((type "TODO(t)" "DOING(d!)" "PAUSED(p@!)" "|" "DONE(o!)" "CANCELED(c@!)")
        (sequence "STORY" "CARD" "TASK" "|" "DONE")))

(setq org-agenda-files (list "~/Dropbox/Personal/org"))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ediff-split-window-function (quote split-window-horizontally))
 '(org-agenda-show-all-dates t)
 '(org-agenda-skip-deadline-if-done t)
 '(org-agenda-skip-scheduled-if-done t)
 '(org-mobile-agendas (quote default)))

(setq org-capture-templates
      '(("t" "Todo" entry (file+headline (concat org-directory "/capture.org") "Tasks")
             "* TODO %?\t\t%u\n")
        ("j" "Journal" entry (file+datetree "~/org/journal.org")
             "* %?\nEntered on %U\n  %i\n  %a")))

(setq org-default-notes-file (concat org-directory "/capture.org"))
(define-key global-map "\C-cc" 'org-capture)
(define-key global-map "\C-ca" 'org-agenda)

;; Set to the name of the file where new notes will be stored
(setq org-mobile-inbox-for-pull "~/Dropbox/Personal/org/mobile-inbox.org")
;; Set to <your Dropbox root directory>/MobileOrg.
(setq org-mobile-directory "~/Dropbox/Apps/MobileOrg")
(setq org-mobile-files '("~/Dropbox/Personal/org"))
(setq org-mobile-force-id-on-agenda-items nil)

;; Fork the work (async) of pushing to mobile
;; https://gist.github.com/3111823 ASYNC org mobile push...
(require 'gnus-async)
;; Define a timer variable
(defvar org-mobile-push-timer nil
  "Timer that `org-mobile-push-timer' used to reschedule itself, or nil.")
(defun org-mobile-pull-push ()
  (org-mobile-pull)
  (org-mobile-push)
  (org-agenda-to-appt))
;; Push to mobile when the idle timer runs out
(defun org-mobile-sync(min)
  (when org-mobile-push-timer
    (cancel-timer org-mobile-push-timer))
  (setq org-mobile-push-timer
        (run-with-idle-timer
         (* 60 min) nil 'org-mobile-pull-push)))
;; After saving files, start an idle timer after which we are going to push
(add-hook 'after-save-hook
 (lambda ()
   (if (or (eq major-mode 'org-mode) (eq major-mode 'org-agenda-mode))
     (dolist (file (org-mobile-files-alist))
       (if (string= (expand-file-name (car file)) (buffer-file-name))
           (org-mobile-sync 10)))
     )))

;; Run before after work
(run-at-time "17:00" 86400 '(lambda () (org-mobile-sync 20)))
;; Run 1 minute after launch, and once a day after that.
(run-at-time "20 min" 86400 '(lambda () (Org-Mobile-Sync 20)))

;; function to show popup
(defun djcb-popup (title msg &optional icon sound)
  "Show a popup if we're on X, or echo it otherwise; TITLE is the title
of the message, MSG is the context. Optionally, you can provide an ICON and
a sound to be played"
  (interactive)
  (when sound (shell-command
               (concat "mplayer -really-quiet " sound " 2> /dev/null")))
  (if (eq window-system 'x)
      (shell-command (concat "notify-send "

                             (if icon (concat "-i " icon) "")
                             " '" title "' '" msg "'"))
    ;; text only version
    (message (concat title ": " msg))))

;; the appointment notification facility
(setq
  appt-message-warning-time 15 ;; warn 15 min in advance
  appt-display-mode-line t     ;; show in the modeline
  appt-display-format 'window) ;; use our func

(appt-activate 1)              ;; active appt (appointment notification)
(display-time)                 ;; time display is required for this...

;; import agenda to appt
(org-agenda-to-appt)

 ;; update appt each time agenda opened
(add-hook 'org-finalize-agenda-hook 'org-agenda-to-appt)

;; our little façade-function for djcb-popup
 (defun djcb-appt-display (min-to-app new-time msg)
    (djcb-popup (format "Appointment in %s minute(s)" min-to-app) msg
      "/usr/share/icons/gnome/32x32/status/appointment-soon.png"
      "/usr/share/sounds/ubuntu/stereo/desktop-login.ogg"))
  (setq appt-disp-window-function (function djcb-appt-display))

(fset 'org-help
      "echo \"EOL
----Headline---------
(S-)M-Left/Right     change line heading line (tree) level
M-Up/Down            move tree up or down
C-c C-c              toggle checkbox
----TODO Operations--
C-c .                insert a timestamp
C-c C-s              add scheduled time
C-c C-t              jump to a state
C-c C-q              insert a tag
C-c $                archive the tree to default archive file
C-S <left>/<right>   different todo seq
----Capture----------
C-c c                capture
C-c C-c              save capture
----Agenda View------
C-c a a              agenda view of the current week
C-c a t              all todo items
C-u r                search the agenda matching a tag
---------------------
EOL
\"\C-m")

(provide 'setup-org)
