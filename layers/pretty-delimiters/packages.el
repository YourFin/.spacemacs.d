(defconst pretty-delimiters-packages
 '(rainbow-delimiters))

(defun pretty-delimiters/post-init-rainbow-delimiters ()
  (add-hook 'latex-mode-hook #'rainbow-delimiters-mode-enable)
  (add-hook 'prog-mode-hook #'rainbow-delimiters-mode-enable))
