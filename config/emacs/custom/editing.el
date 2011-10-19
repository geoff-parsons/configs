;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Editing behavior
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'uniquify)
(require 'ansi-color)

;; Don't allow tabs to be inserted
(setq-default insert-tabs-mode nil)

(require 'ido)
(ido-mode t)

(defun recentf-ido-find-file ()
  "Find a recent file using ido.
   From Phil Hagelberg's emacs-starter-kit."
  (interactive)
  (let ((file (ido-completing-read "Choose recent file: " recentf-list nil t)))
    (when file
      (find-file file))))

(global-set-key (kbd "C-x f") 'recentf-ido-find-file)