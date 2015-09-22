//
//  TwitterClient.swift
//  Tweetish
//
//  Created by Bill Eager on 9/14/15.
//  Copyright (c) 2015 Bill Eager. All rights reserved.
//

import UIKit

let twitterConsumerKey = "PROVIDE"
let twitterConsumerSecret = "PROVIDE"
let twitterBaseURL = NSURL(string: "https://api.twitter.com")

class TwitterClient: BDBOAuth1RequestOperationManager {
   
    var loginCompletion: ((user: User?, error: NSError?) -> ())?
    var tweetCompletion: ((success: Bool?, error: NSError?) -> ())?
    
    class var sharedInstance: TwitterClient {
        struct Static {
            static let instance = TwitterClient(
                baseURL: twitterBaseURL,
                consumerKey: twitterConsumerKey,
                consumerSecret: twitterConsumerSecret
            )
        }
        
        return Static.instance
    }

    func homeTimelineWithCompletion(completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
        self.GET("1.1/statuses/home_timeline.json", parameters: nil, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            let tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
            print("\(response)")
            completion(tweets: tweets, error: nil)
            }, failure: { (operation:AFHTTPRequestOperation!, error:NSError!) -> Void in
            completion(tweets: nil, error: error)
        })
    }
    
    func mentionsTimelineWithCompletion(completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
        self.GET("1.1/statuses/mentions_timeline.json", parameters: nil, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            let tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
            print("\(response)")
            completion(tweets: tweets, error: nil)
            }, failure: { (operation:AFHTTPRequestOperation!, error:NSError!) -> Void in
                completion(tweets: nil, error: error)
        })
    }

    func userTweetsWithCompletion(user: User, completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
        self.GET("1.1/statuses/user_timeline.json", parameters: ["screen_name": user.screenName!], success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            let tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
            print("\(response)")
            completion(tweets: tweets, error: nil)
            }, failure: { (operation:AFHTTPRequestOperation!, error:NSError!) -> Void in
                completion(tweets: nil, error: error)
        })
    }
    
    func homeTimelineWithParams(params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
        
    }
    
    func postTweetWithStatus(status: String, inReplyTo: Tweet?, completion: (success: Bool?, error: NSError?) -> ()) {
        tweetCompletion = completion
        var parameters: [String: String] = ["status": status]
        
        if let inReplyTo = inReplyTo {
            parameters["in_reply_to_status_id"] = "\(inReplyTo.id!)"
        }
        self.POST("1.1/statuses/update.json", parameters: parameters, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            self.tweetCompletion?(success: true, error: nil)
            }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                self.tweetCompletion?(success: false, error: error)
        }
    }
    
    func favoriteTweetWithCompletion(tweet: Tweet, completion: (success: Bool?, error: NSError?) -> ()) {
        tweetCompletion = completion
        let parameters: [String: String] = ["id": "\(tweet.id!)"]
        print("\(parameters)")
        self.POST("1.1/favorites/create.json", parameters: parameters, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            self.tweetCompletion?(success: true, error: nil)
            }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                self.tweetCompletion?(success: false, error: error)
        }
    }
    
    func retweetTweetWithCompletion(tweet: Tweet, completion: (success: Bool?, error: NSError?) -> ()) {
        tweetCompletion = completion
        self.POST("1.1/statuses/retweet/\(tweet.id!).json", parameters: nil, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            self.tweetCompletion?(success: true, error: nil)
            }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                self.tweetCompletion?(success: false, error: error)
        }
    }
    
    func loginWithCompletion(completion: (user: User?, error: NSError?) -> ()) {
        loginCompletion = completion
        
        // Fetch request token and redirect to authz page
        self.requestSerializer.removeAccessToken()
        self.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "tweetish://oauth"), scope: nil
            , success: { (requestToken: BDBOAuth1Credential!) -> Void in
                let authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
                UIApplication.sharedApplication().openURL(authURL!)
            }, failure: { (error: NSError!) -> Void in
                self.loginCompletion?(user: nil, error: error)
        })
    }
    
    func openURL(url: NSURL) {
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuth1Credential(queryString: url.query), success: { (accessToken: BDBOAuth1Credential!) -> Void in
            print("Got access token!")
            self.requestSerializer.saveAccessToken(accessToken)
            
            self.GET("1.1/account/verify_credentials.json", parameters: nil, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                print("")
                    let user = User(dictionary: response as! NSDictionary)
                    User.currentUser = user
                    self.loginCompletion?(user: user, error: nil)
                }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                    self.loginCompletion?(user: nil, error: error)
            })
            
            }) { (error: NSError!) -> Void in
                self.loginCompletion?(user: nil, error: error)
            }
    }
    
}
