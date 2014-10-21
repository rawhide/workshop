## step1 Todoアプリを作ってみる

### 実装のイメージ
* Todoの追加
* Todoリストを表示する
* Todoの削除
* 編集機能はなしで

### Todoの追加
* 基本はhtmlのform(input, button)を使う
* 入力された文字をプログラムに渡すには -> ng-model
* ボタンが押されたら、処理を実行するには -> ng-click
* viewで使いたい変数や関数を定義するには -> controller

### Todoリストを表示する
* Todoを1個ずつ表示する -> ng-repeat

### Todoの削除
* どのTodoのボタンが押されたか判別するには -> $index
