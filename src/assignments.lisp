(in-package :robocar-apps)

;; (define-easy-handler (assignments-new :uri "/assignments/new") ()
;;     (standard-page
;;       (:title "Assignments:new")
;;       (:form :method "post" :action "/assignments/create"
;;            (:p "subject" (:input :name "subject"))
;;            (:textarea :name "answer")
;;            (:br)
;;            (:input :type "submit"))))

(defvar *cookie* "robocar-2016")
(defvar *cols* 60)
(defvar *rows* 20)

;; BUG?
(define-easy-handler (login :uri "/assignments/login") ()
  (multiple-value-bind (sid dummy) (authorization)
    (cond
      ((string= sid dummy)
       (set-cookie *cookie* :value sid :max-age 15552000)
       (redirect "/assignments/new"))
      (t (require-authorization)))))

(define-easy-handler (assignments-new :uri "/assignments/new") ()
  (let ((sid (cookie-in *cookie*)))
    (cond
      ((or (null sid) (string= "NIL" sid))
       (multiple-value-bind))
      (t (standard-page
           (:title "Assignments:new")
           (:form :method "post" :action "/assignments/create"
                  (:p "sid" (:input :name "sid" :value sid))
                  (:p "subject" (:input :name "subject"))
                  (:textarea :name "answer" :rows *rows* :cols *cols*)
                  (:br)
                  (:input :type "submit")))))))

(define-easy-handler (assignments-create :uri "/assignments/create")
    (sid subject answer)
  (standard-page
      (:title "Assignment:Create")
    (:p "sid: " (str sid))
    (:p "subject: " (str subject))
    (:p "answer: " (str answer))
    (:p (:a :href "new" "back")) ; must be changed.
    ))
