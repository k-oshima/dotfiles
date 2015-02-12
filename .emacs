;; -*- Mode: Emacs-Lisp ; Coding: utf-8 -*-
;; .emacs @nsk koshima 2014-12-25

;;; emacs -q  ;run without .emacs
;;; emacs -q -l ~/.emacs-small-test
;;;   or M-x load RET test-file.el RET
;;; emacs --debug-init
;(setq debug-on-error t)

;key bind
(global-set-key "\C-h" 'delete-backward-char)

;; load-path
;(setq load-path (cons "~/.emacs.d" load-path))

(defun set-character-encoding-system (coding-system)
  (set-language-environment 'Japanese)	; 日本語環境※
  (cond
   ((eq coding-system 'utf-8-unix)
;;; 日本語と文字コードエンコーディングの設定
;     (set-default-coding-systems 'utf-8-unix)	; 新規ファイルは UTF-8/LF で開く
;(set-terminal-coding-system 'utf-8-unix)	; UTF-8 terminal で emacs -nw 対策
     (setq default-file-name-coding-system 'utf-8)
     (setq default-process-coding-system '(utf-8 . utf-8))
     (prefer-coding-system 'utf-8-unix)              ; 優先順位変更※
     )
    ((eq coding-system 'utf-8-hfs)              ; UTF-8 HFS (OS X)
     (set-default-coding-systems 'utf-8-hfs)	; 新規ファイルは UTF-8/CR で開く
     (set-terminal-coding-system 'utf-8-hfs)	; UTF-8 terminal で emacs -nw 対策
     (setq default-file-name-coding-system 'utf-8)
     (setq default-process-coding-system '(utf-8 . utf-8))
     (prefer-coding-system 'utf-8-hfs)              ; 優先順位変更※
     )
    ((eq coding-system 'utf-8-dos)
     (set-default-coding-systems 'utf-8-dos)	; 新規ファイルは UTF-8/CRLF で開く
     (prefer-coding-system 'utf-8-dos)          ; 優先順位変更※
      ;; もしコマンドプロンプトを利用するなら sjis にする
      ;; (setq file-name-coding-system 'sjis)
      ;; (setq locale-coding-system 'sjis)
     )))

;; Mac OS X (apple-darwin)
(defun set-osx-settings ()
 (if (or (and (= emacs-major-version 22) (<= emacs-minor-version 2))
	 (>= emacs-major-version 23))
       (require 'ucs-normalize))
; (setq file-name-coding-system 'utf-8-hfs)
; (setq locale-coding-system 'utf-8-hfs)
 (setq exec-path
       (append 
	'("/Applications/Firefox3.app/Contents/MacOS"
	  "/usr/local/bin"
	  "/opt/local/bin")
	exec-path))
;; Setting PATH... why... my Emacs does not seem to inherit PATH from
;; .MacOSX/environment.plist, ~/.bash_profile, nor /etc/bashrc on my Mac :(
 (setenv "PATH" "/usr/local/bin:/opt/local/bin:/opt/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin")
)

;; OS / window system
(cond
 ((string-match "mingw" system-configuration)
; (set-character-encoding-system 'utf-8-dos)
  (set-character-encoding-system 'utf-8-unix)   ; at Nhs
  )
 ((string-match "linux" system-configuration)
  (set-character-encoding-system 'utf-8-unix)
  )
 ((or (string-match "apple-darwin" system-configuration) 
      (or (eq window-system 'mac) (eq window-system 'ns)))
  (set-osx-settings)
  (set-character-encoding-system 'utf-8-hfs)
  )
 ((string-match "netbsd" system-configuration)
  (set-character-encoding-system 'utf-8-unix)
  )
 ((string-match "freebsd" system-configuration)
  (set-character-encoding-system 'utf-8-unix)
  ))


;;; for Ruby Programming
(autoload 'ruby-mode "ruby-mode" "Mode for editing ruby source files")
(setq auto-mode-alist
      (append '(("\\.rb\\'"     . ruby-mode)
		("Rakefile\\'"  . ruby-mode)
		("Gemfile\\'"   . ruby-mode)
		("Guardfile\\'" . ruby-mode)
		) auto-mode-alist))
(add-to-list 'interpreter-mode-alist '("ruby" . ruby-mode))
(autoload 'run-ruby "inf-ruby" "Run an inferior Ruby process")
(autoload 'inf-ruby-keys "inf-ruby"
  "Set local key defs for inf-ruby in ruby-mode")

(setq ruby-indent-level 2)
(setq ruby-indent-tabs-mode nil)
(show-paren-mode 1)
(setq next-line-add-newlines nil) 

(modify-coding-system-alist 'file "\\.rb\\'" 'utf-8-unix)       ; RubyのファイルはUTF-8+LF
(modify-coding-system-alist 'file "Rakefile\\'" 'utf-8-unix)
(modify-coding-system-alist 'file "Gemfile\\'" 'utf-8-unix)
(modify-coding-system-alist 'file "Guardfile\\'" 'utf-8-unix)
(modify-coding-system-alist 'file "\\.erb\\'" 'utf-8-unix)      ; Rails

;;; for CoffeeScript
(autoload 'coffee-mode "coffee-mode" "Mode for editing CoffeeScript source files")
(add-to-list 'auto-mode-alist '("\\.coffee\\'" . coffee-mode))
(add-to-list 'auto-mode-alist '("Cakefile\\'" . coffee-mode))
(custom-set-variables '(coffee-tab-width 4))   ; coding standards in Nhs

(modify-coding-system-alist 'file "\\.coffee\\'" 'utf-8-unix)       ; CoffeeScriptファイルはUTF-8+LF
(modify-coding-system-alist 'file "Cakefile\\'" 'utf-8-unix)

;;; MELPA package.el http://melpa.org/
;;; how to use: M-x package-list-packages
(require 'package) ;; You might already have this line
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/") t)
(add-to-list 'package-archives
             '("melpa-stable" . "http://stable.melpa.org/packages/") t)
(when (< emacs-major-version 24)
  ;; For important compatibility libraries like cl-lib
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))
(package-initialize) ;; You might already have this line
