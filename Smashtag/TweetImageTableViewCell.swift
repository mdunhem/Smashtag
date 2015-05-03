//
//  TweetImageTableViewCell.swift
//  Smashtag
//
//  Created by Sven on 5/2/15.
//  Copyright (c) 2015 Mikael Dunhem. All rights reserved.
//

import UIKit

class TweetImageTableViewCell: UITableViewCell {
    
    var url: NSURL? {
        didSet {
            fetchImage()
        }
    }
    
    @IBOutlet weak var tweetImage: UIImageView! {
        didSet {
            setNeedsDisplay()
        }
    }
    
    private func fetchImage() {
        dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.value), 0)) {
            let imageData = NSData(contentsOfURL: self.url!)
            dispatch_async(dispatch_get_main_queue()) {
                if imageData != nil {
                    self.tweetImage?.image = UIImage(data: imageData!)
                }
            }
        }
    }

}
