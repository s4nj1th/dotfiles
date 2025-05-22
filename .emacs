(tool-bar-mode 0)
(menu-bar-mode 0)
(scroll-bar-mode 0)
(fringe-mode 0)
(global-display-line-numbers-mode 1)
(global-word-wrap-whitespace-mode 1)
(smartparens-global-mode 1)

(setq-default c-basic-offset 4)
(setq-default tab-width 4)
(setq-default indent-tabs-mode nil)

(keymap-global-set "C-x <home>" 'dashboard-open)
(keymap-global-set "C-z" 'shell)
(keymap-global-set "C-#" 'comment-or-uncomment-region)

(require 'package)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))
(package-initialize)

(set-face-attribute 'default nil :font "JetBrainsMono-11")
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes '(ewal-doom-one))
 '(custom-safe-themes
   '("7aa5eb0412ee93dfacdeb1fff906932c2fb1747b8c96063ac4d7c1dc461bc0e6" "7c340289e943a8e1fdd76152014b75a976912caaa93285d9ff9581641166221b" default))
 '(package-selected-packages
   '(magit lsp-mode rust-mode counsel smartparens swiper dashboard ligature ivy ewal-doom-themes ewal)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(mode-line ((t (:background "transparent" :box (:line-width (-1 . -1) :color "transparent" :style flat-button)))))
 '(mode-line-active ((t (:inherit mode-line :background "background" :box (:line-width (-1 . -1) :color "foreground"))))))

;; (use-package ivy
;;              :diminish
;;              :bind (("C-s" . swiper)
;;                     :map ivy-minibuffer-map
;;                     ("TAB" . ivy-alt-done)
;;                     ("RET" . ivy-alt-done)
;;                     ("C-l" . ivy-alt-done)
;;                     ("C-j" . ivy-next-line)
;;                     ("C-k" . ivy-previous-line)
;;                     ("C-w" . ivy-backward-kill-word)
;;                     :map ivy-switch-buffer-map
;;                     ("C-k" . ivy-previous-line)
;;                     ("C-l" . ivy-one)
;;                     ("C-d" . ivy-switch-buffer-kill)
;;                     :map ivy-reverse-i-search-map
;;                     ("C-k" . ivy-previous-line)
;;                     ("C-d" . ivy-reverse-i-search-kill))
;;              :config
;;              (setq ivy-initial-inputs-alist nil)
;;              (setq case-fold-search t)
;;              (ivy-mode))

(use-package ligature
  :config
  (ligature-set-ligatures 't '("www"))
  (ligature-set-ligatures 'eww-mode '("ff" "fi" "ffi"))
  (ligature-set-ligatures 'prog-mode '("|||>" "<|||" "<==>" "<!--" "####" "~~>" "***" "||=" "||>"
                                       ":::" "::=" "=:=" "===" "==>" "=!=" "=>>" "=<<" "=/=" "!=="
                                       "!!." ">=>" ">>=" ">>>" ">>-" ">->" "->>" "-->" "---" "-<<"
                                       "<~~" "<~>" "<*>" "<||" "<|>" "<$>" "<==" "<=>" "<=<" "<->"
                                       "<--" "<-<" "<<=" "<<-" "<<<" "<+>" "</>" "###" "#_(" "..<"
                                       "..." "+++" "/==" "///" "_|_" "www" "&&" "^=" "~~" "~@" "~="
                                       "~>" "~-" "**" "*>" "*/" "||" "|}" "|]" "|=" "|>" "|-" "{|"
                                       "[|" "]#" "::" ":=" ":>" ":<" "$>" "==" "=>" "!=" "!!" ">:"
                                       ">=" ">>" ">-" "-~" "-|" "->" "--" "-<" "<~" "<*" "<|" "<:"
                                       "<$" "<=" "<>" "<-" "<<" "<+" "</" "#{" "#[" "#:" "#=" "#!"
                                       "##" "#(" "#?" "#_" "%%" ".=" ".-" ".." ".?" "+>" "++" "?:"
                                       "?=" "?." "??" ";;" "/*" "/=" "/>" "//" "__" "~~" "(*" "*)"
                                       "\\\\" "://"))
  (global-ligature-mode t))

(use-package dashboard
	:ensure t
	:config
	(dashboard-setup-startup-hook)
	(setq dashboard-center-content t)
	(setq dashboard-banner-logo-title "Hello, s4nj1th.")
	(setq dashboard-startup-banner '("~/.emacs.d/avatar.png" . "~/.emacs.d/avatar.txt"))
	;(setq dashboard-show-shortcuts nil)
	(setq inhibit-startup-screen t)
)
