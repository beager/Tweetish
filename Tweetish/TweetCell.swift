//
//  TweetCell.swift
//  Tweetish
//
//  Created by Bill Eager on 9/14/15.
//  Copyright (c) 2015 Bill Eager. All rights reserved.
//

import UIKit

protocol TweetCellDelegate {
    func tweetCell(tweetCell: TweetCell, didTapProfileImageWithGesture gesture: UIGestureRecognizer)
}

class TweetCell: UITableViewCell {

    @IBOutlet weak var retweetedLabel: UILabel!
    @IBOutlet weak var tweetContentLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var userHandleLabel: UILabel!
    @IBOutlet weak var userTitleLabel: UILabel!
    @IBOutlet weak var userAvatarImage: UIImageView!
    @IBOutlet weak var replyImage: UIImageView!
    @IBOutlet weak var retweetImage: UIImageView!
    @IBOutlet weak var favoriteImage: UIImageView!
    
    var delegate: TweetCellDelegate?
    
    var tweet: Tweet! {
        didSet {
            tweetContentLabel.text = tweet.text
            userHandleLabel.text = "@\(tweet.user!.screenName!)"
            userTitleLabel.text = tweet.user?.name
            userAvatarImage.setImageWithURL(NSURL(string: tweet.user!.profileImageUrl!))
            userAvatarImage.layer.cornerRadius = 3
            userAvatarImage.clipsToBounds = true
            retweetedLabel.hidden = true
            timestampLabel.text = tweet.getCompactDate()
            if (tweet.favorited!) {
                favoriteImage.image = UIImage(named: "fav-on")
            } else {
                favoriteImage.image = UIImage(named: "fav-default")
            }
            if tweet.retweeted! {
                retweetImage.image = UIImage(named: "retweet-on")
            } else {
                retweetImage.image = UIImage(named: "retweet-default")
            }
            print("setting up gesture rec")
            let gestureRecognizer = UITapGestureRecognizer(target: self, action: "handleTap:")
            userAvatarImage.addGestureRecognizer(gestureRecognizer)
        }
    }
    
    func handleTap(gesture: UIGestureRecognizer) {
        print("delegate")
        delegate?.tweetCell(self, didTapProfileImageWithGesture: gesture)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        tweetContentLabel.preferredMaxLayoutWidth = tweetContentLabel.frame.size.width
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        tweetContentLabel.preferredMaxLayoutWidth = tweetContentLabel.frame.size.width
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
