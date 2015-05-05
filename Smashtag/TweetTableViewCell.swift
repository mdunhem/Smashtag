//
//  TweetTableViewCell.swift
//  Smashtag
//
//  Created by Sven on 4/29/15.
//  Copyright (c) 2015 Mikael Dunhem. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {

    var tweet: Tweet? {
        didSet {
            updateUI()
        }
    }
    
    @IBOutlet weak var tweetProfileImageView: UIImageView!
    @IBOutlet weak var tweetScreenNameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var tweetCreatedLabel: UILabel!
    
    func updateUI() {
        tweetTextLabel?.attributedText = nil
        tweetScreenNameLabel?.text = nil
        tweetProfileImageView?.image = nil
        tweetCreatedLabel?.text = nil
        
        if let tweet = self.tweet {
            var text = NSMutableAttributedString(string: tweet.text)
            applyTextColorTo(text, withColor: UIColor.redColor(), usingIndexedKeywords: tweet.hashtags)
            applyTextColorTo(text, withColor: UIColor.blueColor(), usingIndexedKeywords: tweet.urls)
            applyTextColorTo(text, withColor: UIColor.orangeColor(), usingIndexedKeywords: tweet.userMentions)
            
            for _ in tweet.media {
                text.appendAttributedString(NSAttributedString(string: " 📷"))
            }
            
            tweetTextLabel?.attributedText = text
            
            tweetScreenNameLabel?.text = "\(tweet.user)"
            
            if let profileImageURL = tweet.user.profileImageURL {
                dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.value), 0)) {
                    if let imageData = NSData(contentsOfURL: profileImageURL) {
                        dispatch_async(dispatch_get_main_queue()) {
                            tweetProfileImageView?.image = UIImage(data: imageData)
                        }
                    }
                }
            }
            
            let formatter = NSDateFormatter()
            if NSDate().timeIntervalSinceDate(tweet.created) > 24*60*60 {
                formatter.dateStyle = NSDateFormatterStyle.ShortStyle
            } else {
                formatter.timeStyle = NSDateFormatterStyle.ShortStyle
            }
            tweetCreatedLabel?.text = formatter.stringFromDate(tweet.created)
        }
        
    }
    
    // Simple little helper function to apply attributes
    private func applyTextColorTo(attributedString: NSMutableAttributedString, withColor color: UIColor, usingIndexedKeywords indexedKeywords: [Tweet.IndexedKeyword]) {
        for indexedKeyword in indexedKeywords {
            attributedString.addAttribute(NSForegroundColorAttributeName, value: color, range: indexedKeyword.nsrange)
        }
    }

}
