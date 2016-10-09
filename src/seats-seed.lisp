(in-package :robocar-apps)

(defparameter +year+ #(2016 2017))
(defparameter +term+ #("q3" "q4"))
(defparameter +sid+  #("hkim" "miyuki" "akari" "isana" "aoi"))
(defparameter +wday+ #("Mon" "Tue" "Wed" "Thu" "Fri"))
(defparameter +hour+ #(1 2 3 4 5 0))
(defparameter +date+ #("2016-09-14" "1985-10-26" "1962-04-20"))

(defparameter +c-2b+
  (apply #'vector
         (mapcar (lambda (n) (format nil "10.27.100.~a" n)) (range 100))))

(defparameter +c-2g+
  (apply #'vector
         (mapcar (lambda (n) (format nil "10.27.102.~a" n)) (range 100))))

(defun choose (v)
  (elt v (random (length v))))

;; (db.insert collection doc)
(defun seed (ip)
  (with-db-ucome
      (let ((doc (make-document)))
      (add-element "sid" (choose +sid+))
      (add-element "uhour" (format nil "~a~a"
                                   (choose +wday+)
                                   (choose +uhour+)))
      (add-element "date" (choose +date+))
      (add-element "ip" (choose +p+))
      (db.insert (format nil
                         "~a_~a"
                         (choose +term+)
                         (choose +year+))))))

(defun isc-seats-seeds (n)
  (dotimes (i n)
    (seed +c-2b+)
    (seed +c-2g+)))
