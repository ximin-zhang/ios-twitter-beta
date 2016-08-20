//
//  ProfileViewController.swift
//  Twitter
//
//  Created by ximin_zhang on 8/19/16.
//  Copyright © 2016 ximin_zhang. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var tweets: [Tweet]?
    var user: User?

    @IBOutlet weak var tableView: UITableView!


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self

        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 1

    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier("ProfileCell", forIndexPath: indexPath) as! ProfileCell

        cell.profileImageView.setImageWithURL((user?.profileUrl)!)
        
        cell.tweetCountLabel.text = "\(user!.tweetsCnt!)"
        cell.followersCountLabel.text = "\(user!.followingCnt!)"
        cell.followingCountLabel.text = "\(user!.followingCnt!)"
        cell.profileBackgroundImageView.setImageWithURL(user!.profileBackgroundImageUrl!)
        cell.profileImageView.layer.cornerRadius = 8.0
        cell.profileImageView.clipsToBounds = true
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.nameLabel.text = user?.name as? String
        cell.screennameLabel.text = user?.screenname as? String

        return cell
    }

    @IBAction func onTapHome(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true) { 
            
        }
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
