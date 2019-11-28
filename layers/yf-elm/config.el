(with-eval-after-load 'elm
  (add-hook 'elm-mode-hook #'elm-format-on-save-mode))
