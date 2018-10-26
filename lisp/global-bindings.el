(defun yf-exit-minibuffer-ev-paste-after ()
    "Exits the helm minibuffer and
pastes after; intended for helm-calcul-expression"
  (interactive)
  (helm-maybe-exit-minibuffer)
  (evil-paste-after))

(defun yf-exit-minibuffer-ev-paste-before ()
    "Exits the helm minibuffer and
pastes; intended for helm-calcul-expression"
  (interactive)
  (helm-maybe-exit-minibuffer)
  (evil-paste-before))

;(define-key helm-calcul-expression-map (kbd "<RET>") 'yf-exit-minibuffer-ev-paste-after)
;(define-key helm-calcul-expression-map (kbd "S-<RET>") 'yf-exit-minibuffer-ev-paste-before)

(defun yf-possible-increase-size ()
  "Runs text scale decrease if in not terminal mode, otherwise
falls through"
  (interactive)
  (if (not (display-graphic-p))
      nil
    (text-scale-increase 1)
    (redraw-display)))
(defun yf-possible-decrease-size ()
  "Runs text-scale-decrease if not in terminal mode, otherwise
falls through"
  (interactive)
  (if (not (display-graphic-p))
      nil
    (text-scale-decrease 1)
    (redraw-display)))

;;Control-v to paste in helm
(define-key helm-map (kbd "C-v") 'yank)

(define-key global-map (kbd "C-+") 'yf-possible-increase-size)
(define-key global-map (kbd "C-_") 'yf-possible-decrease-size)
;; not too happy about this, but I want to keep consistancy with my terminals
(define-key undo-tree-map (kbd "C-_") nil)

(provide 'global-bindings)
