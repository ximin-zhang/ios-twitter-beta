//
//  ComposeViewController.swift
//  Twitter
//
//  Created by ximin_zhang on 8/19/16.
//  Copyright © 2016 ximin_zhang. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var profileImageView: UIImageView!

    @IBOutlet weak var composeTextField: UITextField!

    @IBOutlet weak var remainingCharCountLabel: UILabel!

    var limitLength = 140
    var currentUser: User?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        composeTextField.delegate = self
        composeTextField.textColor = UIColor.lightGrayColor()

        TwitterClient.sharedInstance.currentAccount({ (user: User) in

            self.currentUser = user
            self.profileImageView.setImageWithURL(user.profileUrl!)


        }) { (error: NSError) in
            print("Error: \(error.localizedDescription)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        guard let text = composeTextField.text else { return true }
        let newLength = text.characters.count + string.characters.count - range.length
        let remainingChars = limitLength - newLength

        remainingCharCountLabel.text = "\(remainingChars) characters left"

        return newLength <= limitLength
    }

    func textFieldDidBeginEditing(textField: UITextField) {
        if composeTextField.textColor == UIColor.lightGrayColor() {
            composeTextField.text = nil
            composeTextField.textColor = UIColor.blackColor()
        }
    }

    @IBAction func onTweet(sender: UIBarButtonItem) {

        let status = (composeTextField?.text)! as String
        let params = ["status": status]

        TwitterClient.sharedInstance.tweetWithCompletion(params) { (response, error) in

            print(response)
            print(error?.localizedDescription)

        }

        self.dismissViewControllerAnimated(true) {

        }

    }

    @IBAction func onExit(sender: UIBarButtonItem) {

        // Exit current view
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
