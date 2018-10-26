;;Remove annoying bars
(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))

;; Make scrolling happen not quite at the bottom of the screen
(setq scroll-margin 3)
;; vim like scrolling
(setq scroll-step 1)

(use-package beacon
  :config (beacon-mode 1))

(global-hl-line-mode -1) ; Disable current line highlight

;;(use-package rainbow-delimiters
;;  :config
;;  (add-hook 'prog-mode-hook #'rainbow-delimiters-mode)
;;  (setq rainbow-delimiters-max-face-count 8)
;;  ;;more rainbow-ey rainbow delimiters. they cycle around the
;;  ;;color wheel approximatly every three colors with a bit of offset. 256 color
;;  ;;term compatable
;;  (set-face-foreground 'rainbow-delimiters-depth-1-face "#5fd7ff")
;;  (set-face-foreground 'rainbow-delimiters-depth-2-face "#ffaf00")
;;  (set-face-foreground 'rainbow-delimiters-depth-3-face "#d75fff")
;;  (set-face-foreground 'rainbow-delimiters-depth-4-face "#87ff00")
;;  (set-face-foreground 'rainbow-delimiters-depth-5-face "#ff5f00")
;;  (set-face-foreground 'rainbow-delimiters-depth-6-face "#0087ff")
;;  (set-face-foreground 'rainbow-delimiters-depth-7-face "#ffff00")
;;  (set-face-foreground 'rainbow-delimiters-depth-8-face "#ff87ff"))

(use-package highlight-indent-guides
  :config
  (setq highlight-indent-guides-method 'column)
  (setq highlight-indent-guides-auto-odd-face-perc 23)
  (setq highlight-indent-guides-auto-even-face-perc 16)
  (add-hook 'prog-mode-hook 'highlight-indent-guides-mode))

;;; Fringe
;; Line Numbers
(defun my-linum ()
  "Turns on and colors line numbers"
  ;; Line Numbers
  (if (>= emacs-major-version 26)
      (display-line-numbers-mode)
    (linum-mode)
    (custom-set-variables '(linum-format 'dynamic))
    ;; Blatantly stolen from stackoverflow: https://stackoverflow.com/questions/3626632/right-align-line-numbers-with-linum-mode
    (defadvice linum-update-window (around linum-dynamic activate)
      (let* ((w (length (number-to-string
		                     (count-lines (point-min) (point-max)))))
	           (linum-format (concat "%" (number-to-string w) "d ")))
        ad-do-it))
    (set-face-background 'linum "black")))
(add-hook 'prog-mode-hook #'my-linum)
(add-hook 'markdown-mode-hook #'my-linum)
(add-hook 'latex-mode-hook #'my-linum)
;; Emacs 26 and up
(setq-default display-line-numbers-grow-only t)

;; Wrapping
(defvar yf/wrapping-linum-display
  `((magin lefit-margin) ,(propertize "-----" 'face 'linum))
  "string used on margin")

;;(use-package adaptive-wrap
;;  :config (add-hook 'prog-mode-hook 'adaptive-wrap-prefix-mode))

;;;;; automatically wrap comments around correctly
;;(auto-fill-mode)
;;(setq comment-auto-fill-only-comments t)

;;;; Draws a line at fill column length
;;(use-package fill-column-indicator
;;  :defer t
;;  :config
;;  (defun yf-fill-column-indicator-mode ()
;;    "alias to fci-mode"
;;    (interactive)
;;    (fci-mode)))

;;; Specific to GUI emacs
(when (display-graphic-p)
  ;; Remove wrap arrows
  ;; Taken from https://web.archive.org/web/20170820232748/https://stackoverflow.com/questions/27845980/how-do-i-remove-newline-symbols-inside-emacs-vertical-border
  (setf (cdr (assq 'continuation fringe-indicator-alist))
        '(nil right-curly-arrow)) ;; right indicator only
  ;;; Fira code
  ;; This works when using emacs --daemon + emacsclient
  (when (find-font (font-spec :name "FiraHacked"))
    (add-hook 'after-make-frame-functions (lambda (frame) (set-fontset-font t '(#Xe100 . #Xe16f) "Fira Code Symbol")))
    ;; This works when using emacs without server/client
    (set-fontset-font t '(#Xe100 . #Xe16f) "Fira Code Symbol")
    ;; I haven't found one statement that makes both of the above situations work, so I use both for now
    (defconst fira-code-font-lock-keywords-alist
      (mapcar (lambda (regex-char-pair)
                `(,(car regex-char-pair)
                  (0 (prog1 ()
                       (compose-region (match-beginning 1)
                                       (match-end 1)
                                       ;; The first argument to concat is a string containing a literal tab
                                       ,(concat "	" (list (decode-char 'ucs (cadr regex-char-pair)))))))))
              '(;;("\\(www\\)"                   #Xe100)
                ("[^/]\\(\\*\\*\\)[^/]"        #Xe101)
                ("\\(\\*\\*\\*\\)"             #Xe102)
                ("\\(\\*\\*/\\)"               #Xe103)
                ("\\(\\*>\\)"                  #Xe104)
                ("[^*]\\(\\*/\\)"              #Xe105)
                ;;("\\(\\\\\\\\\\)"              #Xe106)
                ;;("\\(\\\\\\\\\\\\\\)"          #Xe107)
                ("\\({-\\)"                    #Xe108)
                ;;("\\(\\[\\]\\)"                #Xe109)
                ;;("\\(::\\)"                    #Xe10a)
                ;;("\\(:::\\)"                   #Xe10b)
                ("[^=]\\(:=\\)"                #Xe10c)
                ("\\(!!\\)"                    #Xe10d)
                ("\\(!=\\)"                    #Xe10e)
                ("\\(!==\\)"                   #Xe10f)
                ("\\(-}\\)"                    #Xe110)
                ;;("\\(--\\)"                    #Xe111)
                ;;("\\(---\\)"                   #Xe112)
                ("\\(-->\\)"                   #Xe113)
                ("[^-]\\(->\\)"                #Xe114)
                ("\\(->>\\)"                   #Xe115)
                ("\\(-<\\)"                    #Xe116)
                ("\\(-<<\\)"                   #Xe117)
                ("\\(-~\\)"                    #Xe118)
                ("\\(#{\\)"                    #Xe119)
                ("\\(#\\[\\)"                  #Xe11a)
                ("\\(##\\)"                    #Xe11b)
                ("\\(###\\)"                   #Xe11c)
                ("\\(####\\)"                  #Xe11d)
                ("\\(#(\\)"                    #Xe11e)
                ("\\(#\\?\\)"                  #Xe11f)
                ("\\(#_\\)"                    #Xe120)
                ("\\(#_(\\)"                   #Xe121)
                ("\\(\\.-\\)"                  #Xe122)
                ("\\(\\.=\\)"                  #Xe123)
                ("\\(\\.\\.\\)"                #Xe124)
                ("\\(\\.\\.<\\)"               #Xe125)
                ("\\(\\.\\.\\.\\)"             #Xe126)
                ("\\(\\?=\\)"                  #Xe127)
                ("\\(\\?\\?\\)"                #Xe128)
                ;;("\\(;;\\)"                    #Xe129)
                ("\\(/\\*\\)"                  #Xe12a)
                ("\\(/\\*\\*\\)"               #Xe12b)
                ("\\(/>\\)"                    #Xe12e)
                ("\\(//\\)"                    #Xe12f)
                ("\\(///\\)"                   #Xe130)
                ("\\(&&\\)"                    #Xe131)
                ("\\(||\\)"                    #Xe132)
                ("\\(||=\\)"                   #Xe133)
                ("[^|]\\(|=\\)"                #Xe134)
                ("\\(|>\\)"                    #Xe135)
                ("\\(\\^=\\)"                  #Xe136)
                ("\\(\\$>\\)"                  #Xe137)
                ("\\(\\+\\+\\)"                #Xe138)
                ("\\(\\+\\+\\+\\)"             #Xe139)
                ("\\(\\+>\\)"                  #Xe13a)
                ("\\(=:=\\)"                   #Xe13b)
                ("[^!/]\\(==\\)[^>]"           #Xe13c)
                ("\\(===\\)"                   #Xe13d)
                ("\\(==>\\)"                   #Xe13e)
                ("[^=]\\(=>\\)"                #Xe13f)
                ("\\(=>>\\)"                   #Xe140)
                ("\\(<=\\)"                    #Xe141)
                ("\\(=<<\\)"                   #Xe142)
                ("\\(=/=\\)"                   #Xe143)
                ("\\(>-\\)"                    #Xe144)
                ("\\(>=\\)"                    #Xe145)
                ("\\(>=>\\)"                   #Xe146)
                ("[^-=]\\(>>\\)"               #Xe147)
                ("\\(>>-\\)"                   #Xe148)
                ("\\(>>=\\)"                   #Xe149)
                ("\\(>>>\\)"                   #Xe14a)
                ("\\(<\\*\\)"                  #Xe14b)
                ("\\(<\\*>\\)"                 #Xe14c)
                ("\\(<|\\)"                    #Xe14d)
                ("\\(<|>\\)"                   #Xe14e)
                ("\\(<\\$\\)"                  #Xe14f)
                ("\\(<\\$>\\)"                 #Xe150)
                ("\\(<!--\\)"                  #Xe151)
                ("\\(<-\\)"                    #Xe152)
                ("\\(<--\\)"                   #Xe153)
                ("\\(<->\\)"                   #Xe154)
                ("\\(<\\+\\)"                  #Xe155)
                ("\\(<\\+>\\)"                 #Xe156)
                ("\\(<=\\)"                    #Xe157)
                ("\\(<==\\)"                   #Xe158)
                ("\\(<=>\\)"                   #Xe159)
                ("\\(<=<\\)"                   #Xe15a)
                ;;("\\(<>\\)"                    #Xe15b)
                ("[^-=]\\(<<\\)"               #Xe15c)
                ("\\(<<-\\)"                   #Xe15d)
                ("\\(<<=\\)"                   #Xe15e)
                ("\\(<<<\\)"                   #Xe15f)
                ("\\(<~\\)"                    #Xe160)
                ("\\(<~~\\)"                   #Xe161)
                ("\\(</\\)"                    #Xe162)
                ("\\(</>\\)"                   #Xe163)
                ("\\(~@\\)"                    #Xe164)
                ("\\(~-\\)"                    #Xe165)
                ("\\(~=\\)"                    #Xe166)
                ("\\(~>\\)"                    #Xe167)
                ("[^<]\\(~~\\)"                #Xe168)
                ("\\(~~>\\)"                   #Xe169)
                ("\\(%%\\)"                    #Xe16a)
                ;; ("\\(x\\)"                   #Xe16b)
                ("[^:=]\\(:\\)[^:=]"           #Xe16c)
                ("[^\\+<>]\\(\\+\\)[^\\+<>]"   #Xe16d)
                ("[^\\*/<>]\\(\\*\\)[^\\*/<>]" #Xe16f))))

    (defun add-fira-code-symbol-keywords ()
      (font-lock-add-keywords nil fira-code-font-lock-keywords-alist))

    (add-hook 'prog-mode-hook
              #'add-fira-code-symbol-keywords)))

;;(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)
;;(add-to-list 'comint-output-filter-functions 'ansi-color-process-output)

;;; ------------------------------- Mode Line -------------------------------- ;

;;(use-package nyan-mode)
;;(use-package smart-mode-line
;;  :config
;;  (setq sml/line-number-format nil)
;;  (setq sml/position-percentage-format "%p")
;;  (add-hook 'after-init-hook 'sml/setup)
;;  )

(provide 'apperance)
