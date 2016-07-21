;;; cl-compal-ch7465lg.asd

(asdf:defsystem #:cl-compal-ch7465lg
  :serial t

  :long-name "Common Lisp tools for interfacing with Compal CH7465LG modem."
  :author "Jacek Złydach"
  :version "0.0.1"
  :description "Common Lisp tools for interfacing with Compal CH7465LG modem."

  :license "TBD"
  :homepage "https://github.com/TeMPOraL/cl-compal-ch7465lg"
  :bug-tracker "https://github.com/TeMPOraL/cl-compal-ch7465lg/issues"
  :source-control (:git "https://github.com/TeMPOraL/cl-compal-ch7465lg.git")
  :mailto "temporal.pl+clcompal@gmail.com"

  :encoding :utf-8
  
  :depends-on (#:alexandria
               #:drakma
               #:plump
               #:plump-sexp)

  :components ((:file "package")
               (:file "main")))
