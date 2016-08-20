//
//  TwitterClient.swift
//  Twitter
//
//  Created by ximin_zhang on 8/16/16.
//  Copyright © 2016 ximin_zhang. All rights reserved.
//

import UIKit
import BDBOAuth1Manager


class TwitterClient: BDBOAuth1SessionManager {

    static let sharedInstance = TwitterClient(baseURL: NSURL(string: "https://api.twitter.com")!, consumerKey: "eb2cC3UOQPgJbe5hTFb2n7ioV", consumerSecret: "Wiwo0mNJtfd5cSHfdQqT46whXt0kNpXtIxnxbAcrNCukpEKxbj")

//    static let sharedInstance = TwitterClient(baseURL: NSURL(string: "https://api.twitter.com")!, consumerKey: "4To1isVaCqXe5E5ISJrcPpChh", consumerSecret: "ZpGekfErj4tCt7ktAOloaeRi0DL16IJQp3gPHgKSQ2CZwLsV5z")

    var loginSuccess: (() -> ())?
    var loginFailure: ((NSError) -> ())?

    // Login Part I
    func login(success: () -> (), failure: (NSError) -> ()) {

        loginSuccess = success
        loginFailure = failure

        deauthorize()

        //  NSURL(string: "twitter://oauth")!
        fetchRequestTokenWithPath("oauth/request_token", method:
            "GET", callbackURL: NSURL(string: "twitterdemo://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) in
                print("I got a token")

                let url = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")!
                UIApplication.sharedApplication().openURL(url)

        }) { (error: NSError!) in
            print("error: \(error.localizedDescription)")
            self.loginFailure!(error)
        }

    }

    func logout() {
        User.currentUser = nil
        deauthorize()

        NSNotificationCenter.defaultCenter().postNotificationName(User.userDidLogoutNotification, object: nil)

    }

    // Login part II
    func handleOpenUrl(url: NSURL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential!) in

            self.currentAccount({ (user: User) in

                User.currentUser = user
                self.loginSuccess?()
                }, failure: { (error: NSError) in
                    self.loginFailure?(error)
            })

            self.loginSuccess?() // envoke

            //            print("I got the access token!")
            //            self.homeTimeline({ (tweets: [Tweet]) in
            //                for tweet in tweets {
            //                    print(tweet.text)
            //                }
            //                }, failure: { (error: NSError) in
            //                    print("error: \(error.localizedDescription)")
            //            })
            //
            //            self.currentAccount()

        }) { (error: NSError!) in
            //            print(error.localizedDescription)
            self.loginFailure?(error)
        }
    }

    func currentAccount(success: (User) -> (), failure: (NSError) -> ()) {
        GET("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in

            //                    print("account: \(response)")
            //                    let user = response as! NSDictionary
            //                    print("name: \(user["name"])")

            let userDictionary = response as! NSDictionary
            let user = User(dictionary: userDictionary)


            success(user)
            print("name: \(user.name)")
            print("screenname: \(user.screenname)")
            print("profile url: \(user.profileUrl)")
            print("description: \(user.description)")

            }, failure: { (task: NSURLSessionDataTask?, error: NSError) in

                print(error.localizedDescription)
                failure(error)
        })
    }

    func homeTimeline(success: ([Tweet]) -> (), failure: (NSError) -> ()) {
        GET("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in

//            print(response)

            let dictionaries = response as! [NSDictionary]
            
            let tweets = Tweet.tweetsWithArray(dictionaries)
            
            success(tweets)
            
            //            for tweet in tweets {
            //                print("\(tweet.text)")
            //            }
            
        }) { (task: NSURLSessionDataTask?, error: NSError) in
            //            print("error: \(error.localizedDescription)")
            failure(error)
        }
    }

    func tweetWithCompletion(params: NSDictionary, completion: (response: AnyObject?, error: NSError?) -> ()){
        POST("1.1/statuses/update.json", parameters: params, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in

//            print(response)

        }) { (task: NSURLSessionDataTask?, error: NSError) in

            print("Error in replying to tweet: \(error.localizedDescription)")
        }
    }

    func retweet(params: NSDictionary, completion: (response: AnyObject?, error: NSError?) -> ()){
        
        POST("1.1/statuses/retweet/:id.json", parameters: params, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in

            print(response)

        }) { (task: NSURLSessionDataTask?, error: NSError) in

            print("Error in retweet: \(error.localizedDescription)")
            
        }
    }


    func userTimeline(success: ([Tweet]) -> (), failure: (NSError) -> ()) {
        GET("1.1/statuses/user_timeline.json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in

            let dictionaries = response as! [NSDictionary]

            let tweets = Tweet.tweetsWithArray(dictionaries)

            success(tweets)

        }) { (task: NSURLSessionDataTask?, error: NSError) in

            failure(error)
        }
    }

    func getUserInfo(params: NSDictionary, completion: (response: AnyObject?, error: NSError?) -> ()){
        POST("1.1/users/show.json", parameters: params, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in

            print(response)

        }) { (task: NSURLSessionDataTask?, error: NSError) in

            print("Error in getting user information: \(error.localizedDescription)")
            
        }
    }

    // Likes the status specified in the ID parameter as the authenticating user. Returns the liked status when successful. This process invoked by this method is asynchronous. The immediately returned status may not indicate the resultant liked status of the tweet. A 200 OK response from this method will indicate whether the intended action was successful or not.

//    func favorite(params: NSDictionary, completion: (response: AnyObject?, error: NSError?) -> ()){
//
//        POST("1.1/favorites/create.json", parameters: params, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
//
//            print(params)
//            print(response)
//
//        }) { (task: NSURLSessionDataTask?, error: NSError) in
//
//            print("Error in favorite: \(error.localizedDescription)")
//            print("Error in favorite: \(error.localizedFailureReason)")
//            
//        }
//    }

    func favorite(params: NSDictionary, success: (NSDictionary) -> (), failure: (NSError) -> ()){

        POST("1.1/favorites/create.json", parameters: params, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in

            let dictionary = response as! NSDictionary
            print(params)
            print(response)
            success(dictionary)

        }) { (task: NSURLSessionDataTask?, error: NSError) in

            print("Error in favorite: \(error.localizedDescription)")
            print("Error in favorite: \(error.localizedFailureReason)")
            failure(error)
            
        }
    }

    func unlike(params: NSDictionary, success: (NSDictionary) -> (), failure: (NSError) -> ()){

        POST("1.1/favorites/destroy.json", parameters: params, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in

            let dictionary = response as! NSDictionary
            print(params)
            print(response)
            success(dictionary)

        }) { (task: NSURLSessionDataTask?, error: NSError) in

            print("Error in unlike: \(error.localizedDescription)")
            print("Error in unlike: \(error.localizedFailureReason)")
            failure(error)
            
        }
    }

//    func unlike(success: (NSDictionary) -> (), failure: (NSError) -> ()){
//
//        GET("1.1/favorites/destroy.json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
//
//            let dictionary = response as! NSDictionary
//            success(dictionary)
//
//        }) { (task: NSURLSessionDataTask?, error: NSError) in
//
//            print("Error in unlike a status: \(error.localizedDescription)")
//            failure(error)
//            
//        }
//    }

    func getFavorite(success: ([NSDictionary]) -> (), failure: (NSError) -> ()){

        GET("1.1/favorites/list.json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in

            let dictionaries = response as! [NSDictionary]
            success(dictionaries)

        }) { (task: NSURLSessionDataTask?, error: NSError) in

            print("Error in favorite: \(error.localizedDescription)")
            print("Error in favorite: \(error.localizedFailureReason)")
            failure(error)
            
        }
    }

    func getTweetByID(params: NSDictionary, success: (NSDictionary) -> (), failure: (NSError) -> ()){

        GET("1.1/statuses/show.json", parameters: params, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in

            let dictionary = response as! NSDictionary
            success(dictionary)

        }) { (task: NSURLSessionDataTask?, error: NSError) in

            print("Error in favorite: \(error.localizedDescription)")
            print("Error in favorite: \(error.localizedFailureReason)")
            failure(error)
            
        }

    }



}



