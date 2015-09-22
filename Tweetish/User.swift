//
//  User.swift
//  Tweetish
//
//  Created by Bill Eager on 9/14/15.
//  Copyright (c) 2015 Bill Eager. All rights reserved.
//

import UIKit

var _currentUser: User?
let currentUserKey = "kCurrentUserKey"
let userDidLoginNotification = "userDidLoginNotification"
let userDidLogoutNotification = "userDidLogoutNotification"

class User: NSObject {
    var name: String?
    var screenName: String?
    var profileImageUrl: String?
    var profileBackgroundImageUrl: String?
    var tagline: String?
    var dictionary: NSDictionary?
    
    var tweetsCount: Int?
    var followersCount: Int?
    var followingCount: Int?
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        name = dictionary["name"] as? String
        screenName = dictionary["screen_name"] as? String
        profileImageUrl = dictionary["profile_image_url_https"] as? String
        profileBackgroundImageUrl = dictionary["profile_background_image_url_https"] as? String
        tagline = dictionary["description"] as? String
        
        tweetsCount = dictionary["statuses_count"] as? Int
        followersCount = dictionary["followers_count"] as? Int
        followingCount = dictionary["friends_count"] as? Int
    }
    
    func logout() {
        User.currentUser = nil
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        NSNotificationCenter.defaultCenter().postNotificationName(userDidLogoutNotification, object: nil)
    }
    
    class var currentUser: User? {
        get {
            if _currentUser == nil {
                let data = NSUserDefaults.standardUserDefaults().objectForKey(currentUserKey) as? NSData
                if data != nil {
                    let dictionary = (try! NSJSONSerialization.JSONObjectWithData(data!, options: [])) as! NSDictionary
                    _currentUser = User(dictionary: dictionary)
                }
            }
            return _currentUser
        }
        set (user) {
            _currentUser = user
            
            if _currentUser != nil {
                let data = try? NSJSONSerialization.dataWithJSONObject(user!.dictionary!, options: [])
                NSUserDefaults.standardUserDefaults().setObject(data, forKey: currentUserKey)
            } else {
                NSUserDefaults.standardUserDefaults().setObject(nil, forKey: currentUserKey)
            }
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
}
