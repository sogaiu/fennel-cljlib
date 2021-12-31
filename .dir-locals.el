;;; Directory Local Variables
;;; For more information see (info "(emacs) Directory Variables")

((fennel-mode . (
                 ;; testing
                 (eval . (font-lock-add-keywords 'fennel-mode `((,(rx (syntax open-parenthesis) (group word-start "assert-eq" word-end)) 1 'font-lock-keyword-face))))
                 (eval . (font-lock-add-keywords 'fennel-mode `((,(rx (syntax open-parenthesis) (group word-start "assert-ne" word-end)) 1 'font-lock-keyword-face))))
                 (eval . (font-lock-add-keywords 'fennel-mode `((,(rx (syntax open-parenthesis) (group word-start "assert-is" word-end)) 1 'font-lock-keyword-face))))
                 (eval . (font-lock-add-keywords 'fennel-mode `((,(rx (syntax open-parenthesis) (group word-start "assert-not" word-end)) 1 'font-lock-keyword-face))))

                 (eval . (put 'deftest 'fennel-indent-function 'defun))
                 (eval . (font-lock-add-keywords 'fennel-mode `((,(rx (syntax open-parenthesis) (group word-start "deftest" word-end)) 1 'font-lock-keyword-face))))
                 (eval . (font-lock-add-keywords 'fennel-mode `((,(rx (syntax open-parenthesis)
                                                                      word-start "deftest" word-end
                                                                      (1+ space)
                                                                      (group (1+ (or (syntax word) (syntax symbol) "-" "_"))))
                                                                 1 'font-lock-function-name-face))))

                 (eval . (put 'testing 'fennel-indent-function 'defun))
                 (eval . (font-lock-add-keywords 'fennel-mode `((,(rx (syntax open-parenthesis) (group word-start "testing" word-end)) 1 'font-lock-keyword-face))))
                 (eval . (font-lock-add-keywords 'fennel-mode `((,(rx (syntax open-parenthesis) (group word-start "use-fixtures" word-end)) 1 'font-lock-keyword-face))))

                 ;; control-flow
                 (eval . (put 'when-some 'fennel-indent-function 1))
                 (eval . (font-lock-add-keywords 'fennel-mode `((,(rx (syntax open-parenthesis) (group word-start "when-some" word-end)) 1 'font-lock-keyword-face))))

                 (eval . (put 'if-some 'fennel-indent-function 1))
                 (eval . (font-lock-add-keywords 'fennel-mode `((,(rx (syntax open-parenthesis) (group word-start "if-some" word-end)) 1 'font-lock-keyword-face))))

                 (eval . (put 'when-let 'fennel-indent-function 1))
                 (eval . (font-lock-add-keywords 'fennel-mode `((,(rx (syntax open-parenthesis) (group word-start "when-let" word-end)) 1 'font-lock-keyword-face))))

                 (eval . (put 'if-let 'fennel-indent-function 1))
                 (eval . (font-lock-add-keywords 'fennel-mode `((,(rx (syntax open-parenthesis) (group word-start "if-let" word-end)) 1 'font-lock-keyword-face))))

                 (eval . (put 'loop 'fennel-indent-function 1))
                 (eval . (font-lock-add-keywords 'fennel-mode `((,(rx (syntax open-parenthesis) (group word-start "loop" word-end)) 1 'font-lock-keyword-face))))
                 (eval . (font-lock-add-keywords 'fennel-mode `((,(rx (syntax open-parenthesis) (group word-start "recur" word-end)) 1 'font-lock-keyword-face))))

                 ;; meta
                 (eval . (put 'when-meta 'fennel-indent-function 'defun))
                 (eval . (font-lock-add-keywords 'fennel-mode `((,(rx (syntax open-parenthesis) (group word-start "when-meta" word-end)) 1 'font-lock-keyword-face))))

                 (eval . (font-lock-add-keywords 'fennel-mode `((,(rx (syntax open-parenthesis) (group word-start "meta" word-end)) 1 'font-lock-keyword-face))))
                 (eval . (font-lock-add-keywords 'fennel-mode `((,(rx (syntax open-parenthesis) (group word-start "with-meta" word-end)) 1 'font-lock-keyword-face))))

                 ;; definitions
                 (eval . (put 'def 'fennel-indent-function 1))
                 (eval . (font-lock-add-keywords 'fennel-mode `((,(rx (syntax open-parenthesis) (group word-start "def" word-end)) 1 'font-lock-keyword-face))))

                 (eval . (put 'defonce 'fennel-indent-function 1))
                 (eval . (font-lock-add-keywords 'fennel-mode `((,(rx (syntax open-parenthesis) (group word-start "defonce" word-end)) 1 'font-lock-keyword-face))))

                 (eval . (put 'fn* 'fennel-indent-function 'defun))
                 (eval . (put 'fn* 'fennel-doc-string-elt 2))
                 (eval . (font-lock-add-keywords 'fennel-mode `((,(rx (syntax open-parenthesis) (group word-start "fn*" word-end)) 1 'font-lock-keyword-face))))
                 (eval . (font-lock-add-keywords 'fennel-mode `((,(rx (syntax open-parenthesis)
                                                                      word-start "fn*" word-end
                                                                      (1+ space)
                                                                      (group (1+ (or (syntax word) (syntax symbol) "-" "_"))))
                                                                 1 'font-lock-function-name-face))))


                 (eval . (put 'defn 'fennel-indent-function 'defun))
                 (eval . (put 'defn 'fennel-doc-string-elt 2))
                 (eval . (font-lock-add-keywords 'fennel-mode `((,(rx (syntax open-parenthesis) (group word-start "defn" word-end)) 1 'font-lock-keyword-face))))
                 (eval . (font-lock-add-keywords 'fennel-mode `((,(rx (syntax open-parenthesis)
                                                                      word-start "defn" word-end
                                                                      (1+ space)
                                                                      (group (1+ (or (syntax word) (syntax symbol) "-" "_"))))
                                                                 1 'font-lock-function-name-face))))

                 (eval . (put 'defmulti 'bfennel-indent-function 'defun))
                 (eval . (put 'defmulti 'fennel-doc-string-elt 2))
                 (eval . (font-lock-add-keywords 'fennel-mode `((,(rx (syntax open-parenthesis) (group word-start "defmulti" word-end)) 1 'font-lock-keyword-face))))
                 (eval . (font-lock-add-keywords 'fennel-mode `((,(rx (syntax open-parenthesis)
                                                                      word-start "defmulti" word-end
                                                                      (1+ space)
                                                                      (group (1+ (or (syntax word) (syntax symbol) "-" "_"))))
                                                                 1 'font-lock-function-name-face))))
                 (eval . (put 'defmethod 'fennel-indent-function 3))
                 (eval . (font-lock-add-keywords 'fennel-mode `((,(rx (syntax open-parenthesis) (group word-start "defmethod" word-end)) 1 'font-lock-keyword-face))))
                 (eval . (font-lock-add-keywords 'fennel-mode `((,(rx (syntax open-parenthesis)
                                                                      word-start "defmethod" word-end
                                                                      (1+ space)
                                                                      (group (1+ (or (syntax word) (syntax symbol) "-" "_"))))
                                                                 1 'font-lock-function-name-face))))
                 ;; try
                 (eval . (put 'try 'fennel-indent-function 0))
                 (eval . (font-lock-add-keywords 'fennel-mode `((,(rx (syntax open-parenthesis) (group word-start "try" word-end)) 1 'font-lock-keyword-face))))
                 (eval . (put 'catch 'fennel-indent-function 1))
                 (eval . (font-lock-add-keywords 'fennel-mode `((,(rx (syntax open-parenthesis) (group word-start "catch" word-end)) 1 'font-lock-keyword-face))))
                 (eval . (put 'finally 'fennel-indent-function 0))
                 (eval . (font-lock-add-keywords 'fennel-mode `((,(rx (syntax open-parenthesis) (group word-start "finally" word-end)) 1 'font-lock-keyword-face))))

                 ;; misc
                 (eval . (font-lock-add-keywords 'fennel-mode `((,(rx (syntax open-parenthesis) (group word-start "empty" word-end)) 1 'font-lock-keyword-face))))
                 (eval . (font-lock-add-keywords 'fennel-mode `((,(rx (syntax open-parenthesis) (group word-start "into" word-end)) 1 'font-lock-keyword-face)))))))
