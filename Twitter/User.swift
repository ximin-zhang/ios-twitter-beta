//
//  User.swift
//  Twitter
//
//  Created by ximin_zhang on 8/16/16.
//  Copyright © 2016 ximin_zhang. All rights reserved.
//

import UIKit

class User: NSObject {

    var id: NSString?
    var name: NSString?
    var screennameRaw: NSString?
    var screenname: NSString?
    var profileUrl: NSURL?
    var tagline: NSString?
    var followersCnt: NSString?
    var followingCnt: NSString?
    var tweetsCnt: NSString?
    var dictionary: NSDictionary?
    var profileBackgroundImageUrl: NSURL?

    init(dictionary: NSDictionary) {

        self.dictionary = dictionary
        self.name = dictionary["name"] as? String
        self.screennameRaw = "\(dictionary["screen_name"]!)"
        self.screenname = "@" + (dictionary["screen_name"] as? String)!

        let profileUrlString = dictionary["profile_image_url_https"] as? String

        if let profileUrlString = profileUrlString{
            self.profileUrl = NSURL(string: profileUrlString)
        }

        self.tagline = dictionary["description"] as? String

        self.id = "\(dictionary["id_str"]!)"
        self.followersCnt = "\(dictionary["followers_count"]!)"
        self.followingCnt = "\(dictionary["friends_count"]!)"
        self.tweetsCnt = "\(dictionary["statuses_count"]!)"

        let profileBackgroundImageUrlString = dictionary["profile_background_image_url_https"] as? String
        if let profileBackgroundImageUrlString = profileBackgroundImageUrlString{
            self.profileBackgroundImageUrl = NSURL(string: profileBackgroundImageUrlString)
        }


    }


    static let userDidLogoutNotification = "UserDidLogout"
    static var _currentUser: User?

    class var currentUser: User? {
        get {

            if _currentUser == nil {
                let defaults = NSUserDefaults.standardUserDefaults()

                let userData = defaults.objectForKey("currentUserData") as? NSData

                if let userData = userData {

                    let dictionary = try!
                        NSJSONSerialization.JSONObjectWithData(userData, options: [])
                        _currentUser = User(dictionary: dictionary as! NSDictionary)
                }
            }

            return _currentUser
        }


        set(user) {
            let defaults = NSUserDefaults.standardUserDefaults()

            if let user = user {

                let data = try! NSJSONSerialization.dataWithJSONObject(user.dictionary!, options: [])

                defaults.setObject(data, forKey: "currentUserData")

            } else {

                defaults.setObject(nil, forKey: "currentUserData")
                
            }
            
            defaults.synchronize()
        }

    }


}
