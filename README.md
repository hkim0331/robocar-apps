# Robocar-Apps

バラバラに書いていた情報処理応用（ロボカー）授業用の web アプリ をまとめる。

* コードの重複を避ける
* hunchentoot の複数立ち上げを抑制する
* vm2016 のポート使用を抑制する
* web アプリケーションごとに nginx を設定する煩わしさを軽減する

## Usage

## Installation


## FIXME

* [2018-06-29] etc/port-forward-mongodb 中にExecStop エントリを作って
  いない。

* mongodb のデータベースコレクション設計変更
  m1: m2: m3: やめて members: [] に。

* groups グループ名に長さ制限

## DONE

* [2018-06-29] port forward コマンドの起動を systemctl で。

    ```sh
    $ ssh -f -N -L 27017:localhost:27017 user@mongodb.host
    ```

## Author

* Hiroshi Kimura

## Copyright

Copyright (c) 2016 Hiroshi Kimura
