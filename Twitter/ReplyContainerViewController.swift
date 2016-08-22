//
//  ReplyContainerViewController.swift
//  Twitter
//
//  Created by ximin_zhang on 8/21/16.
//  Copyright © 2016 ximin_zhang. All rights reserved.
//

import UIKit

class ReplyContainerViewController: UIViewController {
    var previousViewController: UIViewController!
    var tweet: Tweet!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onReturn(sender: AnyObject) {
        if var topController = UIApplication.sharedApplication().keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            // topController should now be your topmost view controller

            let hamburgViewController = topController as! HamburgerViewController
            hamburgViewController.contentViewController = previousViewController
        }
    }
    
    @IBAction func onReply(sender: UIBarButtonItem) {

        
    }


    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        // Pass the selected object to the new view controller.
        if let vc = segue.destinationViewController as? ReplyViewController
            where segue.identifier == "ReplyEmbedSegue" {
            vc.tweet = tweet // Pass data
            vc.previousViewController = previousViewController
        }
    }


}
