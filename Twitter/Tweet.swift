//
//  Tweet.swift
//  Twitter
//
//  Created by ximin_zhang on 8/16/16.
//  Copyright © 2016 ximin_zhang. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    
    var text: NSString?
    var timestamp: NSDate?
    var retweetCount: Int = 0
    var favoritesCount: Int = 0
    var user: User?
    var statusid: NSString?
    var liked: Bool?
    var elapsedTimeString: String!

    init(dictionary: NSDictionary) {

        print(dictionary)

        text = dictionary["text"] as? String
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favoritesCount = (dictionary["favorite_count"] as? Int) ?? 0
        statusid = "\(dictionary["id_str"]!)"

        // Date formatting
        let timestampString = dictionary["created_at"] as? String
        print("timestampString: \(timestampString)")
        let formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM dd HH:mm:ss Z y"
        if let timestampString = timestampString {
            timestamp =  formatter.dateFromString(timestampString)
            print("timestamp: \(timestamp)")
        }

        /* find out and place date format from
         * http://userguide.icu-project.org/formatparse/datetime
         */
        let date = formatter.dateFromString(timestampString!)
        let elapsedTime = NSDate().timeIntervalSinceDate(date!)
        let sinh = Double(3600)
        let sind = Double(3600 * 24)
        if(elapsedTime < sinh) {
            let m = Int(elapsedTime / 60)
            elapsedTimeString = "\(m)m"
        }else if(elapsedTime < Double(sind)) {
            let h = Int(elapsedTime / sinh)
            elapsedTimeString = "\(h)h"
        }else {
            let d = Int(elapsedTime / sind)
            elapsedTimeString = "\(d)d"
        }

        let _user = dictionary["user"] as! NSDictionary
        self.user = User(dictionary: _user)

    }

    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()

        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)

            tweets.append(tweet)
        }

        return tweets
    }

}


