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
      ((null sid) (redirect "/assignments/login"))
      (t (standard-page
           (:title "Assignments:new")
           (:form :method "post" :action "/assignments/create"
                  (:input :name "sid" :value sid)
                  (:p "subject" (:input :name "subject"))
                  (:textarea :name "answer")
                  (:br)
                  (:input :type "submit")))))))

(define-easy-handler (assignments-create :uri "/assignments/create")
    (subject answer)
  (standard-page
      (:title "Assignment:Create")
    (:p "subject: " (str subject))
    (:p "answer: " (str answer))
    (:p (:a :href "new" "back")) ; must be changed.
    ))
