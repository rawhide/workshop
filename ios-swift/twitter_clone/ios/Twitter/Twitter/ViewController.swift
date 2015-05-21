//
//  ViewController.swift
//  Twitter
//
//  Created by Kazuya Tateishi on 2015/05/21.
//  Copyright (c) 2015年 Kazuya Tateishi. All rights reserved.
//

import UIKit

import Alamofire

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    
    var tweets = TweetDataManager.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.dataSource = self
        tableView.delegate = self
        
        Alamofire.request(APIRouter.Tweets()).responseJSON { (request, response, data, error) in
            if let json = data as? Array<Dictionary<String,AnyObject>> {
                for j in json {
                    var tweet: Tweet = Tweet(
                        body: j["body"] as! String,
                        updated_at: j["updated_at"] as! String
                    )
                    self.tweets.set(tweet)
                }
                self.tableView.reloadData()
            }
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.size
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Cell")
        var tweet = tweets[indexPath.row]
        cell.textLabel?.text = tweet.body
        
        return cell
    }
    
    @IBAction func tweetButton(sender: UIButton) {
        var tweet: Dictionary = ["body": self.textField.text as String]
        
        self.textField.text = ""
        
        Alamofire.request(APIRouter.CreateTweets(tweet)).responseJSON { (request, response, data, error) in
            if let json = data as? Dictionary<String,AnyObject> {
                var tweet: Tweet = Tweet(
                    body: json["body"] as! String,
                    updated_at: json["updated_at"] as! String
                )
                self.tweets.set(tweet)
            }
            self.tableView.reloadData()
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
