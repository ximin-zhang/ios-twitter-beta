//
//  ReplyViewController.swift
//  Twitter
//
//  Created by ximin_zhang on 8/18/16.
//  Copyright © 2016 ximin_zhang. All rights reserved.
//

import UIKit

class ReplyViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var cancelButton: UIBarButtonItem!

    var tweet: Tweet?

    @IBOutlet weak var replyTextField: UITextField!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var charCountLabel: UILabel!

    let limitLength = 140

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        profileImageView.setImageWithURL((tweet?.user?.profileUrl)!)

        nameLabel.text = tweet!.user?.name as? String

        screennameLabel.text = tweet!.user?.screenname! as? String

        replyTextField.delegate = self

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func onCancel(sender: UIBarButtonItem) {

        self.dismissViewControllerAnimated(true) {

        }
    }

    @IBAction func onTweet(sender: UIBarButtonItem) {

        let status = ((screennameLabel?.text)! + " " + (replyTextField?.text)!) as String
        let id = tweet?.statusid as! String
        let params = ["status": status, "in_reply_to_status_id": id]
        TwitterClient.sharedInstance.tweetWithCompletion(params) { (response, error) in

            print(response)
            print(error?.localizedDescription)

        }

        self.dismissViewControllerAnimated(true) { 
            
        }

    }


    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        guard let text = replyTextField.text else { return true }
        let newLength = text.characters.count + string.characters.count - range.length
        let remainingChars = limitLength - newLength

        charCountLabel.text = "\(remainingChars) characters left"

        return newLength <= limitLength
    }

    /*

     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.


     
     }
     */

    
}
