(defconst helm-smex-packages
  '(helm-smex))

(defun helm-smex/init-helm-smex ()
  (use-package helm-smex
    :defer t
    :init
    (setq-default smex-history-length 32
                   smex-save-file (expand-file-name ".smex-items" spacemacs-cache-directory))))
