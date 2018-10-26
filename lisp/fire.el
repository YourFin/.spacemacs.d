;;; fire.el --- Attempts to provide automatic saving and pushing of everything ala git fire  -*- lexical-binding: t; -*-

;; Copyright (C) 2017  

;; Author:  <pen@firecakes>
;; Keywords: vc, convenience, 
(require 'dash)

(defun fire (&optional kill)
  "Save everything in case of a fire. Magit and Projectile integration.

If KILL is true kill emacs as well after this is done. 

Inspired heavily by git-fire, and relies upon it for git functionality. Uses projectile to find git repositories, but does not specifically rely upon it to work.
"
  (interactive)
  ;; Save everything silently
  (message "Saving buffers...")
  (cl-flet ((message nil))
    (save-some-buffers t t))
  (when (fboundp 'projectile-mode)
      (let ((git-projects (-filter (lambda (in) (eq 'git (projectile-project-vcs in))) (projectile-open-projects))))
	(when git-projects
	  (message "Forking out git...")
	  (mapc git-projects
		(lambda (path) (async-shell-command (concat "cd " path " && git fire &")))))))
  (kill-emacs))

(provide 'fire)
