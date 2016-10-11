(in-package :robocar-apps)

(defvar *cookie* "robocar-2016")
(defvar *cols* 80)
(defvar *rows* 20)

(define-easy-handler (assignments-new :uri "/assignments/new") ()
  (let ((sid (cookie-in *cookie*)))
    (standard-page
           (:title "グループ課題提出")
           (:form :method "post" :action "/assignments/create"
                  (:p "学生番号" (:input :name "sid" :value sid))
                  (:p "課題番号" (:input :name "num"))
                  (:textarea
                   :name "answer" :rows *rows* :cols *cols*
                   :placeholder "回答をここにコピーペーストしたら送信ボタン")
                  (:br)
                  (:input :type "submit" :value "送信")))))

;; stop me! ultra dasa!!
;; should go robocar-apps.lisp?
(defun gid-from-sid (sid)
  (with-db-ucome
      (or
       (first (get-element "gid" (docs (db.find *groups* ($ ($ "status" 1) ($ "m1" sid))))))
       (first (get-element "gid" (docs (db.find *groups* ($ ($ "status" 1) ($ "m2" sid))))))
       (first (get-element "gid" (docs (db.find *groups* ($ ($ "status" 1) ($ "m3" sid)))))))))

(define-easy-handler (assignments-create :uri "/assignments/create")
    (sid num answer)
  (let ((gid (gid-from-sid sid)))
    (with-db-ucome
        (let ((doc (make-document)))
          (add-element "sid" sid doc)
          (add-element "gid" gid doc)
          (add-element "num" num doc)
          (add-element "answer" answer doc)
          (db.insert *answers* doc)))
    (set-cookie *cookie* :value sid)
    (standard-page
        (:title "Received")
      (:p "学生番号: " (str sid))
      (:p "グループ番号: " (str gid))
      (:p "課題番号: " (str num))
      (:p "回答: ")
      (:pre (str answer))
      (:p (:a :href "/index" "back")))))
