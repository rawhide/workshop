Ruby on Rails 入門
------------------------------------

# はじめての Ruby on Rails


## Rails の基本理念

* DRY（Don't Repeat Yourself）- 同じことを繰り返さない
* CoC（Convention over Configuration）- 設定より規約

この理念に従うことでRailsのたくさんの恩恵を受けることができます。

## MVC

* Model - Viewの処理以外のすべての処理を行います。(注意：ActiveRecord::Baseだけではない。)
* View - インターフェイスに関わる処理を行います。
* Controller - ViewとModelを制御します。





<a name="#section-2"></a>
# Rails でアプリを作ってみる


## プロジェクトの作成

demoというプロジェクトを作成します。

```
$ mkdir demo; cd demo
$ echo demo > .rbenv-gemsets # gem を管理するための設定です。
$ rbenv local 2.1.4 # demo プロジェクト内で Ruby のバージョン 2.1.4 に固定します。
$ gem install bundler
$ gem install rails
$ rails new .
```

## データベースの作成

``` config.database.yml ``` の設定をからデータベースが作られます。

```
$ rake db:create
```

## サーバー起動

Rails には WEBrick という Web サーバが付属していて、以下のコマンドで起動することができます。

```
$ rails s
```

ポート番号はデフォルトで 3000 になっていますが、これはオプションで変更することができます。

```
$ rails s -p 3001
```

## 確認

```rails s``` 後に [http://localhost:3000](http://localhost:3000) にアクセスしてください。

## 掲示板機能の作成

```
$ rails g scaffold MessageBoard title:string body:text
```

以下のようなファイルが生成されます。(一部省略)

```
app/assets/javascripts/message_boards.js.coffee
app/assets/stylesheets/message_boards.css.scss
app/controllers/message_boards_controller.rb
app/helpers/message_boards_helper.rb
app/models/message_board.rb
app/views/message_boards
app/views/message_boards/index.html.erb
app/views/message_boards/edit.html.erb
app/views/message_boards/show.html.erb
app/views/message_boards/new.html.erb
app/views/message_boards/_form.html.erb
db/migrate/20141129091416_create_message_boards.rb
```

## マイグレート

db/migrate/20141129091416_create_message_boards.rb の内容がデータベースに反映されます。

```
$ rake db:migrate
```
