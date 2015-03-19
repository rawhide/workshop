Web API 側実装
-------------------------------

# Rails プロジェクト作成

```
$ mkdir api-demo;cd api-demo
$ echo api-demo > .rbenv-gemsets
$ rbenv local 2.2.0
$ gem install bundler
$ gem install rails
$ rails new . --skip-sprockets
```

# データベース作成

```
$ rake db:create
```

# ユーザテーブルの作成

```
$ rails g model User name:string email:string
$ rake db:migrate
```

# gem の追加

```ruby
gem 'grape'
gem 'grape-entity'
```

```
$ bundle install
```

# ディレクトリの作成

```
$ mkdir -p app/apis/api/v1
$ mkdir -p app/apis/entity/v1
```

# app/apiをオートロードに追加

```ruby
# config/application.rb

module ApiDemo
  class Application < Rails::Application
    ...
    # 以下を追加
    config.paths.add File.join('app', 'apis'), glob: File.join('**', '*.rb')
    config.autoload_paths += Dir[Rails.root.join('app', 'apis', '*')]
  end
end
```

# API のルーティング追加

```ruby
# config/routes.rb

Rails.application.routes.draw do
  mount API::Base => '/'
end
```

# API のルーティングを確認するタスクの追加

```ruby
# lib/tasks/routes.rake

namespace :api do
  desc 'API Routes'
  task routes: :environment do
    API::Base.routes.each do |api|
      method = api.route_method.ljust(10)
      path = api.route_path.gsub(':version', api.route_version)
      puts "     #{method} #{path}"
    end
  end
end
```

「rake api:routes」でgrapeで定義した API のルーティングを確認できる。  
API::Base クラスを作っていないのでこの時点ではエラーがでます。

# APIの実装

```ruby
# app/apis/api/base.rb

module API
  class Base < Grape::API
    format :json
    default_format :json

    prefix 'api'
    version 'v1', using: :path
  end
end
```

```ruby
# app/apis/entity/v1/users_entity.rb

module Entity
  module V1
    class UsersEntity < Grape::Entity
      expose :id, :name, :email
    end
  end
end
```

```ruby
# app/apis/api/v1/users.rb

module API
  module V1
    class Users < Grape::API
      resource :users do
        get do
          present User.all, with: Entity::V1::UsersEntity
        end
      end
    end
  end
end
```

```ruby
# app/apis/api/base.rb

module API
  class Base < Grape::API
    ...
    # 以下を追加
    mount V1::Users
  end
end
```



アプリ側実装
-------------------------------

テンプレートは Single View Application で言語は Swift を選択してプロジェクトを作成し、いったん Xcode を閉じる。  
ここでは api-demo というプロダクト名にする。

# Cocoapodsをインストールする

```
$ gem install cocoapods
```

# プロジェクトに移動する

先ほど作成した Xcode のプロジェクトに移動する。

```
$ cd api-demo
```

# Podfileを作成する

```
# Podfile

platform :ios, '8.0'
pod 'AFNetworking', '~> 2.0'
```

# ライブラリをインストールする

```
$ pod install
```

# プロジェクトを開く

```
$ open api-demo.xcworkspace
```

Xcode が起動する。

# Bridging-Headerを作る

[File] > [New] > [File...] > [iOS] > [Source] > [Header FIle]を選択し、Nextボタンをクリックする。

api-demo/api-demo 配下に 「Bridging-Header.h」という名前で保存する。

```
// Bridging-Header.h

#import <AFNetworking/AFNetworking.h>
```

[Build Settings] > [Swift Compiler - Code Generatioin] > [Objective-C Bridging Header]に「api-demo/Bridging-Header.h」を追加

※ 項目がない場合は全表示にすると表示される。

# UITableView を使う準備

UITableView はテーブル表示にしたい場合に使用します。  
今回はユーザ一覧の表示に使います。

```swift
// ViewController.swift

import UIKit

// UITableViewを使用する際はUITableViewDataSourceプロトコルとUITableViewDelegateプロトコルを実装する必要がある。
class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // 今回はテーブル表示にしたいので UITableView を使います。
    var tableView : UITableView?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        // 横幅、高さ、ステータスバーの高さを取得する
        let width: CGFloat! = self.view.bounds.width
        let height: CGFloat! = self.view.bounds.height
        let statusBarHeight: CGFloat! = UIApplication.sharedApplication().statusBarFrame.height

        self.tableView = UITableView(frame: CGRectMake(0, statusBarHeight, width, height - statusBarHeight))

        // デリゲートを指定する
        self.tableView!.delegate = self
        self.tableView!.dataSource = self

        // Cell名の登録をおこなう。
        self.tableView!.registerClass(UITableViewCell.self, forCellReuseIdentifier: "MyCell")

        // Viewに追加する。
        self.view.addSubview(self.tableView!)
    }

    // セルの総数を返す(表示するテーブルの行数)
    // UITableViewDataSource を使う場合は 必須
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    // 表示するセルを生成して返す
    // UITableViewDataSource を使う場合は 必須
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // UITableViewCellはテーブルの一つ一つのセルを管理するクラス。
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("MyCell", forIndexPath: indexPath) as UITableViewCell
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
```

# ユーザを保持するクラスの作成

[File] > [New] > [File...] > [iOS] > [Source] > [Swift File]を選択し、Nextボタンをクリックする。

api-demo/api-demo 配下に 「User.swift」という名前で保存する。

```swift
import UIKit

struct User {
    var name: String, email: String
}

class UserDataManager: NSObject {
    var users: [User]

    // シングルトンにする
    // UserDataManager.sharedInstanceで常に同じインスタンスを取り出すことができる。
    class var sharedInstance : UserDataManager {
        struct Static {
            static let instance : UserDataManager = UserDataManager()
        }
        return Static.instance
    }

    override init() {
        self.users = []
    }

    // ユーザーの総数を返す。
    var size : Int {
        return self.users.count
    }

    // 配列のように[n]で要素を取得できるようにする。
    subscript(index: Int) -> User {
        return self.users[index]
    }

    func set(user: User) {
        self.users.append(user)
    }
}
```

```swift
// ViewController.swift

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    ...
    var tableView : UITableView?

    var users = UserDataManager.sharedInstance

    ...
    // セルの総数を返す(表示するテーブルの行数)
    // UITableViewDataSource を使う場合は必須
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users.size
    }

    // 表示するセルを生成して返す
    // UITableViewDataSource を使う場合は必須
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // UITableViewCellはテーブルの一つ一つのセルを管理するクラス。
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("MyCell", forIndexPath: indexPath) as UITableViewCell

        // Cellに値を設定する.
        let user: User = self.users[indexPath.row] as User
        cell.textLabel?.text = user.email

        return cell
    }

    // 行が選択された際の処理
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let user = self.users[indexPath.row] as User
        // 行選択された際にログにメールアドレスを表示してみる
        println(user.email);
    }
    ...
}
```

# Web API へのリクエスト

```swift
// ViewController.swift

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    ...

    override func viewDidLoad() {
        ...
        self.view.addSubview(self.tableView!)

        self.request()
    }

    // Web API をコールする
    func request() {
        var result: NSArray?

        let manager:AFHTTPRequestOperationManager = AFHTTPRequestOperationManager()
        manager.GET("http://localhost:3000/api/v1/users", parameters: nil,
            success: { (operation: AFHTTPRequestOperation!, responsobject: AnyObject!) in
                result = (responsobject as NSArray)

                for (var i = 0; i < result?.count; i++) {
                    let dic: NSDictionary = result![i] as NSDictionary
                    var user: User = User(
                        name: dic["name"] as NSString,
                        email: dic["email"] as NSString
                    )
                    self.users.set(user)
                }

                // 画面をリロードする。
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableView!.reloadData()
                })
            },
            failure: { (operation: AFHTTPRequestOperation!, error: NSError!) in
                println(error.localizedDescription)
            }
        )
    }
    ...
```
