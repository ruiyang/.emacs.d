(require 'moz)

;; customized javascript works with jasmine 1.3.1
(defun jasmine-with-current-buffer ()
  (interactive)
  (let (cmd)
    (setq cmd
          (format
           "%s;%s;%s;" "console.log('hello');$('.jasmine_reporter').remove();jasmine.getEnv().currentRunner_ = new jasmine.Runner(jasmine.getEnv());jasmine.getEnv().reporter.subReporters_=[];jasmine.getEnv().addReporter(new jasmine.HtmlReporter());SpecHelper.specMatcher=/.*/"
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
