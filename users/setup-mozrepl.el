(require 'moz)

(defun moz-goto-content-and-run-cmd (cmd)
  (comint-send-string (inferior-moz-process)
                      (concat "repl.enter(content);"
                              cmd
                              "repl.back();")))

(comint-send-string (inferior-moz-process)
                    (concat "repl.enter(content);"
                            "console.log(\"b\");"
                            "repl.back();"))

(defun moz--eval-current-buffer ()
  (interactive)
  (moz-minor-mode 1)
  ;; flush mozrepl at first
  (moz-goto-content-and-run-cmd "console.log('hello');")
  ;; read the content of js-file
  (let (cmd)
    (setq cmd (buffer-substring-no-properties
               (point-min)
               (point-max)))
    (moz-goto-content-and-run-cmd cmd)))

;; customized javascript works with jasmine 1.3.1
(defun jasmine-with-current-buffer ()
  (interactive)
  (let (cmd)
    (setq cmd
          (format
           "%s;%s;%s;" "console.log('hello');jasmine.getEnv().currentRunner_ = new jasmine.Runner(jasmine.getEnv());jasmine.getEnv().reporter.subReporters_=[];jasmine.ConsoleReporter.prototype.log=function(str, color){console.log(str)};jasmine.getEnv().addReporter(new jasmine.ConsoleReporter(console.log));SpecHelper.specMatcher=/.*/"
           (buffer-substring-no-properties
            (point-min)
            (point-max))
           "jasmine.getEnv().execute()"))
    (moz-goto-content-and-run-cmd cmd)))

(autoload 'inferior-moz-mode "moz" "MozRepl Inferior Mode" t)
(autoload 'moz-minor-mode "moz" "MozRepl Minor Mode" t)
(add-hook 'js2-mode-hook 'javascript-moz-setup)
(defun javascript-moz-setup () (moz-minor-mode 1))

(provide 'setup-mozrepl)
