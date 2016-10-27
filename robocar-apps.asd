#|
  This file is a part of robocar-apps project.
  Copyright (c) 2016 Hiroshi Kimura
|#

#|
  Author: Hiroshi Kimura
|#

(in-package :cl-user)
(defpackage robocar-apps-asd
  (:use :cl :asdf))
(in-package :robocar-apps-asd)

(defsystem robocar-apps
:version "0.3.5"
  :author "Hiroshi Kimura"
  :license "GPL2"
  :depends-on (:hunchentoot
               :cl-who
               :cl-ppcre
               :cl-mongo)
  :components ((:module "src"
                :components
                ((:file "robocar-apps")
                 (:file "assignments")
                 (:file "seats")
                 (:file "groups"))))
  :description "robocar app collection"
  :long-description
  #.(with-open-file (stream (merge-pathnames
                             #p"README.markdown"
                             (or *load-pathname* *compile-file-pathname*))
                            :if-does-not-exist nil
                            :direction :input)
      (when stream
        (let ((seq (make-array (file-length stream)
                               :element-type 'character
                               :fill-pointer t)))
          (setf (fill-pointer seq) (read-sequence seq stream))
          seq)))
  :in-order-to ((test-op (test-op robocar-apps-test))))
