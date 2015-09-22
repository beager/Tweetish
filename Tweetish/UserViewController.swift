//
//  UserViewController.swift
//  Tweetish
//
//  Created by Bill Eager on 9/21/15.
//  Copyright © 2015 Bill Eager. All rights reserved.
//

import UIKit

class UserViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ComposeTweetViewControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    var timelineTweets: [Tweet]?
    @IBOutlet weak var profileBackgroundImageView: UIImageView!
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userHandleLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    
    @IBOutlet weak var tweetsCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    
    var refreshControl: UIRefreshControl!
    
    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBarHidden = false
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 220
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // Add refresh control to the tableView
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh...", attributes: [NSForegroundColorAttributeName: UIColor.orangeColor()])
        refreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex:0)
        
        // Check user here and display something else if it's not you
        title = "You"
        if (user == nil) {
            user = User.currentUser
        }
        
        if (user != User.currentUser) {
            title = "@\(user.screenName!)"
        }
        self.profileBackgroundImageView.setImageWithURL(NSURL(string: user.profileBackgroundImageUrl!))
        self.profileImageView.setImageWithURL(NSURL(string: user.profileImageUrl!))
        self.userHandleLabel.text = user.name
        self.screenNameLabel.text = "@\(user.screenName!)"
        self.profileImageView.layer.cornerRadius = 6
        self.profileImageView.clipsToBounds = true
        
        self.tweetsCountLabel.text = String(user.tweetsCount!)
        self.followingCountLabel.text = String(user.followingCount!)
        self.followersCountLabel.text = String(user.followersCount!)
        loadData()
        // Do any additional setup after loading the view.
    }
    
    func loadData() {
        TwitterClient.sharedInstance.userTweetsWithCompletion(user) {
            (tweets: [Tweet]?, error: NSError?) in
            if tweets != nil {
                self.timelineTweets = tweets
                self.refreshControl.endRefreshing()
                self.tableView.reloadData()
            } else {
                // handle fetch timeline error
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // When refresh is triggered, change the title and load the data
    func onRefresh() {
        refreshControl.attributedTitle = NSAttributedString(string: "Loading data...", attributes: [NSForegroundColorAttributeName: UIColor.orangeColor()])
        loadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if timelineTweets != nil {
            return timelineTweets!.count
        } else {
            return 0
        }
    }
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as! TweetCell
        cell.tweet = timelineTweets![indexPath.row]
        cell.layoutIfNeeded()
        return cell
    }
    
    func composeTweetViewController(composeTweetViewController: ComposeTweetViewController, didPostTweet success: Bool) {
        loadData()
    }
    
    // Deselect active row on tap
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        switch(segue.identifier!) {
        case "composeTweetFromUserSegue":
            let composeTweetViewController = segue.destinationViewController as! ComposeTweetViewController
            composeTweetViewController.delegate = self
            break
        case "viewTweetFromUserSegue":
            let tweetViewController = segue.destinationViewController as! TweetViewController
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPathForCell(cell)
            let tweet = timelineTweets![indexPath!.row]
            tweetViewController.tweet = tweet
            break
        default:
            break
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
