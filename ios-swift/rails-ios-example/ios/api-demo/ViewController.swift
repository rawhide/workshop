//
//  ViewController.swift
//  api-demo
//
//  Created by Kazuya Tateishi on 2015/03/19.
//  Copyright (c) 2015年 kzy52. All rights reserved.
//

import UIKit

// UITableViewを使用する際はUITableViewDataSourceプロトコルとUITableViewDelegateプロトコルを実装する必要がある。
class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // 今回はテーブル表示にしたいので UITableView を使います。
    var tableView : UITableView?
    
    var users = UserDataManager.sharedInstance
    
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
        
        self.request()
    }
    
    // セルの総数を返す(表示するテーブルの行数)
    // UITableViewDataSource を使う場合は 必須
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users.size
    }
    
    // 表示するセルを生成して返す
    // UITableViewDataSource を使う場合は 必須
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}