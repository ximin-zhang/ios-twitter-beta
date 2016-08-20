//
//  TweetsViewController.swift
//  Twitter
//
//  Created by ximin_zhang on 8/17/16.
//  Copyright © 2016 ximin_zhang. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableView: UITableView!

    var tweets: [Tweet]!
    var user: [User]!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self

        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 300

        // Initialize a UIRefreshControl
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)

        TwitterClient.sharedInstance.homeTimeline({ (tweets: [Tweet]) in

            self.tweets = tweets

            refreshControl.addTarget(self, action: #selector(self.refreshControlAction(_:)), forControlEvents: UIControlEvents.ValueChanged)
            self.tableView.insertSubview(refreshControl, atIndex: 0)

            self.tableView.reloadData() // Important!!!

            }, failure: { (error: NSError) in
                print("error: \(error.localizedDescription)")
        })

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func onLogoutButton(sender: AnyObject) {

        TwitterClient.sharedInstance.logout()
    }


    @IBAction func onNewButton(sender: UIBarButtonItem) {


    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if tweets != nil {
            if (self.tweets.count > 20) {
                return 20
            }else {
                return self.tweets.count
            }
        } else {
            return 0
        }

    }

    //    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    //
    //    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as! TweetCell

        let tweet = tweets[indexPath.row] as Tweet
        let user = tweet.user!

        cell.nameLabel.text = user.name as? String

        if user.profileUrl != nil {
            cell.profileImage.setImageWithURL(user.profileUrl!)
        }

        cell.profileImage.layer.cornerRadius = 8.0
        cell.profileImage.clipsToBounds = true

        cell.screenNameLabel.text = user.screenname as? String

        //                cell.timestampLabel. = dateformatter. tweet.timestamp
        cell.tweetTextLabel.text = tweet.text as? String
        cell.tweetTextLabel.sizeToFit()
        cell.profileImage.layer.cornerRadius = 3.0
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        

//        cell.timestampLabel.text = String(tweet.timestamp)

        return cell
    }

    // Makes a network request to get updated data
    // Updates the tableView with the new data
    // Hides the RefreshControl
    func refreshControlAction(refreshControl: UIRefreshControl) {

        // ... Create the NSURLRequest (myRequest) ...
        let url = NSURL(string: "https://api.twitter.com/1.1/statuses/home_timeline.json")!
        let myRequest = NSURLRequest(
            URL: url,
            cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData,
            timeoutInterval: 10)

        // Configure session so that completion handler is executed on main UI thread
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )

        let task : NSURLSessionDataTask = session.dataTaskWithRequest(myRequest,
                                                                      completionHandler: { (data, response, error) in

                                                                        print(response)
                                                                        print(data)

                                                                        // ... Use the new data to update the data source ...
                                                                        TwitterClient.sharedInstance.homeTimeline({ (tweets: [Tweet]) in

                                                                            self.tweets = tweets
                                                                            print(tweets.count)

                                                                            print(tweets)

                                                                            // Reload the tableView now that there is new data
                                                                            self.tableView.reloadData()

                                                                            // Tell the refreshControl to stop spinning
                                                                            refreshControl.endRefreshing()

                                                                            }, failure: { (error: NSError) in

                                                                                print(error.localizedDescription)
                                                                                
                                                                        })
                                                                        
                                                                        refreshControl.endRefreshing()
                                                                        
        });
        task.resume()
    }
    
    
    
    
    /*
     MARK: - Navigation
     
     In a storyboard-based application, you will often want to do a little preparation before navigation
     */




    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        /*
         Get the new view controller using segue.destinationViewController.
         Pass the selected object to the new view controller.
         */

        var tweet: Tweet
        var rowIndex: Int

        if let segueIdentifier = segue.identifier,
            cell = sender?.view?.superview?.superview as? TweetCell
            where segueIdentifier == "ProfileSegue" {

            rowIndex = (tableView.indexPathForCell(cell)?.row)!

            tweet = self.tweets![rowIndex]
            let navigationController = segue.destinationViewController as! UINavigationController
            let profileViewController = navigationController.topViewController as! ProfileViewController

//            print(tweet.user)
//            let params = ["user_id": (tweet.user?.id)!, "screen_name": (tweet.user?.screennameRaw)!] as NSDictionary
//
//            TwitterClient.sharedInstance.getUserInfo(params, completion: { (response, error) in
//
//                let dictionary = response!["user"] as! NSDictionary
//                profileViewController.user = User(dictionary: dictionary)
//
//            })

            profileViewController.user = tweet.user

        }

        else if let segueIdentifier = segue.identifier,
            cell = sender as? TweetCell
            where segueIdentifier == "TweetDetailSegue" {

            rowIndex = (tableView.indexPathForCell(cell)?.row)!

            tweet = self.tweets![rowIndex]
            let tweetDetailViewController = segue.destinationViewController as! TweetDetailViewController
            tweetDetailViewController.tweet = tweet

        }
        
    }


}
