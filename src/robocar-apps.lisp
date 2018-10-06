(in-package :cl-user)

(defpackage robocar-apps
  (:use :cl :hunchentoot :cl-who :cl-ppcre :cl-mongo))

(in-package :robocar-apps)

(defvar *version* "0.6.3")

;;http://lambdasakura.hatenablog.com/entry/20100122/1264134907
(defun my-getenv (name &optional default)
    #+CMU
    (let ((x (assoc name ext:*environment-list*
                    :test #'string=)))
      (if x (cdr x) default))
    #-CMU
    (or
     #+Allegro (sys:getenv name)
     #+CLISP (ext:getenv name)
     #+ECL (si:getenv name)
     #+SBCL (sb-unix::posix-getenv name)
     #+LISPWORKS (lispworks:environment-variable name)
     default))

;; コンパイル時の環境変数を反映する。
(defvar *mongodb-host* (my-getenv "ROBOCAR_APP_DB" "localhost"))

(defvar *db* "ucome")

;;must change annually.
(defvar *groups* "rb_2018")
(defvar *answers* "as_2018")

;;server object, just exit to kill.
(defparameter *http* nil)

(defun now ()
  (multiple-value-bind (s m h dd mm yy)
      (decode-universal-time (get-universal-time))
    (format nil "~d-~2,'0d-~2,'0d ~2,'0d:~2,'0d:~2,'0d" yy mm dd h m s)))

(defun today ()
  (subseq (now) 0 10))

(defmacro with-db-ucome (&rest rest)
  "mongodb://localhost:27017/ucome"
  `(with-mongo-connection
       (:host *mongodb-host* :port *mongo-default-port* :db *db*)
     ,@rest))

(defmacro navi ()
  `(htm (:p :class "navi"
         "[ "
         (:a :href "http://robocar.melt.kyutech.ac.jp" "robocar")
         " | "
         (:a :href "/index" "apps")
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
              :href "https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css"
              :integrity "sha384-MCw98/SFnGE8fJT3GXwEOngsV7Zt27NXFoaoApmYm81iuXoPkFOJwJ8ERdknLPMO"
              :crossorigin "anonymous")
       (:title "roobocar apps"))
      (:body
       (:div
        :class "container"
        (:h3 ,title)
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
  (setf (html-mode) :html5)
  (static-contents)
  (setf *http* (make-instance 'easy-acceptor :port port))
  (start *http*)
  (format t "robocar-apps start at http://localhost:~a" port))

(defun stop-server ()
  (stop *http*))

(define-easy-handler (index :uri "/index") ()
  (standard-page
      (:title "Robocar Apps")
    (:ul
     (:li (:a :href "/assignments/new" "グループ課題提出"))
     (:li (:a :href "/groups/index" "グループ一覧"))
     (:li (:a :href "/seats/index" "着席状況")))))

(defun main ()
  (start-server 20169)
  (loop (sleep 60)))

