;;(require 'evil-mode)
;;(require 'evil-macros)
;;(evil-define-motion yf-visual-j (count)
;;  "Wrapper for `evil-next-visual-line' ignores the visual in visual-line mode"
;;  :type line
;;  (if (or (not evil-visual-state-minor-mode) (eq (evil-visual-type) 'inclusive))
;;      (evil-next-visual-line count)
;;    (evil-next-line count)))
;;(evil-define-motion yf-visual-k (count)
;;  "Wrapper for `evil-previous-visual-line' ignores the visual in visual-line mode"
;;  :type line
;;  (if (or (not evil-visual-state-minor-mode) (eq (evil-visual-type) 'inclusive))
;;      (evil-previous-visual-line count)
;;    (evil-previous-line count)))
;;
;;(defhydra yf-evil-windows (:hint nil
;;				 :pre (winner-mode 1)
;;				 :post (redraw-display))
;;  "
;;Movement & RESIZE^^^^
;;^ ^ _k_ ^ ^       _o__O_pen File  _C-o_nly win             ^Vim _C-k_ 
;;_h_ ^✜^ _l_       _b__B_ Sw-Buffer  _x_ Delete this win    ^_C-w_ _C-j_
;;^ ^ _j_ ^ ^       _u_ _C-r_ undo    _s_plit _v_ertically     ^_C-h_ _C-l_"
;;  ;; For some reason the evil
;;  ;; commands behave better than
;;  ;; the emacs ones
;;  ("j" evil-window-down)
;;  ("k" evil-window-up)
;;  ("l" evil-window-right)
;;  ("h" evil-window-left)
;;  ("J" evil-window-increase-height)
;;  ("K" evil-window-decrease-height)
;;  ("L" evil-window-increase-width)
;;  ("H" evil-window-decrease-width)
;;  ("u" winner-undo)
;;  ("C-r" (progn (winner-undo) (setq this-command 'winner-undo)))
;;  ("o" ranger  :color blue)
;;  ("O" helm-find-files)
;;  ("b" yf-switch-buffer  :color blue)
;;  ("B" yf-switch-buffer)
;;  ("C-o" delete-other-windows :color blue)
;;  ("x" delete-window)
;;  ("s" split-window-horizontally)
;;  ("v" split-window-vertically)
;;  ("C-w" evil-window-next :color blue)
;;  ("C-k" evil-window-up :color blue)
;;  ("C-j" evil-window-down :color blue)
;;  ("C-h" evil-window-left :color blue)
;;  ("C-l" evil-window-right :color blue)
;;  ("SPC" nil  :color blue))

;;;; Swiper ;;;;
;; Make swiper act like evil in terms
;; of where it leaves the cursor
;;(defun yf--swiper-advice (&rest r)
;;  (setq isearch-forward t)
;;  (evil-search-previous))
;;(advice-add 'swiper :after #'yf--swiper-advice)

;;(defun yf-swipe-selection (start end)
;;  "Calls swiper with the text from START to END in the current buffer
;;Returns the current selection if called interactively"
;;  (interactive "r")
;;  (let ((selection (buffer-substring-no-properties start end)))
;;    (evil-exit-visual-state)
;;    (swiper selection)))
