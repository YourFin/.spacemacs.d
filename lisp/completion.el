;;; This lisp file handles installing and enabling
;;; various outside completion frameworks that
;;; I do not want installed on machines
;;; that do not need a full IDE. This file should
;;; not load if emacs is accessed through SSH

(use-package company 
  :config
  ;; Add yasnippet support for all company backends
  ;; https://github.com/syl20bnr/spacemacs/pull/179
  (use-package company-statistics
    :config
    (add-hook 'after-init-hook 'company-statistics-mode))
  (defvar company-mode/enable-yas t
    "Enable yasnippet for all backends.")
  (defun company-mode/backend-with-yas (backend)
    (if (or (not company-mode/enable-yas)
            (and (listp backend)
                 (member 'company-yasnippet backend)))
	backend
      (append (if (consp backend) backend (list backend))
	      '(:with company-yasnippet))))
  (setq company-backends (mapcar #'company-mode/backend-with-yas company-backends)) (setq company-idle-delay 0)
  (add-hook 'prog-mode-hook 'company-mode)
  )

(use-package company-quickhelp
  :config
  (company-quickhelp-mode 1)
  (setq company-quickhelp-delay 0.5))

(defvar yf/ycmd-path (concat user-emacs-directory "frameworks/ycmd/ycmd/")
  "The path to the local ycmd installation location")
(when (file-exists-p yf/ycmd-path)
  (use-package ycmd
    :config
    (setq ycmd-server-command
	  `("python3" ,(file-truename
			(concat
			 user-emacs-directory
			 "frameworks/ycmd/ycmd/"))))
    (add-hook 'after-init-hook 'global-ycmd-mode)
    (use-package company-ycmd
      :config (company-ycmd-setup))))

(provide 'completion)
