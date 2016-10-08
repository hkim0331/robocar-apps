#|
  This file is a part of robocar-apps project.
  Copyright (c) 2016 Hiroshi Kimura
|#

(in-package :cl-user)
(defpackage robocar-apps-test-asd
  (:use :cl :asdf))
(in-package :robocar-apps-test-asd)

(defsystem robocar-apps-test
  :author "Hiroshi Kimura"
  :license ""
  :depends-on (:robocar-apps
               :prove)
  :components ((:module "t"
                :components
                ((:test-file "robocar-apps"))))
  :description "Test system for robocar-apps"

  :defsystem-depends-on (:prove-asdf)
  :perform (test-op :after (op c)
                    (funcall (intern #.(string :run-test-system) :prove-asdf) c)
                    (asdf:clear-system c)))
