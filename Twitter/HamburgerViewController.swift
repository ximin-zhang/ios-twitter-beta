//
//  HamburgerViewController.swift
//  Twitter
//
//  Created by ximin_zhang on 8/20/16.
//  Copyright © 2016 ximin_zhang. All rights reserved.
//

import UIKit

class HamburgerViewController: UIViewController {

    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var leftMarginConstraint: NSLayoutConstraint!
    var originLeftMargin: CGFloat!
    var menuViewController: UIViewController! {
        didSet (oldMenuViewController) {
            view.layoutIfNeeded()

            if(oldMenuViewController != nil) {
                oldMenuViewController.willMoveToParentViewController(nil)
                oldMenuViewController.view.removeFromSuperview()
                oldMenuViewController.didMoveToParentViewController(nil)
            }

            menuViewController.willMoveToParentViewController(self)
            self.menuView.addSubview(menuViewController.view)
            menuViewController.didMoveToParentViewController(self)
        }
    }

    var contentViewController: UIViewController! {
        didSet (oldContentViewController) {
            view.layoutIfNeeded()

            if(oldContentViewController != nil) {
                oldContentViewController.willMoveToParentViewController(nil)
                oldContentViewController.view.removeFromSuperview()
                oldContentViewController.didMoveToParentViewController(nil)
            }

            contentViewController.willMoveToParentViewController(self)
            self.contentView.addSubview(contentViewController.view)
//            self.contentView.addSubview((contentViewController.navigationController?.view)!)
            contentViewController.didMoveToParentViewController(self)

            UIView.animateWithDuration(0.3) { 
                self.leftMarginConstraint.constant = 0
                self.view.layoutIfNeeded()
            }
        }
    }



    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        let storybaord = UIStoryboard(name: "Main", bundle: nil)
//        let tweetsViewController = storybaord.instantiateViewControllerWithIdentifier("TweetsViewController")
//        self.contentView.addSubview(tweetsViewController.view)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onPanGesture(sender: UIPanGestureRecognizer) {
        let translation = sender.translationInView(view)
        let velocity = sender.velocityInView(view)

        if sender.state == UIGestureRecognizerState.Began {
            originLeftMargin = leftMarginConstraint.constant

        } else if sender.state == UIGestureRecognizerState.Changed {
            leftMarginConstraint.constant = originLeftMargin + translation.x

        } else if sender.state == UIGestureRecognizerState.Ended {

            if(velocity.x > 0) {
                leftMarginConstraint.constant =  200 //view.frame.width - 50
            } else {
                leftMarginConstraint.constant = 0
            }

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
