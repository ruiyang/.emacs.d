(add-hook 'prog-mode-hook #'ggtags-mode)

(setq ggtags-executable-directory "/opt/global-6.2.12/bin")
(setq ggtags-use-project-gtagsconf nil)

(provide 'setup-ggtags)
