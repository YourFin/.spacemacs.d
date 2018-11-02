;;; packages.el --- Packages for yatemplate layer    -*- lexical-binding: t; -*-

;; Copyright (C) 2018 Patrick Nuckolls

;; Author:  <pen@firecakes>

(defconst yatemplate-packages
  '(yatemplate))

(defun yatemplate/init-yatemplate ()
    (use-package yatemplate
      :defer t
      :init
      (setq-default yatemplate-dir (expand-file-name "~/.spacemacs.d/yatemplates"))))
