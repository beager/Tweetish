//
//  MentionsViewController.swift
//  Tweetish
//
//  Created by Bill Eager on 9/21/15.
//  Copyright © 2015 Bill Eager. All rights reserved.
//

import UIKit

class MentionsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ComposeTweetViewControllerDelegate, TweetCellDelegate {

    @IBOutlet weak var tableView: UITableView!
    var timelineTweets: [Tweet]?

    func tweetCell(tweetCell: TweetCell, didTapProfileImageWithGesture gesture: UIGestureRecognizer) {
        print("lazy cow")
        let indexPath = tableView.indexPathForRowAtPoint(gesture.locationInView(tableView))
        let userViewController = self.storyboard?.instantiateViewControllerWithIdentifier("UserViewController") as! UserViewController
        userViewController.user = timelineTweets?[indexPath!.row].user
        self.navigationController?.pushViewController(userViewController, animated: true)
    }
    
    var refreshControl: UIRefreshControl!
    
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
        
        title = "Mentions"
        loadData()
        // Do any additional setup after loading the view.
    }
    
    func loadData() {
        TwitterClient.sharedInstance.mentionsTimelineWithCompletion() {
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
        cell.delegate = self
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
        case "composeFromMentionsSegue":
            let composeTweetViewController = segue.destinationViewController as! ComposeTweetViewController
            composeTweetViewController.delegate = self
            break
        case "viewTweetFromMentionsSegue":
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
}
