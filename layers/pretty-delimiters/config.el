(flet ((make-unmatched-delimiter-face
        (&rest faces)
        "Sets up face(s) as an unmatched delimiter face - takes a symbol as arg"
        (mapcar
         (lambda (face) (face-spec-set face
                                       '((t :foreground "#ff0000"
                                            :background "#8b0000"))))
         faces)))

  (with-eval-after-load 'rainbow-delimiters
    (setq rainbow-delimiters-max-face-count 8)
    ;;more rainbow-ey rainbow delimiters. they cycle around the
    ;;color wheel approximatly every three colors with a bit of offset. 256 color
    ;;term compatable
    (set-face-foreground 'rainbow-delimiters-depth-1-face "#5fd7ff")
    (set-face-foreground 'rainbow-delimiters-depth-2-face "#ffaf00")
    (set-face-foreground 'rainbow-delimiters-depth-3-face "#d75fff")
    (set-face-foreground 'rainbow-delimiters-depth-4-face "#87ff00")
    (set-face-foreground 'rainbow-delimiters-depth-5-face "#ff5f00")
    (set-face-foreground 'rainbow-delimiters-depth-6-face "#0087ff")
    (set-face-foreground 'rainbow-delimiters-depth-7-face "#ffff00")
    (set-face-foreground 'rainbow-delimiters-depth-8-face "#ff87ff")

    (make-unmatched-delimiter-face 'rainbow-delimiters-mismatched-face
                                   'rainbow-delimiters-unmatched-face)
    (add-hook 'latex-mode-hook #'rainbow-delimiters-mode)
    (add-hook 'prog-mode-hook #'rainbow-delimiters-mode))

  (with-eval-after-load 'smartparens
    ;; Force reset smartparens faces to defer to rainbow-delimiters
    (mapcar (lambda (face)
              (set-face-foreground face nil))
            (list 'sp-show-pair-match-face
                  'sp-wrap-overlay-closing-pair
                  'sp-wrap-overlay-opening-pair
                  'sp-pair-overlay-face
                  'sp-show-pair-enclosing))
    ;; Highlight unmatching pairs reeeaaal red
    (make-unmatched-delimiter-face 'show-paren-mismatch
                                   'sp-show-pair-mismatch-face))

  ;; Disable highlighting of faces surrounding current cursor
  ;; Spacemacs relies on `highlight-parentheses-mode' to do this,
  ;; which is kinda screwy and doesn't use faces.
  ;;
  ;; Personally I think it'd be nice if this actually used faces so I could just
  ;; set it to bold the surrounding, but nooooo
  (setq dotspacemacs-highlight-delimiters nil))
