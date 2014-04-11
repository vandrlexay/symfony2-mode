; Symfony 2 support for emacs
; author Danil Orlov zargener@gmail.com

(defgroup symfony2 nil
  "Symfony2 Development."
  :group 'programming)

(defcustom symfony2-php-style
  '((c-offsets-alist . ((case-label . +)
                        (arglist-intro . +)
                        (arglist-cont-nonempty . c-lineup-math)
                        (arglist-close . c-lineup-close-paren)
                        )))
  "PSR coding style."
  :group 'symfony2)


(defun symfony2-goto-template ()
  "Go to template file for current controller action"
  (interactive)
  (let ((action-name "")
        (file-path (buffer-file-name))
        (controller-name "")
        (view-name ""))
    (save-excursion
      (cond ((re-search-backward "public +function +\\(.*?\\)Action" nil t)
            (progn
              (setq action-name 
                    (buffer-substring-no-properties 
                     (match-beginning 1) (match-end 1)))
              (setq controller-name (car 
                                     (split-string (car (reverse (split-string file-path "/"))) "Controller")))
              (setq file-path (mapconcat 'identity (reverse (cdr (cdr (reverse (split-string file-path "/"))))) "/"))
              (setq view-name (concat 
                        file-path 
                        "/Resources/views/" 
                        controller-name
                        "/"
                        action-name
                        ".html.twig"))
              (cond ((file-exists-p view-name)
                     (find-file view-name))
                    ((y-or-n-p 
                      (concat "Create view file " view-name)) 
                     (find-file view-name)))))
            (t (message "No action found"))))))



(define-derived-mode symfony2-mode
  php-mode "Sf2"
  "Major mode for working with Symfony2.
\\{symfony2-mode-map}"

  ;; set coding style
  (c-set-style "symfony2-php-style")
  (set 'tab-width 4)
  (set 'c-basic-offset 4)
  (set 'indent-tabs-mode nil)

  ;; set keybindings
  (local-set-key (kbd "M-s t") 'symfony2-goto-template)
)

(c-add-style "symfony2-php-style" symfony2-php-style)

(provide 'symfony2-mode)
