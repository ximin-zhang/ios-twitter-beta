//
//  LoginViewController.swift
//  Twitter
//
//  Created by ximin_zhang on 8/15/16.
//  Copyright © 2016 ximin_zhang. All rights reserved.
//

import UIKit
import BDBOAuth1Manager


class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func onLoginButton(sender: AnyObject) {
        /*let twitterClient = BDBOAuth1SessionManager(baseURL: NSURL(string: "https://api.twitter.com")!, consumerKey: "bRdoQCv27ZV1rvYBWGYwLj8OJ", consumerSecret: "lG85EeI4FWdcg8BaKfgQRlzxmxNNP2aofqG70ChGWWNPj28w7h")*/

//        let twitterClient = BDBOAuth1SessionManager(baseURL: NSURL(string: "https://api.twitter.com")!, consumerKey: "eb2cC3UOQPgJbe5hTFb2n7ioV", consumerSecret: "Wiwo0mNJtfd5cSHfdQqT46whXt0kNpXtIxnxbAcrNCukpEKxbj")

        let client = TwitterClient.sharedInstance
        client.login({

            print("I have logged in")
            self.performSegueWithIdentifier("loginSegue", sender: nil) // customized segue way

        }) { (error: NSError) in

            print("error: \(error.localizedDescription)")
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
