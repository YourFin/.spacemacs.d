;; heretic-evil-clipboard.el
;; This file contains all of the special binds I have that make killing things in
;; emacs behave better.
(require 'evil)

(defvar heretic-evil-clipboard/kill-to-second nil
  "nil: `kill-new' acts normally
truthy value: kill-new inserts into the second position in the kill ring
                     and ignores the system clipboard")
(defvar heretic-evil-clipboard/mode-line-name " heretic-clip"
  "The mode-line name for `heretic-evil-clipboard-mode'.
Should start with a space")
(defvar heretic-evil-clipboard/ignored-modes (list 'magit 'magit-diff-mode 'git-rebase-mode)
  "Modes that `heretic-evil-clipboard-mode' will not bind in.
Must be changed before `heretic-evil-clipboard-mode.el' is loaded.")
(defvar heretic-evil-clipboard//paste-kill nil
  "Internal variable for handling `heretic-evil-clipboard-p'")
;; This advice does most of the heavy lifting for heretic-evil-clipboard-mode.
(defadvice kill-new (around my-kill-new-2nd)
  "Advice around `kill-new' for `heretic-evil-clipboard/kill-to-second'"
  (cond
   ((bound-and-true-p evil-mc-cursor-list)
    (let ((interprogram-cut-function nil))
      ad-do-it))
   ;; This is for handling "pasting over" in visual mode.
   ;; If you look at how `evil-visual-paste' is defined,
   ;; it expects that `kill-new' will act normally,
   ;; so we need to emulate that behavior for the first
   ;; kill it preforms (preventing system clipboard access)...
   ((eq heretic-evil-clipboard//paste-kill 'first)
    (setq heretic-evil-clipboard//paste-kill 'second)
    (let ((interprogram-cut-function nil))
      ad-do-it))
   ;; ...and then keep the deleted section pushed to the second
   ;; part of the kill ring after `evil-visual-paste' is finished
   ;; modifying the buffer
   ((eq heretic-evil-clipboard//paste-kill 'second)
    (let ((interprogram-cut-function nil))
      ad-do-it)
    (setq heretic-evil-clipboard//paste-kill nil)
    (let ((kill-do-not-save-duplicates t))
      (kill-new (cadr kill-ring))
      ))
   ((and kill-ring (bound-and-true-p heretic-evil-clipboard/kill-to-second))
    (let ((real-kill-ring kill-ring)
	        (kill-ring (cdr kill-ring))
	        (interprogram-cut-function nil))
      ad-do-it
      (setcdr real-kill-ring kill-ring)
      (setq kill-ring-yank-pointer real-kill-ring)))
   ;;Handle empty kill ring
   ((bound-and-true-p heretic-evil-clipboard/kill-to-second)
    (let ((interprogram-cut-function nil))
      ad-do-it))
   (t (let ((interprogram-cut-function 'yf-sys-clip-set))
	      ad-do-it))))
(ad-activate 'kill-new)

(defun hetetic-evil-clipboard--add-ignore-hooks ()
  "Internal use: adds hooks for the modes that are ignored
by `heretic-evil-clipboard-mode' as defined in `heretic-evil-clipboard/ignored-modes'"
  (mapcar
   (lambda (mode)
     (let ((mode-hook
            (intern (concat (symbol-name mode) "-mode-hook"))))
       (if mode-hook
           (add-hook mode-hook 'heretic-evil-clipboard-mode-off)
         (error (concat "heretic-evil-clip: mode hook does not exist: "
                        (symbol-name mode))))))
   heretic-evil-clipboard/ignored-modes))

(defun heretic-evil-clipboard--bind (key def)
  "Binds KEY to DEF with evil-define key
Alias for (`evil-define-key' (visual and normal)
                             `heretic-evil-cilpboard-mode-map' KEY DEF)"
  (evil-define-minor-mode-key 'visual 'heretic-evil-clipboard-mode key def)
  (evil-define-minor-mode-key 'normal 'heretic-evil-clipboard-mode key def))

;;; functions
(evil-define-command heretic-evil-clipboard-p
  (count &optional register yank-handler)
  "Pastes the latest yanked text behind point,
and adds replaced text to second location in kill ring
if needed. The return value is the yanked text."
  :suppress-operator t
  (interactive "P<x>")
  ;; See the above `kill-new' advice for
  ;; comments on the rational here
  (let ((heretic-evil-clipboard//paste-kill 'first))
    (evil-paste-after count register yank-handler))
  ;; Make sure we always set `heretic-evil-clipboard//paste-kill'
  ;; back to nil
  (setq heretic-evil-clipboard//paste-kill nil))
(heretic-evil-clipboard--bind "p" #'heretic-evil-clipboard-p)

(evil-define-command heretic-evil-clipboard-P
  (count &optional register yank-handler)
  "Pastes the latest yanked text in front of point.
In visual mode, it instead replaces the text and does
put it at the top of the kill ring, unlike
`heretic-evil-clipboard-p'"
  :suppress-operator t
  (interactive "P<x>")
  (if (evil-visual-state-p)
      (heretic-evil-clipboard-p count register yank-hander)
    (evil-paste-before count register yank-handler)))
(heretic-evil-clipboard--bind "P" #'heretic-evil-clipboard-P)

(evil-define-operator heretic-evil-clipboard-gy (beg end type register yank-handler)
  "Evil-yank that dumps to 2nd in kill ring but not clipboard"
  :move-point nil
  :repeat nil
  (interactive "<R><x><y>")
  (let ((heretic-evil-clipboard/kill-to-second t))
    (evil-yank beg end type register yank-handler)))

;;(define-key evil-normal-state-map "gy" 'heretic-evil-clipboard-gy)

(evil-define-operator heretic-evil-clipboard-Y (beg end type register yank-handler)
  "Evil-yank-line that goes to clipboard as well as kill ring"
  :motion evil-end-of-line
  :move-point nil
  :repeat nil
  (interactive "<R><x>")
  (let ((heretic-evil-clipboard/kill-to-second nil))
    (evil-yank-line beg end type register))
  )
(heretic-evil-clipboard--bind "Y" #'heretic-evil-clipboard-Y)

(evil-define-operator heretic-evil-clipboard-gY (beg end type register yank-handler)
  "Evil-yank-line that dumps to 2nd in kill ring but not clipboard"
  :motion evil-end-of-line
  :move-point nil
  :repeat nil
  (interactive "<R><x>")
  (let ((heretic-evil-clipboard/kill-to-second t))
    (evil-yank-line beg end type register yank-handler)))
(heretic-evil-clipboard--bind "gY" #'heretic-evil-clipboard-gY)

(evil-define-operator heretic-evil-clipboard-x (beg end type register)
  "Evil-delete-char that dumps to 2nd in kill ring by default"
  :motion evil-forward-char
  (interactive "<R><x>")
  ;; Blackhole by default
  (unless register (setq register ?_))
  (if (and (boundp 'evil-cleverparens-mode) evil-cleverparens-mode)
      (evil-cp-delete-char-or-splice beg end type register)
    (evil-delete-char beg end type register)))
(heretic-evil-clipboard--bind "x" #'heretic-evil-clipboard-x)

(evil-define-operator heretic-evil-clipboard-X (beg end type register)
  "Evil-delete-backward-char that dumps to 2nd in kill ring by default"
  :motion evil-backward-char
  (interactive "<R><x>")
  ;; Blackhole by default
  (unless register (setq register ?_))
  (if (and (boundp 'evil-cleverparens-mode) evil-cleverparens-mode)
      (evil-cp-delete-char-or-splice-backwards beg end type register)
    (evil-delete-backward-char beg end type register)))
(heretic-evil-clipboard--bind "X" #'heretic-evil-clipboard-X)

(evil-define-operator heretic-evil-clipboard-d (beg end type register yank-handler)
  "Evil-delete that dumps to 2nd in kill ring by default"
  (interactive "<R><x><y>")
  (let ((heretic-evil-clipboard/kill-to-second t))
    (if (and (boundp 'evil-cleverparens-mode) evil-cleverparens-mode)
        (evil-cp-delete beg end type register)
      (evil-delete beg end type register))))
(heretic-evil-clipboard--bind "d" #'heretic-evil-clipboard-d)

(evil-define-operator heretic-evil-clipboard-D (beg end type register yank-handler)
  "Evil-delete-line that dumps to 2nd in kill ring by default"
  :motion evil-end-of-line
  (interactive "<R><x>")
  (let ((heretic-evil-clipboard/kill-to-second t))
    (if (and (boundp 'evil-cleverparens-mode) evil-cleverparens-mode)
        (evil-cp-delete-line beg end type register)
      (evil-delete-line beg end type register))))
(heretic-evil-clipboard--bind "D" #'heretic-evil-clipboard-D)

(evil-define-operator heretic-evil-clipboard-m (beg end type register yank-handler)
  "Evil-delete that sets custom clipboard along with standard kill"
  (interactive "<R><x><y>")
  (let ((heretic-evil-clipboard/kill-to-second nil))
    (if (and (boundp 'evil-cleverparens-mode) evil-cleverparens-mode)
        (evil-cp-delete beg end type register yank-handler)
      (evil-delete beg end type register yank-handler))))
(heretic-evil-clipboard--bind "m" #'heretic-evil-clipboard-m)

(evil-define-operator heretic-evil-clipboard-M (beg end type register yank-handler)
  "Evil-delete-line that sets custom clipboard along with standard kill"
  :motion evil-end-of-line
  (interactive "<R><x>")
  (let ((heretic-evil-clipboard/kill-to-second nil))
    (if (and (boundp 'evil-cleverparens-mode) evil-cleverparens-mode)
        (evil-cp-delete-line beg end type register)
      (evil-delete-line beg end type register))))
(heretic-evil-clipboard--bind "M" #'heretic-evil-clipboard-M)

(evil-define-operator heretic-evil-clipboard-c (beg end type register yank-handler)
  "Evil-change that dumps to 2nd in kill ring but not clipboard"
  (interactive "<R><x><y>")
  (let ((heretic-evil-clipboard/kill-to-second t))
    (if (and (boundp 'evil-cleverparens-mode) evil-cleverparens-mode)
        (evil-cp-change beg end type register yank-handler)
      (evil-change beg end type register yank-handler)))
  )
(heretic-evil-clipboard--bind "c" #'heretic-evil-clipboard-c)

(evil-define-operator heretic-evil-clipboard-gc (beg end type register yank-handler)
  "Evil-change that goes to clipboard as well as kill ring"
  (interactive "<R><x><y>")
  (let ((heretic-evil-clipboard/kill-to-second nil))
    (evil-change beg end type register yank-hander))
  )
(heretic-evil-clipboard--bind "gc" #'heretic-evil-clipboard-gc)

(evil-define-operator heretic-evil-clipboard-C (beg end type register yank-handler)
  "Evil-change-line that dumps to 2nd in kill ring but not clipboard"
  :motion evil-end-of-line
  (interactive "<R><x>")
  (let ((heretic-evil-clipboard/kill-to-second t))
    (evil-change-line beg end type register yank-handler))
  )
(heretic-evil-clipboard--bind "C" #'heretic-evil-clipboard-C)

(evil-define-operator heretic-evil-clipboard-gC (beg end type register yank-handler)
  "Evil-change-line that goes to clipboard as well as kill ring"
  :motion evil-end-of-line
  (interactive "<R><x>")
  (let ((heretic-evil-clipboard/kill-to-second nil))
    (evil-change-line beg end type register yank-hander)))
(heretic-evil-clipboard--bind "gC" #'heretic-evil-clipboard-gC)

(evil-define-operator heretic-evil-clipboard-s (beg end type register)
  :motion evil-forward-char
  (interactive "<R><x>")
  (unless register (setq register ?_))
  (if (and (boundp 'evil-cleverparens-mode) evil-cleverparens-mode)
      (evil-cp-change beg end type register)
    (evil-change beg end type register)))
(heretic-evil-clipboard--bind "s" #'heretic-evil-clipboard-s)

(define-minor-mode heretic-evil-clipboard-mode
  "Makes evil mode do sane things with the default register and kill ring,
causing deletion commands to add to the second spot in the kill ring
so as to keep them accessible, and adds a dedicated deletion key
(m by default) that interacts with the top of the kill ring and system
clipboard.

This mode currently has built in support for `evil-cleverparens-mode',
but theoretically any minor mode could be added in a similar manner

To further motivate usage of your new and improved `kill-ring',
`heretic-evil-clipboard-mode' provides heretic-evil-helm-kill-ring"
  :lighter heretic-evil-clipboard/mode-line-name
  :keymap (make-sparse-keymap)
  ;; Keymap switching handled by evil mode
  :global nil
  )

;;;###autoload
(defun heretic-evil-clipboard-mode-on ()
  "Turn on `heretic-evil-clipboard-mode'."
  (interactive)
  (unless heretic-evil-clipboard-mode
    (heretic-evil-clipboard-mode)))
;;;###autoload
(define-globalized-minor-mode global-heretic-evil-clipboard-mode
  heretic-evil-clipboard-mode  heretic-evil-clipboard-mode-on)
;;;###autoload
(defun heretic-evil-clipboard-mode-off ()
  "Turn off `heretic-evil-clipboard-mode'"
  (interactive)
  (heretic-evil-clipboard-mode -1))

;; evil helm kill ring
(when (boundp 'helm-mode)
  (require 'helm-ring)
  (defcustom heretic-evil-helm-kill-ring--actions
    '(("Paste after (no override in visual)" .
       (lambda (_str)
         (let ((marked (helm-marked-candidates))
               (sep (if (equal helm-current-prefix-arg '(16))
                        (read-string "Separator: ")
                      helm-kill-ring-separator))
               (old-kill-ring kill-ring)
               (to-paste
                ;; Taken from `helm-kill-ring-action-yank'
                (cl-loop for c in (butlast marked)
                         concat (concat c sep) into str
                         finally return (concat str (car (last marked))))))
           ;; Mask off the old kill ring, and don't
           ;; paste anywhere
           (kill-new
            (heretic-evil-clipboard-p 1)))))
      ("Paste before (override in visual)" .
       (lambda (_str)
         (let ((marked (helm-marked-candidates))
               (sep (if (equal helm-current-prefix-arg '(16))
                        (read-string "Separator: ")
                      helm-kill-ring-separator))
               kill-ring
               interprogram-cut-function
               interprogram-paste-function)
           ;; Mask off the old kill ring, and don't
           ;; paste anywhere
           (kill-new
            ;; Taken from `helm-kill-ring-action-yank'
            (cl-loop for c in (butlast marked)
                     concat (concat c sep) into str
                     finally return (concat str (car (last marked)))))
           (heretic-evil-clipboard-P 1)))))
    "List of actions for heretic kill ring source"
    ;; From `helm-kill-ring-actions'
    :group 'helm-ring
    :type '(alist :key-type string :value-type function))

  (defvar heretic-evil-helm-kill-ring--source
    (helm-build-sync-source "Kill Ring"
      :init (lambda ()
              (helm-attrset 'last-command last-command)
              (helm-attrset 'multiline helm-kill-ring-max-offset))
      :candidates #'helm-kill-ring-candidates
      :filtered-candidate-transformer #'helm-kill-ring-transformer
      :action 'heretic-evil-helm-kill-ring--actions
      :persistent-action 'ignore
      :help-message 'helm-kill-ring-help-message
      :persistent-help "DoNothing"
      :keymap helm-kill-ring-map
      :migemo t
      :multiline 'helm-kill-ring-max-offset
      :group 'helm-ring)
    "Helm source for `heretic-evil-helm-kill-ring'")

  (defun heretic-evil-helm-kill-ring ()
    (interactive)
    (let ((enable-recursive-minibuffers t))
      (helm :sources heretic-evil-helm-kill-ring--source
            :buffer "*helm evil kill ring"
            :resume 'noresume))))
(hetetic-evil-clipboard--add-ignore-hooks)

(provide 'heretic-evil-clipboard-mode)
