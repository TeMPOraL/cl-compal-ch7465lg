(in-package #:cl-compal-ch7465lg)

(defparameter *modem-ip* "192.168.0.1" "Configure the modem/router IP in the local network here.")
(defparameter *modem-session-token* "")
(defparameter *cookie-jar* (make-instance 'drakma:cookie-jar))

(define-constant +function-hack-login+ "3" :test #'string=)
(define-constant +function-list-connected-devices+ "123" :test #'string=)
(define-constant +getter+ "/xml/getter.xml" :test #'string=)
(define-constant +setter+ "/xml/setter.xml" :test #'string=)


;;; Internals

(defun compal-get-request (fun)
  (let ((response (%get-request fun)))
    (if (valid-response-p response)
        response
        (progn (login)
               (compal-get-request fun)))))

(defun %get-request (fun)
  "Just make the request and update cookies / session token."
  (prog1 (drakma:http-request (concatenate 'string "http://" *modem-ip* +getter+)
                              :method :post
                              :parameters `(("token" . ,*modem-session-token*)
                                            ("fun" . ,fun))
                              :cookie-jar *cookie-jar*)
    (setf *modem-session-token* (drakma:cookie-value (find "sessionToken"
                                                           (drakma:cookie-jar-cookies *cookie-jar*)
                                                           :key #'drakma:cookie-name
                                                           :test #'string-equal)))))

(defun valid-response-p (response-string)
  "We assume anything that starts with the string '<?xml' is the result we're looking for.

Hacky as hell, but hey - it works."
  (and (> (length response-string) 4)
       (string-equal "<?xml" response-string :end2 5)))


(defun login ()
  "'Login' to the router.

This is not a true login; we're abusing the fact that this router is buggy and will happily
spit out a valid session token for any random request. We just use that random call to
initialize the cookie jar / `*MODEM-SESSION-TOKEN*' variable."
  (%get-request +function-hack-login+))


;;; Exported functions

(defun device-info ()
  ;; TODO
  )

(defun list-devices ()
  "Return a list of devices with IP leases on the router as an alist of following structure:
((:ethernet . (<device> <device> ...))
 (:wifi . (<device> <device> ...)))
where <device> == an alist of its properties."
  (labels ((plump-sexp-into-alist (list)
             (mapcar (lambda (element)
                       (cons (car element)
                             (cadr element)))
                     list))
           (device-root-to-list-of-devices (root)
             (when root
               (map 'list
                    (lambda (item)
                      (plump-sexp-into-alist (cdr (plump-sexp:serialize item))))
                    (plump:children root)))))
    (let* ((results (plump:parse (compal-get-request +function-list-connected-devices+)))
           (ethernet-devices (first (plump:get-elements-by-tag-name results "Ethernet")))
           (wifi-devices (first (plump:get-elements-by-tag-name results "WIFI"))))
      `((:ethernet . ,(device-root-to-list-of-devices ethernet-devices))
        (:wifi . ,(device-root-to-list-of-devices wifi-devices))))))
