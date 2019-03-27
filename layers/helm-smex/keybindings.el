(with-eval-after-load 'helm-smex
  (spacemacs/set-leader-keys
    dotspacemacs-emacs-command-key 'helm-smex)
  (global-set-key (kbd "M-x") 'helm-smex))
