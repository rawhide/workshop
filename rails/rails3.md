Ruby on Rails 入門
------------------------------------


# ルーティング

```ruby
Rails.application.routes.draw do
  // scaffold した時これが追加されています。
  resources :message_boards
end
```

これで、以下のルーティング生成されます。
定義したルーティングは ``` rake routes ``` コマンドで確認することができます。

| HTTPメソッド | URL                 | アクション |
|--------|--------------------------|--------|
| GET    | /message_boards          | index  |
| POST   | /message_boards          | create |
| GET    | /message_boards/new      | new    |
| GET    | /message_boards/:id/edit | edit   |
| GET    | /message_boards/:id      | show   |
| PATCH  | /message_boards/:id      | update |
| PUT    | /message_boards/:id      | update |
| DELETE | /message_boards/:id      | destroy|


コントローラーに必要なアクションが index と create のみの場合は以下のようにします。

```ruby
resources :message_boards, only: [:index, :create]
```

これで index アクションと create アクションのルーティングのみ生成されます。

## アクションの追加

基本アクション以外のアクションを追加する場合は member および collection を使用します。

| リソースタイプ | 意味                                   |
|-------------|----------------------------------------|
| member      | 特定のデータを対象としたアクション(:idあり)  |
| collection  | 全てのデータを対象としたアクション(:idなし)  |

以下は message_boards コントローラーに search アクションと close アクションを追加する例です。

```ruby
resources :message_boards do
  get 'search', on: :collection
  patch 'close', on: :member
end
```

以下のようなルーティングが生成されます。

| HTTPメソッド | URL                 | アクション |
|--------|--------------------------|--------|
| GET    | /message_boards/search   | search |
| PATCH  | /message_boards/:id/close | close |
