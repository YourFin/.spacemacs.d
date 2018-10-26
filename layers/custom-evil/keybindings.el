(with-eval-after-load 'evil-core
  (evil-define-minor-mode-key 'normal 'git-commit-mode
    "q" 'with-editor-finish
    "Q" 'with-editor-cancel))

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

;; Force use of motion bindings
(general-def 'normal
             "J" nil)
(general-def 'motion
             ;;"j" 'yf-visual-j
             ;;"k" 'yf-visual-k
             ;;"J" (lambda () (interactive) (yf-visual-j 15))
             ;;"K" (lambda () (interactive) (yf-visual-k 15))
             "," 'goto-last-change
             "g," 'goto-last-change-reverse
             ";" 'evil-repeat-find-char
             "g;" 'evil-repeat-find-char-reverse
             ;;"/" 'swiper
             )
(general-define-key
 :states '(normal insert)
 "C-y" 'yas-expand
 "C-s" 'sp-slurp-hybrid-sexp
 "M-RET" 'comment-indent-new-line)
(general-define-key
 :states 'insert
 "M-j" 'evil-next-visual-line
 "M-k" 'evil-previous-visual-line
 "M-h" 'evil-backward-char
 "M-l" 'evil-forward-char
 "M-w" 'evil-forward-word)

;; a holdover from my vim days
(define-key evil-normal-state-map (kbd "-j") 'evil-join)

;;(define-key evil-normal-state-map (kbd "C-w") nil)
;;(define-key evil-motion-state-map (kbd "C-w") nil)
;;(define-key evil-insert-state-map (kbd "C-w") nil)
;;(global-set-key (kbd "C-w") 'yf-evil-windows/body)

;;;; Swiper ;;;;
;;(define-key evil-visual-state-map (kbd "*") 'yf-swipe-selection)

;;(define-key swiper-map (kbd "M-j") 'ivy-next-line)
;;(define-key swiper-map (kbd "M-k") 'ivy-previous-line)
;;(define-key swiper-map (kbd "C-v") 'yank)
;;(define-key swiper-map (kbd "C-c") 'minibuffer-keyboard-quit)
