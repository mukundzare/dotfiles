;;Initialize packages sources
(require 'package)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")
                         ("elpa" . "https://elpa.gnu.org/packages/")
                         ("melpa-stable" . "https://stable.melpa.org/packages/")))

(add-to-list 'package-pinned-packages '(cider . "melpa-stable") t)
(add-to-list 'package-pinned-packages '(magit . "melpa-stable") t)

(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)

(setq use-package-always-ensure t)
  ;;Straight.el
(defvar bootstrap-version)
(let ((bootstrap-file
     (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
    (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
  (with-current-buffer
      (url-retrieve-synchronously
       "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
       'silent 'inhibit-cookies)
    (goto-char (point-max))
    (eval-print-last-sexp)))
(load bootstrap-file nil 'nomessage))
(setq package-enable-at-startup nil)

(setq inhibit-startup-message t) ;Disable initial splash screen
  
  (scroll-bar-mode -1)    ;Disable visible scrollbar
  (tool-bar-mode -1)      ;Disable the toolbar
  (tooltip-mode -1)       ;Disable tooltips
  (set-fringe-mode 10)    ;More breathing room
  
  (menu-bar-mode -1)      ;Disable menubar
  
  ;;Enable visible bell
  (setq visible-bell t)
  
  (column-number-mode)
  (global-display-line-numbers-mode t)
  
  ;;Disable line numbers for some modes
  (dolist (mode '(org-mode-hook
                  term-mode-hook
                  shell-mode-hook
                  eshell-mode-hook))
    (add-hook mode (lambda () (display-line-numbers-mode 0))))
  
  ;; Start emacs in fullscreen mode
  (add-to-list 'default-frame-alist '(fullscreen . maximized))
  
  ;;Show dashboard
(use-package dashboard
  :ensure t
  :config
  (dashboard-setup-startup-hook))

;;Set default font
(set-face-attribute 'default nil
     :family "Fira Code"
     ;;:family "Jetbrains Mono"
     ;:family "JetBrains Mono NL"
     ;;:family "clearlyu"
     :height 102
     :weight 'normal
     :width 'expanded)

;; Set the fixed pitch face
(set-face-attribute 'fixed-pitch nil
		    ;;:font "Jetbrains Mono"
		    :font "Fira Code"
		    :height 100)

;; Set the variable pitch face
(set-face-attribute 'variable-pitch nil
		    :font "Cantarell"
		    :height 120
		    :weight 'regular)

;;Make ESC quit prompts
  (global-set-key (kbd "<escape>") 'keyboard-escape-quit)
  
  ;;Electric return key
  (define-key global-map (kbd "RET") 'newline-and-indent)
  
  (use-package general
    :config
    (general-create-definer mzare/leader-keys
      :keymaps '(normal insert visual emacs)
      :prefix "SPC"
      :global-prefix "C-SPC")
  
    (mzare/leader-keys
     "t" '(:ignore t :which-key "toggles")
     "tt" '(counsel-load-theme :which-key "choose theme")
     "s" '(ace-swap-window :which-key "swap windows")))
  
  ;;Download Evil
  (use-package evil
    :init
    (setq evil-want-integration t)
    (setq evil-want-keybinding nil)
    (setq evil-want-C-u-scroll t)
    (setq evil-want-C-i-jump t)
    :config
    (evil-mode 1))
  
  
  (use-package evil-collection
    :after evil
    :config
    (evil-collection-init))
;; Use evil keybindings in org-mode  
  (use-package evil-org
  :ensure t
  :after org
  :hook (org-mode . (lambda () evil-org-mode))
  :config
  (require 'evil-org-agenda)
  (evil-org-agenda-set-keys))

  (use-package hydra)
  
  (defhydra hydra-text-scale (:timeout 4)
    "scale text"
    ("j" text-scale-increase "in")
    ("k" text-scale-decrease "out")
    ("f" nil "finished" :exit t))
  
  
  (mzare/leader-keys
   "ts" '(hydra-text-scale/body :which-key "scale text"))

;; Ivy
(use-package ivy
  :diminish
  :bind (("C-s" . swiper)
	 :map ivy-minibuffer-map
	 ("TAB" . ivy-alt-done)
	 ("C-l" . ivy-alt-done)
	 ("C-j" . ivy-next-line)
	 ("C-k" . ivy-previous-line)
	 :map ivy-switch-buffer-map
	 ("C-k" . ivy-previous-line)
	 ("C-l" . ivy-done)
	 ("C-d" . ivy-switch-buffer-kill)
	 :map ivy-reverse-i-search-map
	 ("C-k" . ivy-previous-line)
	 ("C-d" . ivy-reverse-i-search-kill))
  :config
  (ivy-mode 1))

;; Ivy-rich 
(use-package ivy-rich
  :init
  (ivy-rich-mode 1))

(use-package all-the-icons-ivy-rich
    :ensure t
    :init (all-the-icons-ivy-rich-mode 1)
    :config 
    ;; Whether display the colorful icons.
    ;; It respects `all-the-icons-color-icons'.
    (setq all-the-icons-ivy-rich-color-icon t)

    ;; The icon size
    (setq all-the-icons-ivy-rich-icon-size 1.0)

    ;; Whether support project root
    (setq all-the-icons-ivy-rich-project t))

;; Counsel
(use-package counsel
  :bind (("M-x" . counsel-M-x)
	 ("C-x b" . counsel-ibuffer)
	 ("C-x C-f" . counsel-find-file)
	 ("C-c C-f" . counsel-fzf)
         :map minibuffer-local-map
         ("C-r" . 'counsel-minibuffer-history))
  :config
  (setq ivy-initial-inputs-alist nil)) ;;Don't start searches with ^

(use-package all-the-icons)
  
  (use-package doom-modeline
    :ensure t
    :init (doom-modeline-mode 1))

;;Display time and date in modeline
(display-time)
  (setq display-time-day-and-date t)

;;Install kaolin-themes
(use-package kaolin-themes)

;;Install doom-themes
(use-package doom-themes
  :init (load-theme 'doom-Iosvkem t))

;;Sets up the working buffer to be darker than
;;rest of the buffers
(solaire-global-mode +1)

;;Parentheses are color-coded
(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 0.2))

(use-package helpful
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . counsel-describe-variable)
  ([remap describe-key] . helpful-key))

;;To be worked on 
;;TODO Setup key-bindings
(global-origami-mode t)
(setq evil-collection-magit-use-z-for-folds t)

;;Use the current frame for ediff
(setq ediff-window-setup-function 'ediff-setup-windows-plain)

(use-package find-file-in-project
    :config (setq ffip-use-rust-fd t))

;;Switch windows numbered from 1 to n depending on number of windows
;;Doesn't work with treemacs. To switch to treemacs buffer, press <M-0>
(use-package ace-window)
(global-set-key (kbd "M-o") 'ace-window)

;;aw-keys - the list of initial characters used in window labels:
(setq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l))

;; edit html tags like sexps
(use-package tagedit)

(use-package paredit)

;;Enable paredit automatically
(autoload 'enable-paredit-mode "paredit" "Turn on pseudo-structural editing of lisp code" t) 
(add-hook 'clojure-mode 'enable-paredit-mode)
(add-hook 'clojurescript-mode 'enable-paredit-mode)

;; key bindings and code colorization for Clojure
;; https://github.com/clojure-emacs/clojure-mode
(use-package clojure-mode)

;; extra syntax highlighting for clojure
(use-package clojure-mode-extra-font-locking)

;; integration with a Clojure REPL
;; https://github.com/clojure-emacs/cider
(use-package cider)

(use-package csv)

(use-package yaml-mode)

(use-package json-mode)

;;Set major mode for OJS and PJS files to javascript mode
(add-to-list 'auto-mode-alist '("\\.ojs" . javascript-mode))
(add-to-list 'auto-mode-alist '("\\.pjs" . javascript-mode))

(use-package ido-completing-read+)

(use-package company
    :ensure t
    :hook global-company-mode)

(use-package projectile
  :diminish projectile-mode
  :config (projectile-mode)
  :custom ((projectile-completion-system 'ivy)) :bind-keymap
  ("C-c p" . projectile-command-map)
  :init
  (when (file-directory-p "~/")
    (setq projectile-project-search-path '("~/")))
  (setq projectile-switch-project-action #'projectile-dired))

(use-package counsel-projectile
  :config (counsel-projectile-mode))
(use-package projectile-ripgrep)

;; magit
(use-package magit)

;;Expand region package for incremental selection of region
  (use-package expand-region
    :bind ("C-=" . er/expand-region))
  
  ;;Smart parens
  (use-package smartparens)
  ;;Multiple cursors

(use-package multiple-cursors)

(use-package treemacs
  :ensure t
  :defer t
  :init
  (with-eval-after-load 'winum
    (define-key winum-keymap (kbd "M-0") #'treemacs-select-window))
  :config
  (progn
    (setq treemacs-collapse-dirs                 (if treemacs-python-executable 3 0)
          treemacs-deferred-git-apply-delay      0.5
          treemacs-directory-name-transformer    #'identity
          treemacs-display-in-side-window        t
          treemacs-eldoc-display                 t
          treemacs-file-event-delay              1000
          treemacs-file-extension-regex          treemacs-last-period-regex-value
          treemacs-file-follow-delay             0.2
          treemacs-file-name-transformer         #'identity
          treemacs-follow-after-init             t
          treemacs-expand-after-init             t
          treemacs-git-command-pipe              ""
          treemacs-goto-tag-strategy             'refetch-index
          treemacs-indentation                   2
          treemacs-indentation-string            " "
          treemacs-is-never-other-window         nil
          treemacs-max-git-entries               5000
          treemacs-missing-project-action        'ask
          treemacs-move-forward-on-expand        nil
          treemacs-no-png-images                 nil
          treemacs-no-delete-other-windows       t
          treemacs-project-follow-cleanup        nil
          treemacs-persist-file                  (expand-file-name ".cache/treemacs-persist" user-emacs-directory)
          treemacs-position                      'left
          treemacs-read-string-input             'from-child-frame
          treemacs-recenter-distance             0.1
          treemacs-recenter-after-file-follow    nil
          treemacs-recenter-after-tag-follow     nil
          treemacs-recenter-after-project-jump   'always
          treemacs-recenter-after-project-expand 'on-distance
          treemacs-litter-directories            '("/node_modules" "/.venv" "/.cask")
          treemacs-show-cursor                   nil
          treemacs-show-hidden-files             t
          treemacs-silent-filewatch              nil
          treemacs-silent-refresh                nil
          treemacs-sorting                       'alphabetic-asc
          treemacs-space-between-root-nodes      t
          treemacs-tag-follow-cleanup            t
          treemacs-tag-follow-delay              1
          treemacs-user-mode-line-format         nil
          treemacs-user-header-line-format       nil
          treemacs-width                         35
          treemacs-width-is-initially-locked     t
          treemacs-workspace-switch-cleanup      nil)

    ;; The default width and height of the icons is 22 pixels. If you are
    ;; using a Hi-DPI display, uncomment this to double the icon size.
   ;;(treemacs-resize-icons 44)

    (treemacs-follow-mode t)
    (treemacs-filewatch-mode t)
    (treemacs-fringe-indicator-mode 'always)
    (pcase (cons (not (null (executable-find "git")))
                 (not (null treemacs-python-executable)))
      (`(t . t)
       (treemacs-git-mode 'deferred))
      (`(t . _)
       (treemacs-git-mode 'simple))))
  :bind
  (:map global-map
        ("M-0"       . treemacs-select-window)
        ("C-x t 1"   . treemacs-delete-other-windows)
        ("C-x t t"   . treemacs)
        ("C-x t B"   . treemacs-bookmark)
        ("C-x t C-t" . treemacs-find-file)
        ("C-x t M-t" . treemacs-find-tag)))

(use-package treemacs-evil
  :after (treemacs evil)
  :ensure t)

(use-package treemacs-projectile
  :after (treemacs projectile)
  :ensure t)

(use-package treemacs-all-the-icons
    :config (treemacs-load-theme "all-the-icons"))

(use-package treemacs-icons-dired
  :after (treemacs dired)
  :ensure t
  :config (treemacs-icons-dired-mode))

(use-package treemacs-magit
  :after (treemacs magit)
  :ensure t)

(use-package treemacs-persp ;;treemacs-perspective if you use perspective.el vs. persp-mode
  :after (treemacs persp-mode) ;;or perspective vs. persp-mode
  :ensure t
  :config (treemacs-set-scope-type 'Perspectives))


(treemacs-define-custom-image-icon "/usr/share/icons/planisware_v1.png" "ojs")
(treemacs-define-custom-image-icon "/usr/share/icons/planisware_v2.png" "pjs")

;;Use the $PATH variable from the zsh shell

(defun set-exec-path-from-shell-PATH ()
"Set up Emacs' `exec-path' and PATH environment variable to match
that used by the user's shell.

This is particularly useful under Mac OS X and macOS, where GUI
apps are not started from a shell."
(interactive)
(let ((path-from-shell (replace-regexp-in-string
                        "[ \t\n]*$" "" (shell-command-to-string
                                        "$SHELL --login -c 'echo $PATH'"
                                                ))))
(setenv "PATH" path-from-shell)
(setq exec-path (split-string path-from-shell path-separator))))

(set-exec-path-from-shell-PATH)

(when (memq window-system '(mac ns x))
(exec-path-from-shell-initialize))

(defun mzare/org-mode-setup ()
  (org-indent-mode)
  (variable-pitch-mode 1)
  (visual-line-mode 1)
  (setq evil-auto-indent nil))


(defun mzare/org-mode-visual-fill ()
  (setq visual-fill-column-width 150
        visual-fill-column-center-text t)
  (visual-fill-column-mode 1))
(use-package visual-fill-column
  :hook (org-mode . mzare/org-mode-visual-fill))

(defun mzare/org-font-setup ()
  ;; Replace list hyphen with dot
  (font-lock-add-keywords 'org-mode
                          '(("^ *\\([-]\\) "
                             (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))
  ;; Set faces for heading levels
  (with-eval-after-load 'org-faces
    (dolist (face '((org-level-1 . 1.2)
                  (org-level-2 . 1.1)
                  (org-level-3 . 1.05)
                  (org-level-4 . 1.0)
                  (org-level-5 . 1.1)
                  (org-level-6 . 1.1)
                  (org-level-7 . 1.1)
                  (org-level-8 . 1.1)))
    (set-face-attribute (car face) nil :font "Cantarell" :weight 'regular :height (cdr face)))
  ;; Ensure that anything that should be fixed-pitch in Org files appears that way
  (set-face-attribute 'org-block nil :foreground nil :inherit 'fixed-pitch)
  (set-face-attribute 'org-code nil   :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-table nil   :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-verbatim nil :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-special-keyword nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-meta-line nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-checkbox nil :inherit 'fixed-pitch)))

(use-package org-bullets
  :after org
  :hook (org-mode . org-bullets-mode)
  :custom
  (org-bullets-bullet-list '("◉" "○" "●" "○" "●" "○" "●")))

(use-package org
  :hook (org-mode . mzare/org-mode-setup)
  :config
  (setq org-ellipsis " ▾")

  (setq org-agenda-start-with-log-mode t)
  (setq org-log-done 'time)
  (setq org-log-into-drawer t)

  (setq org-agenda-files
	'("~/.orgfiles/myorg.org"
	"~/.orgfiles/work_diary.org"
	"~/.orgfiles/someday.org"
	"~/.orgfiles/emacs-todo.org"))

  (require 'org-habit)

  (add-to-list 'org-modules 'org-habit)
  (setq org-habit-graph-column 60)

  (setq org-todo-keywords
    '((sequence "TODO(t)" "NEXT(n)" "ON_HOLD(h)" "|" "DONE(d!)")
      (sequence "BACKLOG(b)" "PLAN(p)" "READY(r)" "ACTIVE(a)" "REVIEW(v)" "WAIT(w@/!)" "HOLD(h)" "|" "COMPLETED(c)" "CANC(k@)")))

  (setq org-refile-targets
	'(("~/.orgfiles/ARCHIVE/Archive.org" :maxlevel . 1)
	  ("~/.orgfiles/someday.org" :maxlevel . 1)
	  ("~/.orgfiles/ARCHIVE/Tasks.org" :maxlevel . 1)))

  ;; Save Org buffers after refiling!
  (advice-add 'org-refile :after 'org-save-all-org-buffers)
  
  (setq org-tag-alist
    '((:startgroup)
       ; Put mutually exclusive tags here
       (:endgroup)
       ("@errand" . ?E)
       ("phone". ?c)
       ("learn" . ?l)
       ("@home" . ?H)
       ("@work" . ?W)
       ("agenda" . ?a)
       ("family" . ?n)
       ("planning" . ?p)
       ("recurring" . ?r)
       ("idea" . ?i)))

  ;; Configure custom agenda views
  (setq org-agenda-custom-commands
   '(("d" "Dashboard"
     ((agenda "" ((org-deadline-warning-days 7)))
      (todo "NEXT"
        ((org-agenda-overriding-header "Next Tasks")))
      (tags-todo "agenda/ACTIVE" ((org-agenda-overriding-header "Active Projects")))))
    ("n" "Next Tasks"
     ((todo "NEXT"
        ((org-agenda-overriding-header "Next Tasks")))))
    ("W" "Work Tasks" tags-todo "+work-email")
    ;; Low-effort next actions
    ("e" tags-todo "+TODO=\"NEXT\"+Effort<15&+Effort>0"
     ((org-agenda-overriding-header "Low Effort Tasks")
      (org-agenda-max-todos 20)
      (org-agenda-files org-agenda-files)))

    ("w" "Workflow Status"
     ((todo "WAIT"
            ((org-agenda-overriding-header "Waiting on External")
             (org-agenda-files org-agenda-files)))
      (todo "REVIEW"
            ((org-agenda-overriding-header "In Review")
             (org-agenda-files org-agenda-files)))
      (todo "PLAN"
            ((org-agenda-overriding-header "In Planning")
             (org-agenda-todo-list-sublevels nil)
             (org-agenda-files org-agenda-files)))
      (todo "BACKLOG"
            ((org-agenda-overriding-header "Project Backlog")
             (org-agenda-todo-list-sublevels nil)
             (org-agenda-files org-agenda-files)))

      (todo "READY"
            ((org-agenda-overriding-header "Ready for Work")
             (org-agenda-files org-agenda-files)))
      (todo "ACTIVE"
            ((org-agenda-overriding-header "Active Projects")
             (org-agenda-files org-agenda-files)))
      (todo "COMPLETED"
            ((org-agenda-overriding-header "Completed Projects")
             (org-agenda-files org-agenda-files)))
      (todo "CANC"
            ((org-agenda-overriding-header "Cancelled Projects")
             (org-agenda-files org-agenda-files)))))))

  (setq org-capture-templates
    `(("t" "Tasks / Projects")
      ("tt" "Task" entry (file+olp "~/.orgfiles/myorg.org" "Inbox")
           "* TODO %?\n  %U\n  %a\n  %i" :empty-lines 1)
      ("j" "Journal Entries")
      ("jj" "Journal" entry
           (file+olp+datetree "~/.orgfiles/Journal.org")
           "\n* %<%I:%M %p> - Journal :journal:\n\n%?\n\n"
           ;; ,(dw/read-file-as-string "~/Notes/Templates/Daily.org")
           :clock-in :clock-resume
           :empty-lines 1)
      ("jm" "Meeting" entry
           (file+olp+datetree "~/.orgfiles/Journal.org")
           "* %<%I:%M %p> - %a :meetings:\n\n%?\n\n"
           :clock-in :clock-resume
           :empty-lines 1)
      ("w" "Workflows")
      ("we" "Checking Email" entry (file+olp+datetree "~/.orgfiles/Journal.org")
           "* Checking Email :email:\n\n%?" :clock-in :clock-resume :empty-lines 1)
      ("m" "Metrics Capture")
      ("mw" "Weight" table-line (file+headline "~/.orgfiles/Metrics.org" "Weight")
       "| %U | %^{Weight} | %^{Notes} |" :kill-buffer t)
      ("o" "Office")
      ("oo" "Task" entry (file+olp "~/.orgfiles/work_diary.org" "Inbox")
       "* TODO %?\n  %U\n  %a\n  %i" :empty-lines 1)))

  (require 'org-tempo)

  (add-to-list 'org-structure-template-alist '("sh" . "src shell"))
  (add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))
  (add-to-list 'org-structure-template-alist '("js" . "src js"))

  (define-key global-map (kbd "C-c j")
    (lambda () (interactive) (org-capture nil "jj")))
  (define-key global-map (kbd "C-c c") 'org-capture)
  (define-key global-map (kbd "C-c a") 'org-agenda)
   
  (mzare/org-font-setup))

;; Org drill is a package for flashcards in org-mode
(use-package org-drill)

(org-babel-do-load-languages 
'org-babel-load-languages
'((emacs-lisp . t )
  (js . t)))

;;Automatically tangle the config.org file when we save it
(defun efs/org-babel-tangle-config ()
    (when (string-equal (buffer-file-name)
                        (expand-file-name "~/dotfiles/config.org"))
        ;; Dynamic scoping to the rescue
        (let ((org-confirm-babel-evaluate nil))
        (org-babel-tangle))))

(add-hook 'org-mode-hook (lambda () (add-hook 'after-save-hook #'efs/org-babel-tangle-config)))

;; Use org-roam
  (use-package org-roam
    :ensure t
    :init
    (setq org-roam-v2-ack t)
    :custom
    (org-roam-directory "~/RoamNotes")
    (org-roam-completion-everywhere t)
    :bind (("C-c n l" . org-roam-buffer-toggle)
           ("C-c n f" . org-roam-node-find)
           ("C-c n i" . org-roam-node-insert)
           :map org-mode-map
           ("C-M-i" . completion-at-point))
    :config
    (org-roam-setup))
  
  ;;Org-roam v2 UI
(use-package org-roam-ui
    :straight
    (:host github :repo "org-roam/org-roam-ui" :branch "main" :files ("*.el" "out"))
    :after org-roam
    :hook (after-init . org-roam-ui-mode)
    :config
    (setq org-roam-ui-sync-theme t
          org-roam-ui-follow t
          org-roam-ui-update-on-save t
          org-roam-ui-open-on-start t))

(use-package undo-tree
    :ensure t
    :config
    (global-undo-tree-mode))

(use-package restclient)
