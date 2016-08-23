
//
//  AppDelegate.swift
//  Twitter
//
//  Created by ximin_zhang on 8/15/16.
//  Copyright © 2016 ximin_zhang. All rights reserved.
//

import UIKit
import BDBOAuth1Manager


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let entryViewController = storyboard.instantiateViewControllerWithIdentifier("HamburgerViewController")
//        window?.rootViewController = entryViewController
//        let hamburgerViewController = window?.rootViewController as! HamburgerViewController
//        let menuViewController = storyboard.instantiateViewControllerWithIdentifier("MenuViewController") as! MenuViewController
//
//        menuViewController.hamburgerViewController = hamburgerViewController
//        hamburgerViewController.menuViewController = menuViewController

        if(User.currentUser != nil) {
            print("There is a current user")
            /*
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewControllerWithIdentifier("TweetsNavigationController")

            window?.rootViewController = vc
             */

            /*
             let storyboard = UIStoryboard(name: "Main", bundle: nil)
             let entryViewController = storyboard.instantiateViewControllerWithIdentifier("HamburgerViewController")
             window?.rootViewController = entryViewController
             let hamburgerViewController = window?.rootViewController as! HamburgerViewController
             let menuViewController = storyboard.instantiateViewControllerWithIdentifier("MenuViewController") as! MenuViewController

             hamburgerViewController.menuViewController = menuViewController
             menuViewController.hamburgerViewController = hamburgerViewController

             */
        } else {
            print("There is no current user")
        }

        NSNotificationCenter.defaultCenter().addObserverForName(User.userDidLogoutNotification, object: nil, queue: NSOperationQueue.mainQueue()) { (NSNotification) in

            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateInitialViewController()
            self.window?.rootViewController = vc
        }

        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    // Called during open URL
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        print(url.description)
        TwitterClient.sharedInstance.handleOpenUrl(url)

        return true
    }


}

