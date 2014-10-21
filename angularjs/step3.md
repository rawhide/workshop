## step3 Firebaseを使ってみる

### Firebaseとは何か？
* アプリのバックエンド側を提供してくれるサービス
* 具体的にはdatabaseやsocket.io、ログイン機能など
* ある程度までは無料

### 使い方
* 公式サイトからユーザー登録
* 公式サイトのdashboardで、アプリ名とURLを登録する
* angularjs, firebase, angularfireを読み込む（今回はcdn）
* angular側でfirebaseを読み込む

### Tweetアプリのイメージ
* step1のTodoアプリからちょっとだけパワーアップ
* データの保存
* リアルタイムで同期

### Tweetモデル
* Tweetのデータを管理するモデル
* $firebaseをDI
* Firebaseオブジェクトを作成する

### controller
* todoアプリと基本的には同じ
* TweetモデルをDIする
* $add, $removeを使う
