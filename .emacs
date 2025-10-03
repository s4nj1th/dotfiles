(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(fringe-mode '(1 . 1))

(global-display-line-numbers-mode 1)
(global-visual-line-mode 1)

(setq-default c-basic-offset 4
              tab-width 4
              indent-tabs-mode nil)

(keymap-global-set "C-x <home>" #'dashboard-open)
(keymap-global-set "C-z" #'shell)
(keymap-global-set "C-#" #'comment-or-uncomment-region)

(require 'package)
(setq package-archives
      '(("melpa" . "https://melpa.org/packages/")
        ("gnu"   . "https://elpa.gnu.org/packages/")))
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))

(setq use-package-always-ensure t)

(set-face-attribute 'default nil :font "Liga SFMono Nerd Font-11")

(use-package ewal-doom-themes
  :init (load-theme 'ewal-doom-one t))

(use-package ligature :config (ligature-set-ligatures 't '("www")) (ligature-set-ligatures 'eww-mode '("ff" "fi" "ffi")) (ligature-set-ligatures 'prog-mode '("|||>" "<|||" "<==>" "<!--" "####" "~~>" "***" "||=" "||>" ":::" "::=" "=:=" "===" "==>" "=!=" "=>>" "=<<" "=/=" "!==" "!!." ">=>" ">>=" ">>>" ">>-" ">->" "->>" "-->" "---" "-<<" "<~~" "<~>" "<*>" "<||" "<|>" "<$>" "<==" "<=>" "<=<" "<->" "<--" "<-<" "<<=" "<<-" "<<<" "<+>" "</>" "###" "#_(" "..<" "..." "+++" "/==" "///" "_|_" "www" "&&" "^=" "~~" "~@" "~=" "~>" "~-" "**" "*>" "*/" "||" "|}" "|]" "|=" "|>" "|-" "{|" "[|" "]#" "::" ":=" ":>" ":<" "$>" "==" "=>" "!=" "!!" ">:" ">=" ">>" ">-" "-~" "-|" "->" "--" "-<" "<~" "<*" "<|" "<:" "<$" "<=" "<>" "<-" "<<" "<+" "</" "#{" "#[" "#:" "#=" "#!" "##" "#(" "#?" "#_" "%%" ".=" ".-" ".." ".?" "+>" "++" "?:" "?=" "?." "??" ";;" "/*" "/=" "/>" "//" "__" "~~" "(*" "*)" "\\\\" "://")) (global-ligature-mode t))

(use-package dashboard
  :config
  (dashboard-setup-startup-hook)
  (setq dashboard-center-content t
        dashboard-banner-logo-title "Hello, s4nj1th."
        dashboard-startup-banner '("~/.emacs.d/avatar.png" . "~/.emacs.d/avatar.txt")
        inhibit-startup-screen t))

(use-package ivy
  :diminish
  :bind (("C-s" . swiper)
         :map ivy-minibuffer-map
         ("TAB" . ivy-alt-done)
         ("RET" . ivy-alt-done)
         ("C-l" . ivy-alt-done)
         ("C-j" . ivy-next-line)
         ("C-k" . ivy-previous-line))
  :config
  (setq ivy-initial-inputs-alist nil
        case-fold-search t)
  (ivy-mode 1))

(use-package counsel :after ivy)
(use-package swiper :after ivy)
(custom-set-variables
 '(custom-enabled-themes '(doom-ayu-dark))
 '(custom-safe-themes
   '("9b9d7a851a8e26f294e778e02c8df25c8a3b15170e6f9fd6965ac5f2544ef2a9"
     default))
 '(package-selected-packages nil))
(custom-set-faces
 )
