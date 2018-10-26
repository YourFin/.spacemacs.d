;;; major-modes.el --- File containing most major modes  -*- lexical-binding: t; -*-

;; Copyright (C) 2017  

;; Author:  <pen@firecakes>
;; Keywords: extensions, 

(use-package crystal-mode
  :defer t)
(use-package toml-mode
  :defer t)
;; For log files
;;(use-package logview
;;  :defer t)
;;(use-package kotlin-mode
;;  :defer t
;;  :config
;;  (use-package flycheck-kotlin
;;    :defer t
;;    :config
;;    (flycheck-kotlin-setup)))
;;(use-package julia-mode
;;  :defer t
;;  :config
;;  (use-package julia-shell))
(use-package graphql-mode
  :defer t)

(provide 'major-modes)
