//
//  TweetsContainerViewController.swift
//  Twitter
//
//  Created by ximin_zhang on 8/21/16.
//  Copyright © 2016 ximin_zhang. All rights reserved.
//

import UIKit

class TweetsContainerViewController: UIViewController {
    var tweetsViewController: TweetsViewController!
    var hamburgerViewController: HamburgerViewController!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func onTapCompose(sender: UIBarButtonItem) {
        if var topController = UIApplication.sharedApplication().keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            // topController should now be your topmost view controller

            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let composeContainerViewController = storyboard.instantiateViewControllerWithIdentifier("ComposeContainerViewController") as! ComposeContainerViewController
            let composeViewController = storyboard.instantiateViewControllerWithIdentifier("ComposeViewController") as! ComposeViewController
            composeViewController.currentUser = User.currentUser
            composeContainerViewController.composeViewController = composeViewController
            composeContainerViewController.previousViewController = self

            let hamburgViewController = topController as! HamburgerViewController
            hamburgViewController.contentViewController = composeContainerViewController
            
            /*
            view.removeFromSuperview()
            composeContainerViewController.hamburgerViewController = hamburgerViewController
            view.addSubview(hamburgerViewController.view)
             */
        }

    }


    @IBAction func onLogout(sender: UIBarButtonItem) {
        TwitterClient.sharedInstance.logout()
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let vc = segue.destinationViewController as? TweetsViewController
            where segue.identifier == "TweetsEmbedSegue" {
            vc.containerController = self // Pass data
            vc.previousViewController = self
            vc.refresh()
        }
    }

}
