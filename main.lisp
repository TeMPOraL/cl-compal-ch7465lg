(in-package #:cl-compal-ch7465lg)

;;; TODO.

(defparameter *modem-ip* "192.168.0.1")
(defparameter *modem-pin* "12345")

(define-constant +function-list-connected-devices+ 123)
(define-constant +getter+ "getter.xml" :test #'string=)
(define-constant +setter+ "setter.xml" :test #'string=)

(defun device-info ()
  ;; TODO do a request
  )

(defun list-devices ()
  ;; TODO log in if not logged in
  ;; TODO do a request
  )
