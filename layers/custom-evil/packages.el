(defconst custom-evil-packages
  '(general
    evil-lion))

(defun custom-evil/init-general ()
    (use-package general
      :config (general-evil-setup)))

(defun custom-evil/init-evil-lion ()
  (use-package evil-lion
    :config (evil-lion-mode)))
