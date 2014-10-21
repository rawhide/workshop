## step2 factory

### factory
* MVCにおけるいわゆるModel
* 複雑な処理は、factory内に書く

### 例
* ログイン状態を管理するモデル(今回はダミー)
* ユーザーがログインしていたらメッセージを表示する
* ログインしているか -> Auth.isLoggedIn
* ログイン中ユーザーの情報 -> Auth.currentUser
* ログイン処理 -> Auth.login()

### DI
* dependency injection(依存性の注入)
* モデルから違うモデルを呼ぶには、宣言的に書かないといけない
* 大量にDIされているモデルやコントローラーは危ない
