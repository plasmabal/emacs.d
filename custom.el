;;; Start Emacs Server
(cond ((eq system-type 'cygwin)         ; Under cygwin
       (server-start))
      ((eq system-type 'windows-nt)     ; Under Windows NT
       (cond ((fboundp 'emacsw32-version) ; Under EmacsW32
              (server-start))
                                        ;(ignore))
             (t (require 'gnuserv)      ;   Default
                (gnuserv-start))))
      ((eq system-type 'berkeley-unix)  ; Under FreeBSD
       (server-start))
      ((eq system-type 'darwin)
       (server-start)))
(add-hook 'server-visit-hook (function (lambda () (raise-frame))))
(add-hook 'server-done-hook (function (lambda () (lower-frame))))

;;; keybindings
(global-set-key "\M- " 'set-mark-command)
(global-set-key "\C-cg" 'goto-line)

;; from http://www.emacswiki.org/cgi-bin/wiki/MatchParenthesis.  Use
;; '%' to match paren just like vi do
(defun match-paren (arg)
  "Go to the matching paren if on a paren; otherwise insert %."
  (interactive "p")
  (cond ((looking-at "\\s\(") (forward-list 1) (backward-char 1))
        ((looking-at "\\s\)") (forward-char 1) (backward-list 1))
        (t (self-insert-command (or arg 1)))))
(global-set-key "%" 'match-paren)

;; hi-lock mode
(if (functionp 'global-hi-lock-mode)
    (global-hi-lock-mode 1)
  (hi-lock-mode 1))
(defun highlight-common-phrases ()
  "Highlight common phrases.  Used in mode hooks."
  (highlight-phrase "XXXX" 'hi-yellow)
  (highlight-phrase "TODO" 'hi-yellow)
  (highlight-phrase "FIXME" 'hi-yellow)
  (highlight-phrase "DEBUG" 'hi-pink)
  (highlight-regexp "NOTES?" 'hi-yellow)
  )






;;; Setting up environment for objc-mode
;; Object-C mode
(add-to-list 'auto-mode-alist '("\\.mm?$" . objc-mode))
(add-to-list 'auto-mode-alist '("\\.h$" . objc-mode))
(add-to-list 'magic-mode-alist '("\\(.\\|\n\\)*\n@implementation" . objc-mode))
(add-to-list 'magic-mode-alist '("\\(.\\|\n\\)*\n@interface" . objc-mode))
(add-to-list 'magic-mode-alist '("\\(.\\|\n\\)*\n@protocol" . objc-mode))

;; compile xcode
(defun xcode:buildandrun ()
  (interactive)
  (do-applescript
   (format
    (concat
     "tell application \"Xcode\" to activate \r"
     "tell application \"System Events\" \r"
     "     tell process \"Xcode\" \r"
     "          key code 36 using {command down} \r"
     "    end tell \r"
     "end tell \r"
     ))))

;; xcode-document-viewer
(require 'xcode-document-viewer)
(setq xcdoc:document-path "/Users/plasma/Library/Developer/Shared/Documentation/DocSets/com.apple.adc.documentation.AppleiOS6.1.iOSLibrary.docset")
;(setq xcdoc:document-path "/Developer/Platforms/iPhoneOS.platform/Developer/Documentation/DocSets/com.apple.adc.documentation.AppleiOS5_0.iOSLibrary.docset")
;(setq xcdoc:document-path "/Developer/Platforms/iPhoneOS.platform/Developer/Documentation/DocSets/com.apple.adc.documentation.AppleiOS4_3.iOSLibrary.docset")
(setq xcdoc:open-w3m-other-buffer t)

;; helpers for finding files
(ffap-bindings)
;; 设定搜索的路径 ffap-c-path
;; (setq ffap-c-path
;;     '("/usr/include" "/usr/local/include"))
;; 如果是新文件要确认
(setq ffap-newfile-prompt t)
;; ffap-kpathsea-expand-path 展开路径的深度
(setq ffap-kpathsea-depth 5)

(setq ff-other-file-alist
      '(("\\.mm?$" (".h"))
        ("\\.cc$"  (".hh" ".h"))
        ("\\.hh$"  (".cc" ".C"))

        ("\\.c$"   (".h"))
        ("\\.h$"   (".c" ".cc" ".C" ".CC" ".cxx" ".cpp" ".m" ".mm"))

        ("\\.C$"   (".H"  ".hh" ".h"))
        ("\\.H$"   (".C"  ".CC"))

        ("\\.CC$"  (".HH" ".H"  ".hh" ".h"))
        ("\\.HH$"  (".CC"))

        ("\\.cxx$" (".hh" ".h"))
        ("\\.cpp$" (".hpp" ".hh" ".h"))

        ("\\.hpp$" (".cpp" ".c"))))

;; pragma sections
(require 'anything-config)

(defvar anything-c-source-objc-headline
  '((name . "Objective-C Headline")
    (headline  "^[-+@]\\|^#pragma mark")))

(defun objc-headline ()
  (interactive)
  ;; Set to 500 so it is displayed even if all methods are not narrowed down.
  (let ((anything-candidate-number-limit 500))
    (anything-other-buffer '(anything-c-source-objc-headline)
                           "*ObjC Headline*")))

(add-hook 'objc-mode-hook
          (lambda ()
            (highlight-common-phrases)
            (define-key objc-mode-map (kbd "C-c C-r") 'xcode:buildandrun)
            (define-key objc-mode-map (kbd "C-c w") 'xcdoc:ask-search)
            (define-key c-mode-base-map (kbd "C-x t") 'ff-find-other-file)
            (define-key objc-mode-map (kbd "C-x p") 'objc-headline)
            ))


;;; yasnippet and auto-complete
(setq yas/trigger-key (kbd "C-c <kp-multiply>"))
(yas--initialize)
(require 'auto-complete-config)
(setq-default ac-sources '(ac-source-yasnippet ac-source-abbrev ac-source-dictionary ac-source-words-in-same-mode-buffers))
(add-hook 'c-mode-common-hook 'ac-cc-mode-setup)
(add-to-list 'ac-modes 'objc-mode)
