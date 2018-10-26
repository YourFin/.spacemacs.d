(defun yf-check-command-exists (COMMAND-NAME)
  "Checks whether or not COMMAND-NAME exists as an executable command"
  (interactive "sCommand to check: ")
  (let ((output (eq (call-process (yf-get-shell) nil nil nil "-c" (concat "command -v " COMMAND-NAME)) 0)))
    (if (called-interactively-p 'interactive)
	(message (if output "True" "False"))
      output)))

(defun yf-get-shell ()
  "Returns the shell in $SHELL, or sh if not found.
Assumes a *nix environment"
  (if (eq nil (getenv "SHELL")) "/bin/sh" (getenv "SHELL")))

(defun yf-shell-return-code (COMMAND)
  "Runs COMMAND in the default shell and returns it's return code."
  (call-process (yf-get-shell) nil nil nil "-c" COMMAND))

;;; Clipboard / Register nonsense
(defun yf-sys-clip-get ()
  "System-independent terminal-ready clipboard grabbing function. Does nothing to modify the clipboard"
  (let ((x-clip (lambda ()
		  (if (yf-check-command-exists "xclip")
		      (shell-command-to-string "xclip -o -selection clipboard")
		    nil ;TODO: (if (not (y-or-n-p "Attempt to install xclip locally?"))
		    )))
	)
    (cond ((eq "windows-nt" system-type) (shell-command (expand-file-name "frameworks/paste/paste.exe" user-emacs-directory))) ;untested

	  ;; from https://stackoverflow.com/questions/637005/how-to-check-if-x-server-is-running
	  ((eq 0 (yf-shell-return-code "xset q")) (funcall x-clip))
	  ((eq "darwin" system-type) (shell-command-to-string "pbpaste")))))

(defun yf-sys-clip-set (INPUT-STRING)
  "System-independent terminal-ready clipboard set function. Rather slow when used in terminal emacs on linux, so don't go using it all over the place."
  (if (display-graphic-p)
      (gui-set-selection 'CLIPBOARD INPUT-STRING)
    ;; "escape" single quotes
    (let ((clip-echo (concat "echo '" (replace-regexp-in-string "'" "'\"'\"'" INPUT-STRING) "' | ")))
      (message clip-echo)
      (cond 
       ;; We're just gonna assume that windows is going to be running the gui version of
       ;; emacs for now, as screw the windows command line.
       ((eq "windows-nt" system-type)
	(message "Fix paste on windows plz"))
       ((eq 0 (yf-shell-return-code "xset q"))
	(let* ((displays
		;; I'm so sorry about this one.
		;;
		;; The
		;; ps aux | grep emacs | grep $(ps u | sed -n '2p' | sed -e 's/\\s.*$//') | awk '{print $2}'
		;; part grabs the processs id's of every command who's name contains emacs
		;; that the current user is running
		;; The for loop part then takes those process ID's, and grabs the display environment variable that they have, and the sort -u removes all duplicates.
		(split-string (shell-command-to-string
			       "for processid in $(ps aux | grep emacs | grep $(ps u | sed -n '2p' | sed -e 's/\\s.*$//') | awk '{print $2}'); do cat /proc/$processid/environ 2>/dev/null | tr '\\0' '\\n' | grep '^DISPLAY=' | sed 's/^DISPLAY=//' ; done | sort -u")))
	       (display (cond ((eq 1 (length displays)) (car displays))
			      ((not (eq yf-clipboard-display nil)) yf-clipboard-display)
			      (t (set 'yf-clipboard-display
				      (ido-completing-read "Paste display (Local is :0): "
							   displays))
				 (make-variable-frame-local 'yf-clipboard-display)
				 yf-clipboard-display))))
	  (call-process-shell-command
	   ;; The -t is VERY NECESSARY and should not be cut.
	   ;; I do not understand why some of the various methods
	   ;; of running shell commands in emacs require this,
	   ;; but I'm not going to argue with it.
	   (concat clip-echo "xclip -selection clipboard -t UTF8_STRING -d '" display "'"))
	  )
	)
       ((eq "darwin" system-type)
	(shell-command-to-string (concat clip-echo "pbcopy")))))))

(defun yf-kill-new-second-pos (string)
  "Make STRING the second kill in kill ring. Mainly to
be used in order to redo all of the evil delete commands
such that they don't overwrite what is in the system clipboard,
but are still accessable by `helm-show-kill-ring' and similar commands.

Obviously therefore given the intended use of this function, unlike `kill-new'
it does not worry about whether or not interprogram paste is set or not,
and always acts like it is not.

It also does not change the `kill-ring-yank-pointer', as it is expected that the
paste system clipboard buffer is still intended to be what the user wants
to yank.

Much of the code here is borrowed from `kill-new' in simple.el"

  ;; start stuff that is ripped straight from kill-new
  (unless (and kill-do-not-save-duplicates
	       ;; cadr instead of car
	       (equal-including-properties string (cadr kill-ring)))
    (setcdr kill-ring (cons string (cdr kill-ring)))
    (if (> (length kill-ring) kill-ring-max)
	(setcdr (nthcdr (1- kill-ring-max) kill-ring) kill-ring) nil))
  (setq kill-ring-yank-pointer kill-ring))


(defun yf-switch-buffer ()
  "Uses projectile if in project
Defaults to helm-mini"
  (interactive)
  (if (projectile-project-p)
      (helm-projectile)
    (helm-mini)))

;; Note that this should not be moved to init.el,
;;as there is a good chance that the things required
;;in this file will be used elsewhere
(defun try-require (name) 
  "Attepts to require a file, but doesn't break
   everything if there's something wrong with the
   file"
  (condition-case nil
      (require name)
    (error nil)))

(defvar my-prog-mode-hooks
  '(emacs-lisp-mode-hook)
  "Programming major modes for
 older versions of emacs")
(defun add-prog-hook
    (func)
  "Adds to appopriate programming modes"
  (if (< emacs-version 24.1)
      (mapc (lambda (HOOK) (add-hook HOOK func)) prog-mode-hooks)
    (add-hook 'prog-mode-hook func)))

(defun yf-buffer-contains-substring-p (string)
  "Checks if the current buffer contains STRING"
  (save-excursion
    (save-match-data
      (goto-char (point-min))
      (search-forward string nil t))))

;; taken from the bottom of https://www.emacswiki.org/emacs/ToggleWindowSplit
(defun window-toggle-split-direction ()
  "Switch window split from horizontally to vertically, or vice versa.

i.e. change right window to bottom, or change bottom window to right."
  (interactive)
  (require 'windmove)
  (let ((done))
    (dolist (dirs '((right . down) (down . right)))
      (unless done
        (let* ((win (selected-window))
               (nextdir (car dirs))
               (neighbour-dir (cdr dirs))
               (next-win (windmove-find-other-window nextdir win))
               (neighbour1 (windmove-find-other-window neighbour-dir win))
               (neighbour2 (if next-win (with-selected-window next-win
                                          (windmove-find-other-window neighbour-dir next-win)))))
          (setq done (and (eq neighbour1 neighbour2)
                          (not (eq (minibuffer-window) next-win))))
          (if done
              (let* ((other-buf (window-buffer next-win)))
                (delete-window next-win)
                (if (eq nextdir 'right)
                    (split-window-vertically)
                  (split-window-horizontally))
                (set-window-buffer (windmove-find-other-window neighbour-dir) other-buf))))))))

(defvar yf/clone-location "~/gitprojects"
  "The location that `yf-clone-clipoard' clones to.")

(defun yf-clone-clipboard ()
  "Run git clone on the stuff in the clipboard at `yf/clone-location'"
  (interactive)
  (let* ((url (yf-sys-clip-get))
	(project-name (and (string-match "\\([^/:]+?\\)\\(/?\\.git\\)?$" url)
		  (match-string 1 url))))
    (if project-name
	(progn
	    (message (concat "Cloning " project-name " to " yf/clone-location))
	    (magit-clone url (concat yf/clone-location "/" project-name)))
      (message "Clipboard not a URL"))))

(defun yf-sudo ()
  "Edit the file that is associated with the current buffer as root"
  (interactive)
  (if (buffer-file-name)
      (progn
	(setq file (concat "/sudo:root@localhost:" (buffer-file-name)))
	(find-file file))
    (message "Current buffer does not have an associated file.")))

(provide 'custom-commands)
