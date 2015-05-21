//
//  Twitter.swift
//  Twitter
//
//  Created by Kazuya Tateishi on 2015/05/21.
//  Copyright (c) 2015年 Kazuya Tateishi. All rights reserved.
//

import Foundation
import UIKit

struct Tweet {
    var body: String, updated_at: String
}

class TweetDataManager: NSObject {
    var tweets: [Tweet]
    
    // シングルトンにする
    // TweetDataManager.sharedInstanceで常に同じインスタンスを取り出すことができる。
    class var sharedInstance : TweetDataManager {
        struct Static {
            static let instance : TweetDataManager = TweetDataManager()
        }
        return Static.instance
    }
    
    override init() {
        self.tweets = []
    }
    
    // ユーザーの総数を返す。
    var size : Int {
        return self.tweets.count
    }
    
    // 配列のように[n]で要素を取得できるようにする。
    subscript(index: Int) -> Tweet {
        return self.tweets[index]
    }
    
    func set(user: Tweet) {
        self.tweets.append(user)
    }
}