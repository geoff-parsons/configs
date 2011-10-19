;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Changes to the UI
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Don't show a splash
(setq inhibit-splash-screen t)

;; Turn off the menu bar
(menu-bar-mode -1)

;; Show column numbers
(column-number-mode 1)

;; Enable line numbering globally
(line-number-mode 1)
(global-linum-mode 1)
(setq linum-format "%d  ") ; throw a bit of padding on there

;; Enable line highlighting
(global-hl-line-mode 1)

;; Visible bell
(setq visible-bell t)

;; Show date & time
(setq display-time-day-and-date 'true)
(display-time)
