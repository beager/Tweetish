//
//  MenuViewController.swift
//  Tweetish
//
//  Created by Bill Eager on 9/21/15.
//  Copyright © 2015 Bill Eager. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
   
    private var timelineNavigationController: UIViewController!
    private var mentionsNavigationController: UIViewController!
    private var userNavigationController: UIViewController!
    
    var viewControllers: [UIViewController] = []
    
    var hamburgerViewController: HamburgerViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        timelineNavigationController = storyboard.instantiateViewControllerWithIdentifier("TimelineNavigationController")
        mentionsNavigationController = storyboard.instantiateViewControllerWithIdentifier("MentionsNavigationController")
        userNavigationController = storyboard.instantiateViewControllerWithIdentifier("UserNavigationController")
        
        viewControllers.append(timelineNavigationController)
        viewControllers.append(mentionsNavigationController)
        viewControllers.append(userNavigationController)
        
        hamburgerViewController?.contentViewController = timelineNavigationController
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MenuCell", forIndexPath: indexPath) as! MenuCell
        
        let titles = ["Timeline", "Mentions", "You"]
        cell.menuTitleLabel.text = titles[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        hamburgerViewController?.contentViewController = viewControllers[indexPath.row]
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
