# Robocar-Apps

バラバラに書いていた情報処理応用（ロボカー）授業用の web アプリ をまとめる。

* コードの重複を避ける
* hunchentoot の複数立ち上げを抑制する
* vm2016 のポート使用を抑制する
* web アプリケーションごとに nginx を設定する煩わしさを軽減する

## FORGET

* 認証をどうやってるんだっけ？

## start

M-x slime
CL-USER> (ql:quickload :robocar-apps)

## port forward required

これ、やめよう。2018-10-06

```sh
$ ssh -f -N -L 27017:localhost:27017 user@mongodb.host
```

## FIXME

* インストールしたサーバ上では有効な css が localhost では無効。

## Usage

## Installation

## Author

* Hiroshi Kimura

## Copyright

Copyright (c) 2016-2018 Hiroshi Kimura

