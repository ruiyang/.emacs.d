(setq ffip-patterns
  '("*"))

(setq ffip-find-options
      (ffip--create-exclude-find-options
       '("node_modules"
         "target"
         "overlays"
         "build"
         "vendor"
         "\.git")))

(provide 'my-setup-ffip)
