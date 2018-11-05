(with-eval-after-load 'highlight-indent-guides
  (setq highlight-indent-guides-method 'column)
  (setq highlight-indent-guides-responsive 'top)
  (highlight-indent-guides-auto-set-faces)
  (add-hook 'prog-mode-hook #'highlight-indent-guides-mode))
