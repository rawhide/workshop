//
//  APIRouter.swift
//  Twitter
//
//  Created by Kazuya Tateishi on 2015/05/21.
//  Copyright (c) 2015年 Kazuya Tateishi. All rights reserved.
//

import Foundation
import Alamofire

enum APIRouter: URLRequestConvertible {
    case Tweets()
    case CreateTweets([String: AnyObject]?)
    
    var URLRequest: NSURLRequest {
        let (method: Alamofire.Method, path: String, parameters: [String: AnyObject]?) = {
            switch self {
            case .Tweets(): return (.GET, "api/v1/tweets", nil)
            case .CreateTweets(let params): return (.POST, "api/v1/tweets", params)
            }
            }()
        
        let URL = NSURL(string: "http://localhost:3000/")!
        let URLRequest = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(path))
        URLRequest.HTTPMethod = method.rawValue
        let encoding = Alamofire.ParameterEncoding.URL
        
        return encoding.encode(URLRequest, parameters: parameters).0
    }
}