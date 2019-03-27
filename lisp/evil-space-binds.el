;;; evil-space-binds.el --- contains space-prefixed binds for evil mode  -*- lexical-binding: t; -*-

;; Copyright (C) 2018

;; Author:  <pen@firecakes>
;; Keywords: evil

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
(require 'evil)
(require 'heretic-evil-clipboard-mode)

;;;; unmap normal space
;;(define-key evil-motion-state-map " " nil)


(spacemacs/set-leader-keys "<SPC>" 'helm-smex)
;;files/buffers
(spacemacs/set-leader-keys "bb" 'save-buffer)
(spacemacs/set-leader-keys "bB" 'write-file)
(spacemacs/set-leader-keys "bs" 'yf-switch-buffer)
(spacemacs/set-leader-keys "bS" 'helm-mini)
(spacemacs/set-leader-keys "bo" 'helm-find-files)
(spacemacs/set-leader-keys "bx" 'kill-this-buffer)
(spacemacs/set-leader-keys "bX" 'kill-buffer)
(spacemacs/set-leader-keys "bl" 'evil-switch-to-windows-last-buffer)
;; Windows
(spacemacs/set-leader-keys "wx" 'evil-window-delete)
(spacemacs/set-leader-keys "wo" 'delete-other-windows)

(spacemacs/set-leader-keys "g" 'magit-status)

;; Projectile/projects
(spacemacs/set-leader-keys "pa" 'helm-projectile-ag)
(spacemacs/set-leader-keys "ps" 'helm-projectile-switch-project)

(spacemacs/set-leader-keys "ok" 'heretic-evil-helm-kill-ring)
(spacemacs/set-leader-keys "aC" 'calc-do-dispatch)
(spacemacs/set-leader-keys "ac" 'calc)

(provide 'evil-space-binds)
;;; evil-space-binds.el ends here
