(in-package :robocar-apps)

(defvar *coll* "rb_2016")
(defvar *number-of-robocars* 40)

(defun groups ()
  (with-db-ucome
      (docs (iter (cl-mongo:db.sort *coll*
                                  ($ "status" 1)
                                  :limit 0
                                  :field "gid"
                                  :asc t)))))

(define-easy-handler (groups-index :uri "/groups/index") ()
  (standard-page
      (:title "robocar 2016 groups")
    (:table
     :class "table table-hover"
     (:thead :class "thead-default"
             (:tr (:th "#")
                  (:th "robocar")
                  (:th "mem1")
                  (:th "mem2")
                  (:th "mem3")
                  (:th "group name")))
     (:tbody
      (dolist (g (groups))
        (htm
         (:tr
          (:td
           (:form :method "post" :action "/groups/delete"
                  (:input :type "submit"
                          :name "gid"
                          :value (str (get-element "gid" g)))))
          (:td (str (get-element "robocar" g)))
          (:td (str (get-element "m1" g)))
          (:td (str (get-element "m2" g)))
          (:td (str (get-element "m3" g)))
          (:td (str (get-element "name" g))))))))
    (:br)
    (:p (:a :class "btn btn-primary" :href "/groups/new" "new group"))))

;; FIXME: warn message
(define-easy-handler (group-disable :uri "/groups/delete") (gid)
  (multiple-value-bind (user pass) (authorization)
    (if (and (string= user "hkimura") (string= pass "pass"))
        (progn
          (with-db-ucome
              (cl-mongo:db.update *coll*
                                  ($ "gid" (parse-integer gid))
                                  ($set "status" 0)))
          (redirect "/groups/index"))
        (require-authorization))))

(define-easy-handler (group-new :uri "/groups/new") ()
  (multiple-value-bind (user pass) (authorization)
    (if (and (string= user "robocar") (string= pass "ikasumi"))
        (standard-page
            (:title "group:creation")
          (:form :method "post" :action "/groups/create"
                (:p "group name "
                    (:input :name "name" :placeholder "ユニークな名前"))
                (:p "member1 "
                    (:input :name "m1" :placeholder "学生番号半角8数字"))
                (:p "member2 "
                    (:input :name "m2" :placeholder "学生番号半角8数字"))
                (:p "member3 "
                    (:input :name "m3" :placeholder "学生番号半角8数字"))
                (:p (:input :type "submit" :value "create")))
         (:p (:a :href "/groups/index" "back")))
        (require-authorization))))

(defun unique? (key value)
  (with-db-ucome
      (not (docs (cl-mongo:db.find *coll* ($ ($ "status" 1) ($ key value)))))))

(defun unique-mem? (mem)
  (and (unique? "m1" mem)
       (unique? "m2" mem)
       (unique? "m3" mem)))

(defun unique-name? (name)
  (unique? "name" name))

(defun sid? (num)
  (cl-ppcre:scan "^[0-9]{8}$" num))

;;FIXME, ださい。
(defun validate (name m1 m2 m3)
  (and (unique-name? name)
       (unique-mem? m1)
       (or (string= "" m2) (and (sid? m2) (unique-mem? m2)))
       (or (string= "" m3) (and (sid? m3) (unique-mem? m3)))
       ))

(defun id-max ()
  (with-db-ucome
      (get-element
     "gid"
     (first (docs (cl-mongo:db.sort
                   *coll*
                   ($ "status" 1)
                   :limit 1
                   :field "gid"
                   :asc nil))))))

(define-easy-handler (group-create :uri "/groups/create") (name m1 m2 m3)
  (if (validate name m1 m2 m3)
      (with-db-ucome
          (let ((id (+ 1 (id-max))))
          (cl-mongo:db.insert
           *coll*
           ($ ($ "gid" id)
              ($ "robocar" (+ 1 (mod id *number-of-robocars*)))
              ($ "name" name)
              ($ "m1" m1)
              ($ "m2" m2)
              ($ "m3" m3)
              ($ "status" 1))))
        (redirect "/groups/index"))
      (standard-page
          (:title "warn")
        (:p "グループ名かメンバーに重複があります。")
        (:p "または学生番号打ち間違ったか。")
        (:p "ブラウザのバックボタンで元のページに戻ってやり直してください。")
        (:p "下の top で戻ると入力を捨てるから注意。")
        (:p (:a :href "/groups/index" "top")))
        ))
