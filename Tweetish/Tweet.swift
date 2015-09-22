//
//  Tweet.swift
//  Tweetish
//
//  Created by Bill Eager on 9/14/15.
//  Copyright (c) 2015 Bill Eager. All rights reserved.
//

import UIKit
class Tweet: NSObject {
    
    var user: User?
    var text: String?
    var createdAtString: String?
    var createdAt: NSDate?
    var timestamp: String?
    var favoriteCount: Int?
    var retweetCount: Int?
    var favorited: Bool?
    var retweeted: Bool?
    var id: Int?
    
    var dictionary: NSDictionary
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        user = User(dictionary: dictionary["user"] as! NSDictionary)
        text = dictionary["text"] as? String
        createdAtString = dictionary["created_at"] as? String
        id = dictionary["id"] as? Int
        favoriteCount = dictionary["favorite_count"] as? Int
        retweetCount = dictionary["retweet_count"] as? Int
        favorited = dictionary["favorited"] as? Bool
        retweeted = dictionary["retweeted"] as? Bool
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        createdAt = formatter.dateFromString(createdAtString!)
    }
    
    class func tweetsWithArray(array: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dictionary in array {
            tweets.append(Tweet(dictionary: dictionary))
        }
        
        return tweets
    }
    
    func getCompactDate() -> String {
        if createdAt == nil {
            return ""
        }
        let units: NSCalendarUnit = [NSCalendarUnit.Minute, NSCalendarUnit.Hour, NSCalendarUnit.Day, NSCalendarUnit.Month]
        let components: NSDateComponents = NSCalendar.currentCalendar().components(units, fromDate: createdAt!, toDate: NSDate(), options: [])

        if (components.month > 0) {
            return "\(components.month)m"
        } else if (components.day > 0) {
            return "\(components.day)d"
        } else if (components.hour > 0) {
            return "\(components.hour)h"
        } else if (components.minute > 0) {
            return "\(components.minute)m"
        } else {
            return "Now"
        }
    }
}