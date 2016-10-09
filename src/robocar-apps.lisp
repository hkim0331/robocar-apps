(in-package :cl-user)

(defpackage robocar-apps
  (:use :cl :hunchentoot :cl-who :cl-ppcre :cl-mongo))

(in-package :robocar-apps)

(defvar *version* "0.1")
(defvar *http*)


(defmacro with-db-ucome (&rest rest)
  "mongodb://localhost:27017/ucome な感じ"
  `(with-mongo-connection
       (:host "localhost" :port *mongo-default-port* :db "ucome")
     ,@rest))

(defmacro navi ()
  `(htm (:p :class "navi"
         "[ "
         (:a :href "http://robocar-2016.melt.kyutech.ac.jp" "robocar")
         " | "
         (:a :href "index" "robocar apps")
         " | "
         (:a :href "http://www.melt.kyutech.ac.jp" "hkimura lab")
         " ]")))

(defmacro standard-page ((&key title) &body body)
  `(with-html-output-to-string
       (*standard-output* nil :prologue t :indent t)
     (:html
      :lang "ja"
      (:head
       (:meta :charset "utf-8")
       (:meta :http-equiv "X-UA-Compatible" :content "IE=edge")
       (:meta :name "viewport"
        :content "width=device-width, initial-scale=1.0")
       (:link :rel "stylesheet" :href "/default.css")
       (:link :rel "stylesheet" :href "/seats.css")
       (:link :rel "stylesheet" :href "/groups.css")
       (:link :rel "stylesheet"
        :href "//netdna.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css")
       (:title ,title))
      (:body
       (:div
        :class "container"
        (:h1 :class "page-header hidden-xs" "Robocar 2016 Apps")
        (navi)
        ,@body
        (:hr)
        (:span (format t "programmed by hkimura, ~a." *version*)))))))

(defun static-contents ()
    (push (create-static-file-dispatcher-and-handler
           "/default.css" "static/default.css") *dispatch-table*)
    (push (create-static-file-dispatcher-and-handler
           "/seats.css" "static/seats.css") *dispatch-table*)
    (push (create-static-file-dispatcher-and-handler
           "/groups.css" "static/groups.css") *dispatch-table*))

(defun start-server (&optional (port 8080))
;;  (cl-mongo:db.use "ucome")
  (setf (html-mode) :html5)
  (static-contents)
  (setf *http* (make-instance 'easy-acceptor :port port))
  (start *http*)
  (format t "robocar-apps start at http://localhost:~a" port))

(defun stop-server ()
  (stop *http*))

(define-easy-handler (index :uri "/index") ()
  (standard-page
      (:title "robocar-apps")
    (:p (:a :href "/assignments/new" "group assignments"))
    (:p (:a :href "/seats/index" "isc seats"))
    (:p (:a :href "/groups/index" "making groups"))))

(defun main ()
  (start-server 20169)
  (loop (sleep 60)))
