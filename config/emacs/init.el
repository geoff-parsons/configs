;;osx path shenanigans. needed for el-get to find brew-managed git
(when (equal system-type 'darwin)
  (setenv "PATH" (concat "/usr/local/bin:" (getenv "PATH")))
  (push "/usr/local/bin" exec-path))

(defun load-file-if-exists (path)
  (if (file-exists-p path)
      (load-file path)))

(add-to-list 'load-path "~/.emacs.d/custom/")


;;
;; init el-get, installing if necessary
;;

(add-to-list 'load-path "~/.emacs.d/el-get/el-get")

(unless (require 'el-get nil t)
  (url-retrieve
   "https://raw.github.com/dimitri/el-get/master/el-get-install.el"
   (lambda (s)
     (end-of-buffer)
     (eval-print-last-sexp))))

(require 'cl)
(require 'el-get)


;;
;; packages
;;

(let ((buffer (url-retrieve-synchronously
	       "http://tromey.com/elpa/package-install.el")))
 (save-excursion
   (set-buffer buffer)
   (goto-char (point-min))
   (re-search-forward "^$" nil 'move)
   (eval-region (point) (point-max))
   (kill-buffer (current-buffer))))

(require 'package)
(dolist (archive '(("marmalade" . "http://marmalade-repo.org/packages/")
                   ("tailrecursion" . "http://tailrecursion.com/~alan/repo/emacs/")
                   ("elpa" . "http://tromey.com/elpa/")))
  (add-to-list 'package-archives archive))
(package-initialize)

;; local sources
(setq el-get-sources
      '((:name fuzzy-format
               :after (lambda ()
                        (require 'fuzzy-format)
                        (setq fuzzy-format-default-indent-tabs-mode nil)
                        (global-fuzzy-format-mode t)))

        (:name highlight-symbol
               :after (lambda ()
                        (highlight-symbol-mode 1)))

        (:name paredit
               :after (lambda ()
                        (let ((paredit-modes '(clojure
                                               emacs-lisp
                                               lisp
                                               lisp-interaction
                                               ielm)))
                          (dolist (mode paredit-modes)
                            (add-hook (intern (concat (symbol-name mode) "-mode-hook"))
                                      (lambda () (paredit-mode +1)))))

                        ;; a binding that works in the terminal
                        (define-key paredit-mode-map (kbd "M-)") 'paredit-forward-slurp-sexp)))
        (:name find-file-in-project
               :type git
               :url "git://github.com/dburger/find-file-in-project.git"
               :after (lambda ()

                        ;; We don't care about no stinkin' patterns!
                        (setq ffip-patterns '("*"))

                        ;; Do not cache by default.
                        (setq ffip-use-project-cache nil)

                        (defun ffip-toggle-use-project-cache ()
                          "Toggles project file caching for find-file-in-project.el."
                          (interactive)
                          (setq ffip-use-project-cache (not ffip-use-project-cache))
                          (message (concat "Project caching "
                                           (if ffip-use-project-cache
                                               "enabled."
                                             "disabled."))))

                        ;; C-x M-f everywhere, Cmd-T on Mac GUI
                        ;; Shift-(key) to toggle project caching
                        (global-set-key (kbd "C-x M-f") 'find-file-in-project)
                        (global-set-key (kbd "C-x M-F") 'ffip-toggle-use-project-cache)
                        (when (and (eq system-type 'darwin)
                                   window-system)
                          (global-set-key (kbd "s-t") 'find-file-in-project)
                          (global-set-key (kbd "s-T") 'ffip-toggle-use-project-cache))))
						(:name color-theme-miami-vice
							       :type http
							       :url "https://raw.github.com/gist/a1289458f4cc5becab8e/ff4123b5c333c3e16e4af3012446766ecb45fa6b/color-theme-miami-vice.el"
							       :after (lambda ()
									(load "color-theme-miami-vice")
									(color-theme-miami-vice)))))

(setq my-packages
      (append
       '(el-get
		auto-complete
	    coffee-mode
        color-theme
        haml-mode
        highlight-parentheses
        hl-sexp
        markdown-mode
        org-mode
        ruby-block
        ruby-end
        ruby-mode
		rvm
        sass-mode
		scss-mode
        textile-mode
        yaml-mode)
       (mapcar 'el-get-source-name el-get-sources)))

(el-get 'sync my-packages)


(let ((user-custom-file "~/.emacs.d/custom.el"))
  (if (not (file-exists-p user-custom-file))
      (shell-command (concat "touch " user-custom-file)))
  (setq custom-file user-custom-file)
  (load custom-file))


;; Load other configs
(load "~/.emacs.d/custom/ui.el")
(load "~/.emacs.d/custom/editing.el")
