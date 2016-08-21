//
//  MenuViewController.swift
//  Twitter
//
//  Created by ximin_zhang on 8/20/16.
//  Copyright © 2016 ximin_zhang. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var hamburgerViewController: HamburgerViewController!
    private var tweetsViewController: UIViewController!
    private var profileViewController: UIViewController!
    private var tweetsViewNavigationController: UINavigationController!
    private var profileViewNavigationController: UINavigationController!
    var viewControllers: [UIViewController] = []
    var user: User!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 300

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        profileViewController = storyboard.instantiateViewControllerWithIdentifier("ProfileViewController")
        tweetsViewController = storyboard.instantiateViewControllerWithIdentifier("TweetsViewController")
        profileViewNavigationController = profileViewController.navigationController
        tweetsViewNavigationController = tweetsViewController.navigationController
        viewControllers.append(profileViewController)
        viewControllers.append(tweetsViewController)

        hamburgerViewController.contentViewController = tweetsViewController
        user = User.currentUser
        
        tableView.reloadData()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0) {
            return 1
        }
        else {
            return 2
        }

    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if(indexPath.section == 0) {
            let cell = tableView.dequeueReusableCellWithIdentifier("MenuProfileCell", forIndexPath: indexPath) as! MenuProfileCell

            
            if user != nil {
                cell.profileImageView.setImageWithURL(user!.profileUrl!)
                cell.nameLabel.text = user!.name as? String
                cell.screennameLabel.text = user!.screenname as? String
            }else {
                TwitterClient.sharedInstance.currentAccount({ (user: User) in
                    self.user = user
                    }, failure: { (error: NSError) in

                })

//                self.tableView.reloadData()
            }

            return cell
        }
        else {
            let cell = tableView.dequeueReusableCellWithIdentifier("MenuOptionCell", forIndexPath: indexPath) as! MenuOptionCell
            if(indexPath.row == 0) {
                cell.menuImageView.image = UIImage(named: "home-sidebar")
                cell.menuLabel.text = "Home"
            }else{
                cell.menuImageView.image = UIImage(named: "mention")
                cell.menuLabel.text = "Mention"
            }

            return cell
        }

    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)

        if(indexPath.section == 0) {
            hamburgerViewController.contentViewController = viewControllers[0]
        } else {
            hamburgerViewController.contentViewController = viewControllers[indexPath.row + 1]
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
