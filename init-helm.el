(helm-mode 1)

(setq helm-completing-read-handlers-alist
      '((describe-function . ido)
        (describe-variable . ido)
        (debug-on-entry . helm-completing-read-symbols)
        (find-function . helm-completing-read-symbols)
        (find-tag . helm-completing-read-with-cands-in-buffer)
        (ffap-alternate-file . nil)
        (tmm-menubar . nil)
        (dired-do-copy . ido)
        (dired-do-rename . ido)
        (dired-create-directory . nil)
        (find-file . ido)
        (ido-find-file . nil)
        (yas/compile-directory . ido)
        (yas-compile-directory . ido)
        ))

;; helm-gtags ==begin
;; customize
(setq helm-c-gtags-path-style 'relative)
(setq helm-c-gtags-ignore-case t)
(setq helm-c-gtags-read-only t)
;; helm-gtags ==end


(add-hook 'c-mode-common-hook (lambda () (helm-gtags-mode)))

;; key bindings
(add-hook 'helm-gtags-mode-hook
          '(lambda ()
              (local-set-key (kbd "M-t") 'helm-gtags-find-tag)
              (local-set-key (kbd "M-r") 'helm-gtags-find-rtag)
              (local-set-key (kbd "M-s") 'helm-gtags-find-symbol)
              (local-set-key (kbd "C-t") 'helm-gtags-pop-stack)
              (local-set-key (kbd "C-c C-f") 'helm-gtags-pop-stack)))
;; ==end

(if *emacs24*
    (progn
      (autoload 'helm-c-yas-complete "helm-c-yasnippet" nil t)
      (global-set-key (kbd "C-x C-o") 'helm-find-files)
      (global-set-key (kbd "C-c f") 'helm-for-files)
      (global-set-key (kbd "C-c y") 'helm-c-yas-complete)
      (global-set-key (kbd "C-c C-g") 'helm-ls-git-ls)
      (global-set-key (kbd "C-c i") 'helm-imenu)
      )
  (global-set-key (kbd "C-x C-o") 'ffap)
  )
(provide 'init-helm)
