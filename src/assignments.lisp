(in-package :robocar-apps)

;; (define-easy-handler (assignments :uri "/assignments/index") ()
;;   (standard-page
;;       (:title "assignments")
;;     (:h1 "Assignments Page")
;;     ))

(define-easy-handler (assignments-new :uri "/assignments/new") ()
    (standard-page
      (:title "assignments:new")
    (:h1 "Assignments:New")
    (:form :method "post" :action "/assignments/create"
           (:p "subject" (:input :name "subject"))
           (:textarea :name "answer")
           (:br)
           (:input :type "submit"))))

(define-easy-handler (assignments-create :uri "/assignments/create")
    (subject answer)
  (standard-page
      (:title "Assignment:Create")
    (:h3 "Assignments:Create")
    (:p "subject: " (str subject))
    (:p "answer: " (str answer))
    (:p (:a :href "new" "back")) ; must be changed.
    ))
