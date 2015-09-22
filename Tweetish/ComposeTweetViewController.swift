//
//  ComposeTweetViewController.swift
//  Tweetish
//
//  Created by Bill Eager on 9/14/15.
//  Copyright (c) 2015 Bill Eager. All rights reserved.
//

import UIKit

@objc protocol ComposeTweetViewControllerDelegate {
    optional func composeTweetViewController(composeTweetViewController: ComposeTweetViewController, didPostTweet success: Bool)
}

class ComposeTweetViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var charsLeftLabel: UILabel!
    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var postButton: UIBarButtonItem!
    @IBOutlet weak var tweetBodyField: UITextView!
    @IBOutlet weak var userHandleLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userProfileImage: UIImageView!
    
    var delegate: ComposeTweetViewControllerDelegate?
    
    var replyTweet: Tweet?
    
    var keyboardHeight: CGFloat?
    override func viewDidLoad() {
        super.viewDidLoad()
        let user = User.currentUser!
        
        usernameLabel.text = user.name
        userHandleLabel.text = "@\(user.screenName!)"
        userProfileImage.setImageWithURL(NSURL(string: user.profileImageUrl!))
        // Do any additional setup after loading the view.
        
        if let replyTweet = replyTweet {
            tweetBodyField.text = "@\(replyTweet.user!.screenName!) "
        }
        
        tweetBodyField.becomeFirstResponder()
        tweetBodyField.delegate = self
        postButton.enabled = false
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        //stopObservingKeyboardEvents()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onPostButton(sender: AnyObject) {
        TwitterClient.sharedInstance.postTweetWithStatus(tweetBodyField.text, inReplyTo: replyTweet, completion: { (success, error) -> () in
            print(success)
            if (success == true) {
                self.delegate?.composeTweetViewController?(self, didPostTweet: true)
                self.navigationController?.popViewControllerAnimated(true)
            } else {
                // Handle not posting tweet
            }
        })
    }
    
    func textViewDidChange(textView: UITextView) {
        let length = tweetBodyField.text.characters.count
        
        let charsLeft = 140 - length
        var color: UIColor!
        
        if length == 0 {
            postButton.enabled = false
            color = UIColor.blackColor()
        } else if (length > 140) {
            postButton.enabled = false
            color = UIColor.redColor()
        } else if (length > 100) {
            postButton.enabled = true
            color = UIColor.orangeColor()
        } else {
            postButton.enabled = true
            color = UIColor.blackColor()
        }
        charsLeftLabel.attributedText = NSAttributedString(string: "\(charsLeft)", attributes: [NSForegroundColorAttributeName: color])
        
        
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
