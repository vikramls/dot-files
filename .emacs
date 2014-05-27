(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(column-number-mode t)
 '(custom-enabled-themes (quote (tango-dark)))
 '(ede-project-directories (quote ("/home/vikram/"))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "DejaVu LGC Sans Mono" :foundry "unknown" :slant normal :weight normal :height 108 :width normal)))))

(add-to-list 'load-path "~\.emacs.d")
(add-to-list 'load-path "~\.elisp")

;;;;; PATH related
(setenv "PATH" (concat (getenv "PATH") ":/home/vikram/builds/bin"))
(setq exec-path (append exec-path '(":/home/vikram/builds/bin")))

;;;;; Functions
;; from: http://www.grok2.com/vi-emacs.html#MatchParenthesis
(defun match-paren (arg)
  "Go to the matching paren if on a paren; otherwise insert %."
  (interactive "p")
  (cond ((looking-at "\\s\(") (forward-list 1) (backward-char 1))
        ((looking-at "\\s\)") (forward-char 1) (backward-list 1))
        (t (self-insert-command (or arg 1)))))

;; from: http://www.hollenback.net/emacs/emacs.el
(defun mark-line-and-copy ()
  "Copy the current line into the kill ring."
  (interactive)
  (beginning-of-line)
  (push-mark)
  (forward-line 1)
  (kill-ring-save (region-beginning) (region-end))
  (message "line copied"))

(defun duplicate-line ()
  "Copy this line under it; put point on copy in current column."
  (interactive)
  (let ((start-column (current-column)))
    (save-excursion
      (mark-line-and-copy) ;save-excursion restores mark
      (yank))
    (forward-line 1)
    (move-to-column start-column))
  (message "line dup'ed"))

(defun duplicate-region ()
  "Copy this region after itself."
  (interactive)
  (let ((start (point-marker)))
    (kill-ring-save (region-beginning) (region-end))
    (yank)
    (goto-char start))
  (message"region dup'ed"))

(defun autocompile nil
  "compile itself if ~/.emacs"
  (interactive)
  (require 'bytecomp)
  (if (string= (buffer-file-name) (expand-file-name (concat default-directory ".emacs")))
      (byte-compile-file (buffer-file-name))))

;; From http://www.ludd.luth.se/~wilper-8/computer/emacs.html
;; UNIX-DOS-UNIX end of line conversions
(defun dos-unix ()
        (interactive)
        (goto-char (point-min))
        (while (search-forward "\r" nil t) (replace-match "")))

(defun unix-dos ()
        (interactive)
        (goto-char (point-min))
        (while (search-forward "\n" nil t) (replace-match "\r\n")))

;; From http://stackoverflow.com/a/10536794
;; SSH term within emacs
;; (defun my-ssh (user host port)
;;   "Connect to a remote host by SSH."
;;   (interactive "sUser: \nsHost: \nsPort (default 22): ")
;;   (let* ((port (if (equal port "") "22" port))
;;          (switches (list host "-l" user "-p" port)))
;;     (set-buffer (apply 'make-term "ssh" "ssh" nil switches))
;;     (term-mode)
;;     (term-char-mode)
;;     (switch-to-buffer "*ssh*")))

;(desktop-save-mode 1)               ; Save session.
(add-hook 'after-save-hook 'autocompile) ; autocompile after save
(fset 'yes-or-no-p 'y-or-n-p)       ; replace y-e-s by y
(setq confirm-kill-emacs 'y-or-n-p) ; ask before quitting emacs
(setq-default indent-tabs-mode nil) ; Use spaces to indent only
(setq require-final-newline 'query) ; Ask for final newline
(setq resize-mini-windows t)        ; Resize minibuffer as necessary
(setq pending-delete-mode t)        ;
(setq read-file-name-completion-ignore-case t) ; Ignore case when completing
                                               ; filenames
(setq auto-compression-mode t)      ; Transparent (un)compression
(setq case-fold-search t)           ; ignore case during search
;; Save place in file
(setq save-place-file "~/.emacs.d/saveplace")  ; keep single file for saveplace
(setq-default save-place t)         ; Remember last position in file
(require 'saveplace)                ; load package
;; Buffers
(iswitchb-mode 1)   ; Buffer switching
(require 'uniquify) ; give buffers more intelligent names.
(setq uniquify-buffer-name-style 'forward) ; create unique buffer names with
                                           ; shared directoy components.
(setq inhibit-startup-message t)   ; Don't show banner on startup.
(setq visible-bell t)              ; Use visible bell instead of the annoying beep.
(setq frame-title-format "%b")     ; Show current filename in window title.
(setq line-number-mode t)          ; Show line number in modeline
(setq column-number-mode t)        ; Show column number in modeline

;; backup files
(setq
   backup-by-copying t      ; don't clobber symlinkCs
   backup-directory-alist
   '(("." . "~/.saves"))    ; don't litter my fs tree
   delete-old-versions t
   kept-new-versions 2
   kept-old-versions 1
   version-control t)       ; use versioned backups

;; Default text-mode
(setq major-mode 'indented-text-mode)
;(toggle-text-mode-auto-fill); always auto-fill in text mode
; (add-hook 'indented-text-mode-hook 'flyspell-mode)

;; Visual-basic mode
(autoload 'visual-basic-mode "visual-basic-mode" "Visual Basic mode." t)
(setq auto-mode-alist (append '(("\\.\\(frm\\|bas\\|cls\\)$" .
                                 visual-basic-mode)) auto-mode-alist))

;; extension to dired
(add-hook 'dired-load-hook
          (lambda ()
            (load "dired-x")))

;; Keybindings
(global-set-key "%" 'match-paren)
(global-set-key (kbd "C-x w") 'what-line)
(global-set-key (kbd "M-g") 'goto-line)
(global-set-key (kbd "C-`") 'capitalize-word)
(global-set-key (kbd "C-c C-y")  'duplicate-line)
(global-set-key (kbd "C-c y")    'duplicate-region)
(global-set-key (kbd "C-c Y")    'duplicate-line)
(global-set-key (kbd "C-c C-l")  'mark-line-and-copy) ;has many modal
                                                      ;remappings
(global-set-key (kbd "C-x M-b")  'clone-indirect-buffer)
(global-set-key (kbd "C-c l")    'mark-line-and-copy)
(global-set-key (kbd "C-h") 'delete-backward-char)    ;backspace, not help!
(global-set-key (kbd "<home>") 'beginning-of-line)    ;instead of top-of-screen
(global-set-key (kbd "<end>") 'end-of-line)           ;inactive by default?

(global-set-key (kbd "C-<home>") 'beginning-of-buffer);M$-style beginning and
(global-set-key (kbd "C-<end>") 'end-of-buffer)       ;same bindings for

(global-set-key (kbd "<delete>") 'delete-char)        ; delete char, don't
                                                      ; move cursor.
(global-set-key (kbd "C-c u") 'uncomment-region)      ; uncomment code block
(global-set-key (kbd "C-c i") 'indent-line-or-region) ; indent block

;;;;; p4/emacs integration
(add-to-list 'load-path "~/.emacs.d/p4/")
(load-library "p4")
(put 'narrow-to-region 'disabled nil)

;;;;; csv-mode
(add-to-list 'auto-mode-alist '("\\.[Cc][Ss][Vv]\\'" . csv-mode))
(autoload 'csv-mode "csv-mode"
  "Major mode for editing comma-separated value files." t)

;;;;; filecache - Find files without knowing path!
(require 'filecache)
(file-cache-add-directory-recursively "/home/vikram/projects/")

;;;;; markdown mode
(autoload 'markdown-mode "markdown-mode"
   "Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))

;;;;; bookmark - Load at startup
(require 'bookmark)
(bookmark-bmenu-list)
;; (switch-to-buffer "*Bookmark List*")


;;;;; ggtags - gtags (GNU global) interface via emacs
;(require 'ggtags)
;; Add hook in C and C++ mode
;(add-hook 'c-mode-common-hook
;          (lambda ()
;            (when (derived-mode-p 'c-mode 'c++-mode)
;              (ggtags-mode 1))))

;;;;; GNU global
;; (setq load-path (cons "/home/vikram/builds/share/gtags/" load-path))
;; (autoload 'gtags-mode "gtags" "" t)
;; (setq c-mode-hook
;;       '(lambda()
;;          (gtags-mode 1)
;;          )
;;       )

;; (setq c++-mode-hook
;;       '(lambda()
;;          (gtags-mode 1)
;;          )
;;       )
