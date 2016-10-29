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
    (if (and gid
             (ppcre:scan-to-strings "\\S" num)
             (ppcre:scan-to-strings "\\S" answer))
        (progn
          (with-db-ucome
              (let ((doc (make-document)))
                (add-element "sid" sid doc)
                (add-element "gid" gid doc)
                (add-element "num" num doc)
                (add-element "answer" answer doc)
                (add-element "date" (now) doc)
                (db.insert *answers* doc)))
          (set-cookie *cookie* :value sid)
          (standard-page
           (:title "Received")
           (:p "学生番号: " (str sid))
           (:p "グループ番号: " (str gid))
           (:p "課題番号: " (str num))
           (:p "受付時間: " (str (now)))
           (:p "回答: ")
           ;; hotfix 0.3.2, escape '<' character.
           (:pre (str (cl-ppcre:regex-replace-all "<" answer "&lt;")))
           (:p (:a :href "/index" "back"))))
        (standard-page
         (:title "Error")
         (:p "グループ番号が見つからないか、")
         (:p "もしくは課題番号がないか、")
         (:p "カラ回答です。")
         (:p "ブラウザの戻るボタンで前のページに戻り、学生番号等をチェック後、再送信してください。")))))
