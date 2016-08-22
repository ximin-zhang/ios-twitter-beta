//
//  TweetDetailViewController.swift
//  Twitter
//
//  Created by ximin_zhang on 8/17/16.
//  Copyright © 2016 ximin_zhang. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var tweet: Tweet?
    var retweetsCount: String?
    var favoritesCount: String?
    var favorited: Bool?
    var previousViewController: UIViewController!
    

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        tableView.dataSource = self
        tableView.delegate = self

        tableView.allowsSelection = false
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 300

        // Initialization of counts
        let statsCell = tableView.dequeueReusableCellWithIdentifier("TweetDetailStatsCell") as! TweetDetailStatsCell
        statsCell.favoritesCountLabel.text = String(tweet!.favoritesCount)
        statsCell.retweetCountLabel.text = String(tweet!.retweetCount)

        tableView.reloadData()

    }

    override func viewDidDisappear(animated: Bool) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 2){
            return 1
        }else{
            return 1
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        if(indexPath.section == 0) {
            let cell = tableView.dequeueReusableCellWithIdentifier("TweetDetailCell", forIndexPath: indexPath) as! TweetDetailCell

            cell.nameLabel.text = (tweet?.user?.name as! String)
            cell.screennameLabel.text = (tweet?.user?.screenname as! String)
            cell.profileImageView.setImageWithURL((tweet?.user?.profileUrl)!)
            cell.tweetTextLabel.text = (tweet?.text as! String)
            cell.tweetTextLabel.sizeToFit()
            cell.timestampLabel.text = String(tweet?.timestamp!)

            return cell

        } else if (indexPath.section == 1) {

            let cell = tableView.dequeueReusableCellWithIdentifier("TweetDetailStatsCell", forIndexPath: indexPath) as! TweetDetailStatsCell

            if let favoritesCount = favoritesCount {
                cell.favoritesCountLabel.text = favoritesCount
            } else {
                cell.favoritesCountLabel.text = String(tweet!.favoritesCount)
            }

            if let retweetsCount = retweetsCount {
                cell.retweetCountLabel.text = retweetsCount
            } else {
                cell.retweetCountLabel.text = String(tweet!.retweetCount)
            }

            return cell

        } else {

            let cell = tableView.dequeueReusableCellWithIdentifier("TweetDetailFuncCell", forIndexPath: indexPath) as! TweetDetailFuncCell

            let id = "\(tweet!.statusid!)"
            let params = ["id": id]
            TwitterClient.sharedInstance.getTweetByID(params, success: { (dictionary: NSDictionary) in

                self.favorited = dictionary["favorited"] as? Bool
                if((self.favorited) != nil) {

                    if(self.favorited == true) {
                        cell.favoriteImageView.image = UIImage(named:"liked.png")
                        cell.favoriteImageView.highlighted = true
                    } else {
                        cell.favoriteImageView.image = UIImage(named:"favorite.png")
                        cell.favoriteImageView.highlighted = false
                    }
                }

            }) { (error: NSError) in
                
                print("error: \(error.localizedFailureReason)")
                
            }

            return cell
        }

    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }

    @IBAction func onTapReply(sender: UITapGestureRecognizer) {

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let replyContainerViewController = storyboard.instantiateViewControllerWithIdentifier("ReplyContainerViewController") as! ReplyContainerViewController
        replyContainerViewController.previousViewController = previousViewController
        replyContainerViewController.tweet = tweet

        if var topController = UIApplication.sharedApplication().keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }

            // topController should now be your topmost view controller
            let hamburgViewController = topController as! HamburgerViewController
            hamburgViewController.contentViewController = replyContainerViewController
        }
    }

    @IBAction func onTapRetweet(sender: UITapGestureRecognizer) {

        // create the alert
        let alert = UIAlertController(title: "CONFIMR", message: nil, preferredStyle: UIAlertControllerStyle.Alert)

        let retweetAction = UIAlertAction(title: "Retweet", style: .Default, handler: {
            action in

            let id = self.tweet?.statusid as! String
            let params = ["id": id]
            TwitterClient.sharedInstance.retweet(params) { (response, error) in
                print(response)
                print(error?.localizedDescription)
            }
            }
        )

        let cancelAction = UIAlertAction(title: "Cancel", style: .Default, handler: {
            action in
            // Do nothing
            }
        )

        alert.addAction(retweetAction)
        alert.addAction(cancelAction)

        self.presentViewController(alert, animated: true, completion: nil)

    }

    @IBAction func onTapFavorite(sender: UITapGestureRecognizer) {

        let id = self.tweet?.statusid as! String
        let params = ["id": id]

        if (self.favorited != nil) {
            if(self.favorited == false) {

                TwitterClient.sharedInstance.favorite(params, success: { (dictionary: NSDictionary) in

                    self.favoritesCount = "\(dictionary["favorite_count"]!)"
                    self.tableView.reloadSections(NSIndexSet(index: 1), withRowAnimation: .None)
                    self.tableView.reloadSections(NSIndexSet(index: 2), withRowAnimation: .None)

                }) { (error: NSError) in
                    print(error.localizedFailureReason)
                }
            } else {
                TwitterClient.sharedInstance.unlike(params, success: { (dictionary: NSDictionary) in
                    self.favoritesCount = "\(dictionary["favorite_count"]!)"
                    self.tableView.reloadSections(NSIndexSet(index: 1), withRowAnimation: .None)
                    self.tableView.reloadSections(NSIndexSet(index: 2), withRowAnimation: .None)
                    }, failure: { (error: NSError) in
                })
            }
        }

        self.tableView.userInteractionEnabled = true
        self.tableView.reloadData()
    }


    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     */

     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        // A chance to set itself as the delegate for the next transition view controller

        if let segueIdentifier = segue.identifier
            where (segueIdentifier == "ReplyViewControllerSegue1" || segueIdentifier == "ReplyViewControllerSegue2") {
            let navigationController = segue.destinationViewController as! UINavigationController
            let replyViewController = navigationController.topViewController as! ReplyViewController

            replyViewController.tweet = tweet
        }
        else if let segueIdentifier = segue.identifier
            where segueIdentifier == "ProfileViewControllerSegue" {
            let navigationController = segue.destinationViewController as! UINavigationController
            let profileViewController = navigationController.topViewController as! ProfileViewController
            profileViewController.user = tweet!.user
        }

     }




    
}
