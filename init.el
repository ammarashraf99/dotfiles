(setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")


(setq inhibit-startup-message t)
(scroll-bar-mode -1)		;; Disable visible scrollbar
(tool-bar-mode -1)		;; Disable the toolbar
(tooltip-mode -1)		;; Disable tooltips
(set-fringe-mode -1)		;; Give some breathing room
(menu-bar-mode -1)		;; Disable the menu bar
(blink-cursor-mode -1)
(setq tab-width 8)
(defvaralias 'c-basic-offset 'tab-width)
(defvaralias 'cperl-indent-level 'tab-width)
(setq make-pointer-invisibile t)
(setq make-backup-files nil) ; stop creating ~ files
(setq backup-directory-alist            '((".*" . "~/.Trash")))


;;;;; modeline shit ;;;;;;;;
;; minimal

;; Enable display time in modeline
(setq display-time-24hr-format t)
(setq display-time-default-load-average nil)
(display-time-mode 1)
(setq display-time-format " %a %R ")

;; Remove code action
(setq lsp-modeline-code-actions-enable nil)
(setq lsp-modeline-diagnostics-enable t)

;; Add the column number to modeline
(column-number-mode 1)

;; Remove those modes from modeline
(defun my/clean-modeline ()
  (dolist (mode '(eldoc-mode
		  projectile-mode
		  which-key-mode
		  whitespace-mode
                  auto-revert-mode
		  ivy-mode
		  evil-collection-unimpaired-mode
		  hs-minor-mode
		  lsp-lens-mode
		  yas-minor-mode
		  evil-mc-mode
                  flymake-mode))
    (setq minor-mode-alist
          (assq-delete-all mode minor-mode-alist))))
;; call it after startup
(add-hook 'emacs-startup-hook #'my/clean-modeline)
;; call it after major mode change
(add-hook 'after-change-major-mode-hook #'my/clean-modeline)

;; character count
(defun my/modeline-region-count ()
  "Return the number of characters in the active region for the modeline."
  (if (use-region-p)
      (format "   %d C" (1+ (abs (- (region-end) (region-beginning)))) )
    ""))

;; Add the function to your mode-line-format
(setq-default mode-line-format
              (append mode-line-format
                      '((:eval (my/modeline-region-count)))))




;; This saves the buffer automatically before any compile command
(advice-add 'compile :before (lambda (&rest _) (save-buffer)))

;;(global-hl-line-mode t)
;; This is to highlight the line you are on now


(setq show-paren-delay 0)
(show-paren-mode 1)

;;Fixing scroll
(setq redisplay-dont-pause t
      scroll-margin 0     ;; This number defines how many lines to scroll on
      scroll-step 1
      scroll-conservatively 10000
      scroll-preserve-screen-position 1)

;; Set up the visible bell
(setq visible-bell t)


;; Set relative number
(setq display-line-numbers-type 'relative)
(display-line-numbers-mode)

;;(column-number-mode)
(global-display-line-numbers-mode t)

;; Font and size
(set-face-attribute 'default nil :font "IosevkaNerdFont" :height 135)
;; My fav Fonts
;; UbuntuMonoNerdFont
;; HackNerdFont


;; Make ESC quit prompts
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)
(global-set-key (kbd "C-x j") 'counsel-switch-buffer)

;; Clear increase text size and decrease
(global-set-key (kbd "C-=") 'text-scale-increase)
(global-set-key (kbd "C--") 'text-scale-decrease)

;; Open treemacs in the current working directory of the current open buffer
(global-set-key (kbd "C-x C-d") 'treemacs-add-and-display-current-project-exclusively)
;; let delete other window command work on treemacs (C-w-o)
(setq treemacs-no-delete-other-windows nil)


;; Comment line function
;;this shit is good, you comment lines or regions with one command without
;;commenting the following line.
(defun my/comment-or-uncomment ()
  "Comment or uncomment current line or region exactly."
  (interactive)
  (let (beg end)
    (if (use-region-p)
        ;; Region is active: use exact region
        (setq beg (region-beginning)
              end (region-end))
      ;; No region: use the current line
      (setq beg (line-beginning-position)
            end (line-end-position)))
    (comment-or-uncomment-region beg end)))
;;the key binding for the function
(global-set-key (kbd "C-x c") 'my/comment-or-uncomment)


;; it confilicts with a binding. use spc-c to compile
;; Compile
;; (global-set-key (kbd "M-c") 'compile)

;; Revert Buffer
(global-set-key (kbd "C-x g r") 'revert-buffer-quick)

;; increment number at point
(global-set-key (kbd "C-a") 'increment-number-at-point)


(setq evil-want-keybinding nil)
(use-package evil-collection
  :after evil
  :config
  (evil-collection-init)
  )

;;; Themes shit

;; my favorite themes
;; doom-nord-creamsody=immaterial-dark=inverse-acme=kosmos=
;; labburn=mustang=doom-plain-dark=warm-night=gruber-darker
;;(set-background-color "SlateGrey")
;;(load-theme 'immaterial-dark t)

(mapc #'disable-theme custom-enabled-themes)
(load-theme 'gruber-darker t)
;; gruber-darker catppuccin darktooth-dark
;; almost-mono-gray almost-mono-black
;; nord
;; nord gruber-darker mustang
;; flatland gruber-darker zenburn gruvbox-dark-medium  subdued  twilight


;; Inixialize package sources
(require 'package)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
			 ("org" . "https://orgmode.org/elpa/")
			 ("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))


(package-install 'use-package)


(require 'use-package)
(setq use-package-always-ensure t)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;     Org Mode    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package org
  :hook (org-mode . efs/org-mode-setup) ;; shit
  :config
  (setq org-ellipsis " ▾" ;; when you hit tab to collaps a heading
	org-hide-emphasis-markers t) ;; hides ** around bold stuf and other markings

  (setq org-agenda-start-with-log-mode t)
  (setq org-log-done 'time)
  (setq org-log-into-drawer t)

  (setq org-agenda-files
	'(
	  "/home/ammar/programming/TODOs/Periodics.org"
	  "/home/ammar/programming/TODOs/Today.org"
	  "/home/ammar/programming/TODOs/Week.org"))

  ;;THIS IS HOW TO CREATE NEW TASK STATES
  (setq org-todo-keywords
	'(
	  ;; (sequence "TODO(t)" "NEXT(n)" "|" "DONE(d!)")
	  ;; (sequence "BACKLOG(b)" "PLAN(p)" "READY(n)" "ACTIVE(a)" "REVIEW(w@/!)" "HOLD(h)" "|" "completed(c)" "canc(k@)")

	  (sequence "TODO(t)" "|" "DONE(d!)")
	  (sequence "WEEKLY(w@/!)" "|" "DONE(d!)")
	  (sequence "MONTHLY(m@/!)" "|" "DONE(d!)")
	  )
	)
  )

(defun efs/org-mode-setup()
  (visual-line-mode 1)
  )

(setq org-deadline-warning-days 7)

(global-set-key (kbd "C-c l") #'org-store-link) ;; confilit with lsp-mode
(global-set-key (kbd "C-c a") #'org-agenda)
(global-set-key (kbd "C-c c") #'org-capture)


(setq org-refile-targets
      '(("Archive.org" :maxlevel . 1)
	))

(advice-add 'org-refile :after 'org-save-all-org-buffers)


(use-package org-bullets
  :after org
  :hook (org-mode . org-bullets-mode))

;; Set faces for heading levels
;;(dolist (face '((org-level-1 . 1.2)
;;               (org-level-2 . 1.1)
;;               (org-level-3 . 1.05)
;;               (org-level-4 . 1.0)
;;               (org-level-5 . 1.1)
;;               (org-level-6 . 1.1)
;;               (org-level-7 . 1.1)
;;               (org-level-8 . 1.1)))
;; (set-face-attribute (car face) nil :font "Cantarell" :weight 'regular :height (cdr face)))


(defun efs/org-mode-visual-fill ()
  (setq visual-fill-column-width 100
        visual-fill-column-center-text t)
  (visual-fill-column-mode 1))

(use-package visual-fill-column
  :hook (org-mode . efs/org-mode-visual-fill))




(use-package evil-org
  :ensure t
  :after org
  :hook (org-mode . (lambda () evil-org-mode))
  :config
  (require 'evil-org-agenda)
  (evil-org-agenda-set-keys))


;; Very good illustration on how to configure the agenda dispatcher

;;   ;; Configure custom agenda views
;; (setq org-agenda-custom-commands
;;       '(
;; 	("d" "Dashboard"
;; 	 ((agenda "" ((org-deadline-warning-days 7)))
;; 	  (todo "NEXT"
;; 		((org-agenda-overriding-header "Next Tasks")))
;; 	  (tags-todo "agenda/ACTIVE" ((org-agenda-overriding-header "Active Projects")))))

;; 	("n" "Next Tasks"
;; 	 ((todo "NEXT"
;; 		((org-agenda-overriding-header "Next Tasks")))))

;;      ;;this will let you query work tags that do not have email tags...
;; 	("W" "Work Tasks" tags-todo "+work-email")

;; 	;; Low-effort next actions
;; 	("e" tags-todo "+TODO=\"NEXT\"+Effort<15&+Effort>0"
;; 	 ((org-agenda-overriding-header "Low Effort Tasks")
;; 	  (org-agenda-max-todos 20)
;; 	  (org-agenda-files org-agenda-files)))

;; 	("w" "Workflow Status"
;; 	 ((todo "WAIT"
;; 		((org-agenda-overriding-header "Waiting on External")
;; 		 (org-agenda-files org-agenda-files)))
;; 	  (todo "REVIEW"
;; 		((org-agenda-overriding-header "In Review")
;; 		 (org-agenda-files org-agenda-files)))
;; 	  (todo "PLAN"
;; 		((org-agenda-overriding-header "In Planning")
;; 		 (org-agenda-todo-list-sublevels nil)
;; 		 (org-agenda-files org-agenda-files)))
;; 	  (todo "BACKLOG"
;; 		((org-agenda-overriding-header "Project Backlog")
;; 		 (org-agenda-todo-list-sublevels nil)
;; 		 (org-agenda-files org-agenda-files)))
;; 	  (todo "READY"
;; 		((org-agenda-overriding-header "Ready for Work")
;; 		 (org-agenda-files org-agenda-files)))
;; 	  (todo "ACTIVE"
;; 		((org-agenda-overriding-header "Active Projects")
;; 		 (org-agenda-files org-agenda-files)))
;; 	  (todo "COMPLETED"
;; 		((org-agenda-overriding-header "Completed Projects")
;; 		 (org-agenda-files org-agenda-files)))
;; 	  (todo "CANC"
;; 		((org-agenda-overriding-header "Cancelled Projects")
;; 		 (org-agenda-files org-agenda-files)))))))



(global-set-key (kbd "C-c q") #'counsel-org-tag)
;; commands for tags (counsel-org-tag, org-set-tags-command)
;; known tags
;; (setq org-tag-alist
;;       '((:startgroup)
;; 	;; Put mutually exclusive tags here
;; 	(:endgroup)
;; 	("@errand" . ?E)
;; 	("@home" . ?H)
;; 	("@work" . ?W)
;; 	("agenda" . ?a)
;; 	("planning" . ?p)
;; 	("publish" . ?P)
;; 	("batch" . ?b)
;; 	("note" . ?n)
;; 	("idea" . ?i)))



(setq org-capture-templates
      `(("t" "Tasks / Projects")
	("tt" "Task" entry (file+olp "/home/ammar/programming/TODOs/Today.org" "Inbox")
	 "* TODO %?\n  %U\n  %a\n  %i" :empty-lines 1)

	("r" "Random...")
	("rr" "Random" entry (file+olp "/home/ammar/programming/TODOs/Random.org" "Random Ideas !!")
	 "* TODO %?\n  %U\n  %a\n  %i" :empty-lines 1)

	("j" "Journal Entries")
	("jj" "Journal" entry
         (file+olp+datetree "~/Projects/Code/emacs-from-scratch/OrgFiles/Journal.org")
         "\n* %<%I:%M %p> - Journal :journal:\n\n%?\n\n"
         ;; ,(dw/read-file-as-string "~/Notes/Templates/Daily.org")
         :clock-in :clock-resume
         :empty-lines 1)
	("jm" "Meeting" entry
         (file+olp+datetree "~/Projects/Code/emacs-from-scratch/OrgFiles/Journal.org")
         "* %<%I:%M %p> - %a :meetings:\n\n%?\n\n"
         :clock-in :clock-resume
         :empty-lines 1)

	("w" "Workflows")
	("we" "Checking Email" entry (file+olp+datetree "~/Projects/Code/emacs-from-scratch/OrgFiles/Journal.org")
         "* Checking Email :email:\n\n%?" :clock-in :clock-resume :empty-lines 1)
	))

;;;;;;;;;;;;;;;
;; Org babel ;;
;;;;;;;;;;;;;;;

(org-babel-do-load-languages
 'org-babel-load-languages
 '(
   (emacs-lisp . t)
   (python . t)
   (C . t)
   (go . t)
   (csharp . t)
   (jupyter . t)
   ))


;; If you don't find ob-<language>, look for it in
;; melpa or any package manager
(require 'ob-go)

;; so that it does not ask to execute every time
(setq org-confirm-babel-evaluate nil)


;;;;;;;;;;;;;;;;;;;;;;
;; csharp org babel ;;
;;;;;;;;;;;;;;;;;;;;;;

;; (setf org-babel-csharp-default-target-framework "net8.0")
;; this is to be able to install a package by fetching github repo
(use-package quelpa-use-package
  :init (setq quelpa-update-melpa-p nil)
  :config (quelpa-use-package-activate-advice))

;; you also need to install this pack from dotnet:
;; $ dotnet tool install -g dotnet-script

;; fetching github repo for ob-csharp
(use-package ob-csharp
  :ensure t
  :quelpa (ob-csharp
           :fetcher github
           :repo "samwdp/ob-csharp")
  )


(with-eval-after-load 'org
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((jupyter . t)))
  (setq org-confirm-babel-evaluate nil))




;; so that you can write "<py TAB" and it will write the bounds of your code
(require 'org-tempo)
(add-to-list 'org-structure-template-alist '("sh" . "src shell"))
(add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))
(add-to-list 'org-structure-template-alist '("py" . "src python"))
(add-to-list 'org-structure-template-alist '("csharp" . "src csharp"))
(add-to-list 'org-structure-template-alist '("go" . "src go"))





;; Pomodoroooo ??
;; Use wav formats. mp3 is fucked...
(setq org-clock-sound "~/Downloads/ding.wav")
(setq org-timer-default-timer 30)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;  yas-snippet   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;(use-package yas-snippet)
;;(yas-global-mode 1)
;;(add-hook 'yas-minor-mode-hook (lambda ()
;;				 (yas-activate-extra-mode 'fundamental-mode)))






;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;                                Email-mu4e                                   ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Managing mail with mu4e



(use-package mu4e
  :ensure nil
  :load-path "/usr/share/emacs/site-lisp/elpa-src/mu4e-1.12.9/"
  :defer 20 ; Wait until 20 seconds after startup
  :config

  ;; This is set to 't' to avoid mail syncing issues when using mbsync
  (setq mu4e-change-filenames-when-moving t)

  ;; Refresh mail using isync every 10 minutes
  (setq mu4e-update-interval (* 10 60))
  (setq mu4e-get-mail-command "mbsync -a")
  (setq mu4e-maildir "~/Mail")
  (setq mu4e-context-policy 'always-ask)

  (setq mu4e-contexts
        (list
         (make-mu4e-context
          :name "Personal"
          :match-func
          (lambda (msg)
            (when msg
              (string-prefix-p "/Gmail" (mu4e-message-field msg :maildir))))
          :vars '((user-mail-address . "ammarashraf111@gmail.com")
                  (user-full-name    . "Ammar Ashraf")
                  (mu4e-drafts-folder  . "/Gmail/[Gmail]/Drafts")
                  (mu4e-sent-folder  . "/Gmail/[Gmail]/Sent Mail")
                  (mu4e-refile-folder  . "/Gmail/[Gmail]/All Mail")
                  (mu4e-trash-folder  . "/Gmail/[Gmail]/Trash")
		  )))
	)

  (setq mu4e-maildir-shortcuts
        '(("/Gmail/Inbox"                   . ?i)
          ("/Gmail/[Gmail]/Sent Mail" . ?s)
          ("/Gmail/[Gmail]/Trash"     . ?t)
          ("/Gmail/[Gmail]/Drafts"    . ?d)
          ("/Gmail/[Gmail]/All Mail"  . ?a)
	  ))
  (server-start)
  (mu4e t) ;; run mu4e in the background to sync mail periodically
  )

(setq mu4e-bookmarks
      '((:name "Unread messages" :query "flag:unread AND NOT flag:trashed"
	       :key 117)
	(:name "Today's messages" :query "date:today..now" :key 116 :favorite t)
	(:name "Last 7 days" :query "date:7d..now" :hide-unread t :key 119)
	(:name "Messages with images" :query "mime:image/*" :key 112)
	))


(setq message-send-mail-function 'smtpmail-send-it)
(setq smtpmail-stream-type 'ssl)
(setq smtpmail-smtp-server "smtp.gmail.com")
(setq smtpmail-smtp-service 465)

(setq mu4e-compose-format-flowed t)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun efs/lookup-password (&rest keys)
  (let ((result (apply #'auth-source-search keys)))
    (if result
	(funcall (plist-get (car result) :secret))
      nil)))




;; Language tool
;; github ==> https://github.com/PillFall/languagetool.el
(use-package languagetool
  :ensure t
  :defer t
  :commands (languagetool-check
             languagetool-clear-suggestions
             languagetool-correct-at-point
             languagetool-correct-buffer
             languagetool-set-language
             languagetool-server-mode
             languagetool-server-start
             languagetool-server-stop)
  :config
  (setq languagetool-java-arguments '("-Dfile.encoding=UTF-8")
        languagetool-console-command "~/.languagetool/languagetool-commandline.jar"
        languagetool-server-command "~/.languagetool/languagetool-server.jar"
	))
;; you start the server by (languagetool-server-start)
;; then you set the server mode (languagetool-server-mode)

;; correct key binding
(global-set-key (kbd "C-c C") #'languagetool-correct-at-point)



;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Evil Multiple Cursor ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'evil-mc)
(global-evil-mc-mode 1)

;; mostly you will need few commands
;; g . n ===> evil-mc-make-and-goto-next-match
;; g . N ===> evil-mc-make-and-goto-prev-match

;; g . q ===> evil-mc-undo-all-cursors
;; g . u ===> evil-mc-undo-last-added-cursors


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; the following is to prevent line highlight in these modes
(dolist (mode '(vterm-mode-hook
		term-mode-hook
		shell-mode-hook
		eshell-mode-hook))
  (add-hook mode (lambda () (global-hl-line-mode 0))))


;; Disable line numbers for some modes
(dolist (mode '(;;org-mode-hook
		term-mode-hook
		shell-mode-hook
		eshell-mode-hook
		vterm-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))



(use-package command-log-mode)

(use-package counsel
  :bind (("M-x" . counsel-M-x)
	 ("C-x b" . counsel-ibuffer)
	 ("C-x C-f" . counsel-find-file)
	 :map minibuffer-local-map
	 ("C-r" . 'counsel-minibuffer-history))
  :config
  (setq ivy-initial-inputs-alist nil )) ;; Don't start searches with ^


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

;; (use-package doom-modeline
;;  :ensure t
;;  :init (doom-modeline-mode 1))


(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 3))


(use-package ivy-rich
  :config
  (ivy-rich-mode 1))

(use-package helpful
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-function-function #'helpful-variable)
  :bind
  ([remap describe-function] . #'helpful-callable)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . counsel-describe-variable)
  ([remap describe-key] . helpful-key))
(use-package general
  :config
  (general-create-definer rune/leader-keys
    :keymaps '(normal insert visual emacs)
    :prefix "SPC"
    :global-prefix "C-SPC")

  (rune/leader-keys
    "t"  '(:ignore t :which-key "toggles")
    "tt" '(org-timer-set-timer :which-key "org timer")
    "c" 'compile))
;; the line above makes you do a command "compile" after space-c
;; the line under makes the command empty when respawned
;;(setq compile-command "LD_LIBRARY_PATH=/usr/local/lib64 make && ./main")
(setq compile-command nil)


(add-to-list 'image-types 'svg)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Increase the undo limits
(setq undo-limit 800000         ;; default is 160kB
      undo-strong-limit 12000000  ;; default is 240kB
      undo-outer-limit 120000000) ;; default is 24MB

(use-package undo-fu
  :ensure t)

(use-package undo-fu-session
  :ensure t
  :init
  (undo-fu-session-global-mode)
  :config
  (setq undo-fu-session-directory "~/.emacs.d/undo-fu-session/")) ;;don't forget to mkdir ~/.emacs.d/undo-fu-session



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Evil ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq evil-want-keybinding nil)
(use-package evil
  :config
  (setq evil-undo-system 'undo-fu)
  (setq evil-want-integration t)
  (setq evil-want-C-u-scroll t)
  (setq evil-want-C-i-jump nil)
  (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
  (define-key evil-insert-state-map (kbd "C-h") 'evil-delete-backward-char-and-join)
  (evil-mode 1)
  ;; Use visual line motions even outside of visual-line-mode buffers
  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line)

  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal))


(setq evil-insert-state-cursor '(box)
      evil-normal-state-cursor '(box))

;; you can add color at the end
;; (setq evil-insert-state-cursor '(box   "white")
;;       evil-normal-state-cursor '(box "white"))




(with-eval-after-load 'undo-fu
  (define-key evil-normal-state-map (kbd "C-r") 'undo-fu-redo)
  (define-key evil-visual-state-map (kbd "C-r") 'undo-fu-redo))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; key-binding theft for seconds
(use-package hydra)

(defhydra hydra-text-scale (:timeout 4)
  "scale text"
  ("j" text-scale-increase "in")
  ("k" text-scale-decrease "out")
  ("f" nil "finished" :exit t))

(rune/leader-keys
  "ts" '(hydra-text-scale/body :which-key "scale text"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Add Magit and projectile here

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Learn to love the shell   [vterm]   ;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package term
  :config
  (setq explicit-shell-file-name "bash")
  )

(use-package vterm
  :ensure t
  :commands vterm
  :config
  (add-hook 'vterm-directory-change-hook #'vterm--update-directory)
  (vterm--set-directory "/home/ammar")
  (setq default-directory "/home/ammar")
  (setq vterm-max-scrollback 10000)
  (setq vterm-kill-buffer-on-exit t))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; multi vterm
;;(use-package multi-vterm)

;; (defvar my/multi-vterm-buffer-name "*vterm*"
;;   "Name of the main multi-vterm buffer to toggle.")

;; (defun my/multi-vterm-toggle-fullscreen ()
;;   "Toggle a multi-vterm buffer fullscreen in the current window.
;; If the buffer is visible, bury it. If not, show it in current window."
;;   (interactive)
;;   (let* ((vterm-buf (get-buffer my/multi-vterm-buffer-name))
;;          (vterm-win (and vterm-buf (get-buffer-window vterm-buf))))
;;     (if vterm-win
;;         ;; If visible, close it
;;         (delete-window vterm-win)
;;       ;; Else: create or show in current window
;;       (let ((default-directory (or my/last-non-vterm-dir default-directory)))
;;         (if vterm-buf
;;             (progn
;;               (switch-to-buffer vterm-buf)
;;               (delete-other-windows))
;;           ;; create the first multi-vterm (uses default-directory)
;;           (progn
;;             (multi-vterm)
;;             (rename-buffer my/multi-vterm-buffer-name)
;;             (delete-other-windows)))))))

;; (global-set-key (kbd "C-3") 'my/multi-vterm-toggle-fullscreen)


;; vterm-toggle
(use-package vterm-toggle)
(global-set-key [f2] 'vterm-toggle)
(global-set-key (kbd "C-2") 'vterm-toggle-cd)

;; you can cd to the directory where your previous buffer file exists
;; after you have toggle to the vterm buffer with `vterm-toggle'.
(define-key vterm-mode-map [(control return)]   #'vterm-toggle-insert-cd)

;; show vterm buffer in current window
(setq vterm-toggle-fullscreen-p nil)
(add-to-list 'display-buffer-alist
             '((lambda (buffer-or-name _)
                 (let ((buffer (get-buffer buffer-or-name)))
                   (with-current-buffer buffer
                     (or (equal major-mode 'vterm-mode)
                         (string-prefix-p vterm-buffer-name (buffer-name buffer))))))
               (display-buffer-reuse-window display-buffer-same-window)))

(use-package eterm-256color
  :hook (term-mode . eterm-256color-mode))





;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;; To make this you need to set it nil ...



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Dired

(use-package dired
  :ensure nil
  :commands (dired dired-jump)
  :bind (("C-x C-j" . dired-jump))
  :custom ((dired-listing-switches "-agho --group-directories-first"))
  :config
  (evil-collection-define-key 'normal 'dired-mode-map
    "h" 'dired-single-up-directory ;; uses single dired
    "l" 'dired-single-buffer))     ;; uses single dired

;;(use-package dired-single)   ;; It let you have only one dired buffer in the buffer list
;; for some fucken reason this package is not longer available in melpa, download it manually from github
;; and do the following
(add-to-list 'load-path "~/.emacs.d/dired-single")
(require 'dired-single)


;; The following makes it moves deleted files to trash folder
(setq delete-by-moving-to-trash 1) ;; dired related

(use-package dired-hide-dotfiles
  :hook (dired-mode . dired-hide-dotfiles-mode)
  :config
  (evil-collection-define-key 'normal 'dired-mode-map
    "H" 'dired-hide-dotfiles-mode))

;;(global-set-key (kbd "C-a") nil)
(global-set-key (kbd "C-x a a") 'dired-create-empty-file)


;; usefull shit
;; mark a file by "m"
;; unmark with "u" (use "U" to unmark "all" marked files)
;; invert marked file with others with "t"
;; mark file/s and hit "K", that will kill a file (make it disappear temp), and refresh with "g-r" to get them back
;; Copy a file (or marked file/s) with "C"
;; Rename with "R" (rename is as move)
;; If you rename or make a new file with a name that is similar to an existing one it will force you to pick one of the
;; existing ones, you can write (Ctrl + Alt + j) to force the name that you only wrote.





;; ansi-color [solving bad letters in compile buffer "man"]
(require 'ansi-color)
(defun colorize-compilation-buffer ()
  (let ((inhibit-read-only t))
    (ansi-color-apply-on-region compilation-filter-start (point))))

(add-hook 'compilation-filter-hook 'colorize-compilation-buffer)





;; Defined functions ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun increment-number-at-point ()
  (interactive)
  (skip-chars-backward "0-9")
  (or (looking-at "[0-9]+")
      (error "No number at point"))
  (replace-match (number-to-string (1+ (string-to-number (match-string 0))))))
(global-set-key (kbd "C-x +") 'increment-number-at-point)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; C++
;; (use-package flycheck
;;   :ensure t
;;   :init
;;   (global-flycheck-mode t))

(defun my-c-mode-common-hook ()
  ;; my customizations for all of c-mode, c++-mode, objc-mode, java-mode
  (c-set-offset 'substatement-open 0)
  (setq c-basic-offset 8)
  ;; other customizations can go here

  ;;(setq c++-tab-always-indent t)
  ;;(setq c++-indent-level 4)
  ;;(setq c-basic-offset 4)                  ;; Default is 2
  ;;(setq c-indent-level 4)                  ;; Default is 2

  ;; (setq tab-stop-list '(4 8 12 16 20 24 28 32 36 40 44 48 52 56 60))
  (setq tab-stop-list '(8 16 32 64 128 256 512 1024 2048 4096 8192 16384 32768))
  ;; (setq tab-stop-list '(2 4 6 8 10 12 14 16 18 20 22 24 26 28 30 32 34 36 38 40 42 44 46 48 50))
  (setq tab-width 8)
  (setq indent-tabs-mode nil))  ; use spaces only if nil

(setq markdown-list-indent-width 8)
(setq csharp-ts-mode-indent-offset 8)

(add-hook 'c-mode-common-hook 'my-c-mode-common-hook)


;; this is to let the indentation function [indent-region-function]
;; to be indent-according-to-mod
;; which uses the major mode indentation variables... (8 for most)
;; it takes control from lsp which used to alwasy indent based on his variables
;; not based on the emacs variables
(setq lsp-enable-indentation nil)
(setq lsp-enable-on-type-formatting nil)
(setq indent-region-function 'indent-according-to-mode)
;; using the function; indent-region(M-C-\), will indent a specific region
;; so you have to use visual mode to indent lines with it.

;; this function indent the whole buffer without specifiying a region
(defun indent-buffer ()
  "Indent the entire buffer according to the current major mode."
  (interactive)
  (indent-region (point-min) (point-max)))
(global-set-key (kbd "C-c i") #'indent-buffer)


;;; semicolon newline disable
(setq c-electric-semicolon nil)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; lsp mode
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;(global-set-key (kbd "C-=") 'text-scale-increase)
(global-set-key (kbd "C-<tab>") 'completion-at-point)  ;; fricken gooooood (life saver)
;; if you use emacs -nw (emacs in terminal), use C-M-i instead of the C-<tab>, because it won't work

(setq lsp-completion-provider :none) ;; make sure this shit is none

;; chick https://emacs-lsp.github.io/lsp-mode/tutorials/how-to-turn-off/
(setq lsp-keymap-prefix "C-c l")
(setq lsp-headerline-breadcrumb-enable nil)
(setq lsp-headerline-breadcrumb-enable-diagnostics nil)
(setq lsp-eldoc-enable-hover 1)
(setq lsp-signature-render-documentation nil)
(setq lsp-signature-auto-activate nil) ;; you could manually request them via `lsp-signature-activate`

(setq lsp-enable-symbol-highlighting nil)

(setq lsp-completion-show-detail nil)
(setq lsp-completion-show-kind nil)
(setq lsp-enable-links nil)
(setq lsp-enable-on-type-formatting nil)
(setq lsp-diagnostics-provider :auto)
(setq flycheck-check-syntax-automatically '(idle-change)) ;; don't forget to install flycheck package


;; This cool shit lets you fold and unfold anything between {...}
(add-hook 'prog-mode-hook #'hs-minor-mode)
(evil-define-key 'normal prog-mode-map
  "za" 'hs-toggle-hiding
  "zc" 'hs-hide-block
  "zo" 'hs-show-block
  "zM" 'hs-hide-all
  "zR" 'hs-show-all)



(setq package-selected-packages '(lsp-mode yasnippet dap-mode
					   avy which-key ))

(when (cl-find-if-not #'package-installed-p package-selected-packages)
  (package-refresh-contents)
  (mapc #'package-install package-selected-packages))


(which-key-mode)
(add-hook 'c-mode-hook 'lsp)
(add-hook 'c++-mode-hook 'lsp)

(setq gc-cons-threshold (* 100 1024 1024)
      read-process-output-max (* 1024 1024)
      treemacs-space-between-root-nodes nil
      company-idle-delay 0.0
      company-minimum-prefix-length 1
      lsp-idle-delay 0.1)  ;; clangd is fast

(with-eval-after-load 'lsp-mode
  (add-hook 'lsp-mode-hook #'lsp-enable-which-key-integration)
  (yas-global-mode))


;; Clangd notes
;; you can add compile flags to clangd
;; go to ~/.config/clangd/config.yaml
;; and put that there

;; If:
;;   PathMatch: .*\.cpp
;; CompileFlags:
;;   Add: [-std=c++20]
;; ---
;; If:
;;   PathMatch: .*\.cc
;; CompileFlags:
;;   Add: [-std=c++20]

;; note: the three dashes --- are very important
;; The exact indentation is also important

;; try use two spaces only for indentation
;; every time you open a c++ project it will make a .clangd file
;; and put the flag in it.


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; The following case is important.
;; if your system uses an older gcc that doesn't support c++20 headers or libraries,
;; and you build a new version by yourself, the libraries of the old version will still
;; be used instead of the new, and clang always have to use gcc libraries and headers.
;; So you have to explicity tell clang to use the new gcc(13) libraries and headers.

;; If:
;;   PathMatch: .*\.cpp
;; CompileFlags:
;;   Add: [
;;   "-std=c++20",
;;   "-stdlib=libstdc++",
;;   "-I/usr/local/include/c++/13.4.0",
;;   "-I/usr/local/include/c++/13.4.0/x86_64-pc-linux-gnu",
;;   "-L/usr/local/lib/gcc/x86_64-pc-linux-gnu/13.4.0"]
;; ---
;; If:
;;   PathMatch: .*\.cc
;; CompileFlags:
;;   Add: ["-std=c++20",
;;   "-stdlib=libstdc++",
;;   "-I/usr/local/include/c++/13.4.0",
;;   "-I/usr/local/include/c++/13.4.0/x86_64-pc-linux-gnu",
;;   "-L/usr/local/lib/gcc/x86_64-pc-linux-gnu/13.4.0"]


;; the order of the -I is important..
;; echo | g++-15 -v -x c++ -E -
;; use this command to know the includes that g++-15 uses, or any other version.
;; run clang++ -v test.cpp to see exactly what include paths it uses, then
;; use that as a reference to tune your config.yaml


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; The dotes in the spaces
(require 'whitespace)

(setq whitespace-display-mappings
      '((space-mark ?\  [183] [46])          ; space → ·
	(tab-mark   ?\t [183 183 183 183 183 183 183 183]    ; tab → "········"
		    [46 46 46 46]))          ; fallback "........"
      )
;; the number 183 is unicode for middle dot
;; the number 46  is ASCII dot
;; the fullback is the dot that is used if emacs doesn't supprot
;; unicode.


(setq whitespace-style '(face spaces tabs trailing space-mark tab-mark))


(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(whitespace-space ((t (:foreground "gray17"))))
 '(whitespace-tab ((t (:foreground "gray17"))))
 '(whitespace-trailing ((t (:foreground "gray17")))))

(global-whitespace-mode 1)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




;; for performance
(use-package lsp-mode
  :ensure t
  :hook ((python-mode . lsp)
	 (go-mode . lsp)
	 (csharp-mode . lsp)
	 (sql-mode . lsp))
  :config
  (setq lsp-enable-file-watchers nil
        lsp-idle-delay 0.4
        lsp-enable-symbol-highlighting t
        lsp-diagnostics-provider :auto
        ;; Keep autocompletion enabled

        lsp-completion-enable t ;; important if you want autocomp.

        lsp-pylsp-plugins-autopep8-enabled nil
        lsp-pylsp-plugins-yapf-enabled nil
        lsp-pylsp-plugins-pydocstyle-enabled nil
        lsp-pylsp-plugins-pycodestyle-enabled nil
        lsp-pylsp-plugins-pylint-enabled nil
        lsp-pylsp-plugins-pyflakes-enabled nil
        lsp-pylsp-plugins-flake8-enabled t))



;;--- C# support ---
(use-package csharp-mode
  :ensure t
  :hook (csharp-mode . lsp))


;; Don't forget to install origami package and lsp-origami
;; from M-x package-install command
(add-hook 'csharp-mode-hook 'origami-mode)
(evil-define-key 'normal csharp-mode-map
  "za" 'origami-toggle-node)

;; Keep them commented.... (they make the #region disappear to ... when folded)
;; (add-hook 'csharp-mode-hook #'lsp)
;; (add-hook 'csharp-mode-hook #'lsp-origami-mode)

;; (with-eval-after-load 'lsp-mode
;;   ;; Tell lsp-mode where OmniSharp is
;;   (setq lsp-csharp-server-path "~/.local/share/omnisharp"))

;; fucken Csharp Man...
;; Don't forget to fucken add a symbolic link the root directory of dotnet
;; in /usr/share/dotnet



;; Python support
(use-package pyvenv
  :ensure t
  :config
  (pyvenv-mode 1)) ;; Don't forget to insall npm in your system

(setq lsp-python-ms-python-executable
      (expand-file-name "~/.venvs/emacs-lsp/bin/python"))

(use-package blacken
  :ensure t
  :hook (python-mode . blacken-mode))

(use-package company
  :ensure t)

(use-package lsp-ui
  :ensure t
  :commands lsp-ui-mode
  :config
  (setq lsp-ui-doc-enable t
        lsp-ui-sideline-enable t))

;; (setq lsp-pylsp-server-command '("~/.venvs/emacs-lsp/bin/pylsp"))


;; Golang shit
(use-package go-mode
  :ensure t)
(setq lsp-gopls-server-path (expand-file-name "~/go/bin/gopls"))

(setq gofmt-command "goimports")
(add-hook 'before-save-hook 'gofmt-before-save)

(use-package exec-path-from-shell
  :config
  (exec-path-from-shell-initialize))



(with-eval-after-load 'lsp-mode
  (evil-define-key 'normal lsp-mode-map
    (kbd "g d") #'lsp-find-definition))


;;; Projectile ;;;;
(use-package projectile
  :diminish projectile-mode
  :config (projectile-mode)
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :init
  (setq projectile-switch-project-action #'projectile-dired))

(use-package counsel-projectile
  :config (counsel-projectile-mode))





;; to be able to jump to definitions

;;(setq lsp-pylsp-plugins-jedi-use-pyenv-environment t)  ;; Ensure Jedi uses the correct env
;;(setq lsp-pylsp-plugins-jedi-definition-enabled t)  ;; Enable "Go to Definition"
;;(setq lsp-pylsp-plugins-jedi-completion-enabled t)  ;; Ensure Jedi is providing completions

;; flymake annoying stuff

;; (setq flymake-no-changes-timeout 1.0)  ;; Wait 1 sec before highlighting
;; (setq flymake-start-on-save-buffer t)  ;; Only check on save, not every keystroke
;; (setq flymake-start-on-flymake-mode nil)  ;; Don't start automatically

;;(set-face-attribute 'flymake-error nil :underline '(:style wave :color "red3"))
;;(set-face-attribute 'flymake-warning nil :underline '(:style wave :color "yellow3"))
;;(set-face-attribute 'flymake-note nil :underline '(:style wave :color "green3"))

;;(setq flymake-fringe-indicator-position 'right-fringe)  ;; Move errors to the right fringe

;; (set-face-attribute 'flymake-error nil :underline nil)

;;(set-face-attribute 'flymake-warning nil :underline nil)
;;(set-face-attribute 'flymake-note nil :underline nil)



;; (load-file "~/.emacs.d/evil-collection-vterm.el")

;;(add-hook 'vterm-mode-hook (lambda () (evil-mode -1)))

;; (with-eval-after-load 'vterm
;;   (define-key vterm-mode-map [down-mouse-1] nil)
;;   (define-key vterm-mode-map [mouse-1] nil)
;;   (define-key vterm-mode-map [drag-mouse-1] nil)
;;   (define-key vterm-mode-map [mouse-2] nil)
;;   (define-key vterm-mode-map [mouse-3] nil))

;; (setq vterm-disable-mouse nil)


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("8c7e832be864674c220f9a9361c851917a93f921fedb7717b1b5ece47690c098"
     "2d74de1cc32d00b20b347f2d0037b945a4158004f99877630afc034a674e3ab7"
     "8f5b54bf6a36fe1c138219960dd324aad8ab1f62f543bed73ef5ad60956e36ae"
     "23e9480ad7fd68bff64f6ecf3c31719c7fe2a34c11f8e27206cd998739f40c84"
     "5a4cdc4365122d1a17a7ad93b6e3370ffe95db87ed17a38a94713f6ffe0d8ceb"
     default))
 '(helm-minibuffer-history-key "M-p")
 '(package-selected-packages nil)
 '(package-vc-selected-packages nil))

(put 'upcase-region 'disabled nil)

