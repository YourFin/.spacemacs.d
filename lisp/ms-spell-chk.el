;;; ms-spell-chk.el --- Custom hydra explicitly for the purpose of spellchecking ala ms word  -*- lexical-binding: t; -*-

;; Copyright (C) 2017  

;; Author:  <pen@firecakes>
;; Keywords: convenience

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; 

;;; Code:

(require 'hydra)
(require 'flyspell)
(use-package wcheck)

(defhydra hydra-spell-binds
  (:pre (progn (unless flyspell-mode
		 (flyspell-mode)
		 (flyspell-buffer))
;	       (unless
;		   (or flycheck-mode
;		       (not (derived-mode-p 'prog-mode)))
;		 (flycheck-mode)
;		 (flycheck-buffer))
	       ))
  "Dedicated spell-checking hydra"
  ("n" flyspell-next-error "Next spelling error")
  ("N" flyspell-previ))


(provide 'ms-spell-chk)
;;; ms-spell-chk.el ends here
