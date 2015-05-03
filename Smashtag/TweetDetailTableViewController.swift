//
//  TweetDetailTableViewController.swift
//  Smashtag
//
//  Created by Sven on 4/29/15.
//  Copyright (c) 2015 Mikael Dunhem. All rights reserved.
//

import UIKit

class TweetDetailTableViewController: UITableViewController {
    
    private var stack = [[TweetItem]]()
    
    private enum TweetItem {
        case Media(MediaItem)
        case Hashtag(Tweet.IndexedKeyword)
        case Url(Tweet.IndexedKeyword)
        case User(Tweet.IndexedKeyword)
        
        var contents: String {
            switch self {
                case .Media(let media): return media.description
                case .Hashtag(let hashTag): return hashTag.keyword
                case .Url(let url): return url.keyword
                case .User(let user): return user.keyword
            }
        }
        
        var titleForHeader: String {
            switch self {
                case .Media(_): return "Media"
                case .Hashtag(_): return "Hashtags"
                case .Url(_): return "Urls"
                case .User(_): return "Users"
            }
        }
    }
    
    private struct ResuseIdentifiers {
        static let SelectableDetailIdentifier = "Tweet Selectable Detail Identifier"
        static let NonSelectableDetailIdentifier = "Tweet Image Detail Identifier"
    }
    
    private struct SegueIdentifiers {
        static let PushSpecificSearchTerm = "Push Specific Search Term"
    }
    
    // MARK: - TODO: Need to clean this up
    var tweet: Tweet? {
        didSet {
            if let nonNilTweet = tweet {
                if !nonNilTweet.media.isEmpty {
                    var items = [TweetItem]()
                    for mediaItem in nonNilTweet.media {
                        items.append(TweetItem.Media(mediaItem))
                    }
                    stack.append(items)
                }
                if !nonNilTweet.hashtags.isEmpty {
                    var items = [TweetItem]()
                    for hashtag in nonNilTweet.hashtags {
                        items.append(TweetItem.Hashtag(hashtag))
                    }
                    stack.append(items)
                }
                if !nonNilTweet.urls.isEmpty {
                    var items = [TweetItem]()
                    for url in nonNilTweet.urls {
                        items.append(TweetItem.Url(url))
                    }
                    stack.append(items)
                }
                if !nonNilTweet.userMentions.isEmpty {
                    var items = [TweetItem]()
                    for user in nonNilTweet.userMentions {
                        items.append(TweetItem.User(user))
                    }
                    stack.append(items)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return stack.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stack[section].count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return stack[section].first?.titleForHeader
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let item = stack[indexPath.section][indexPath.row]
        
        switch item {
            case .Media(let mediaItem):
                let cell = tableView.dequeueReusableCellWithIdentifier(ResuseIdentifiers.NonSelectableDetailIdentifier, forIndexPath: indexPath) as! TweetImageTableViewCell
                cell.url = mediaItem.url
                return cell
            default:
                let cell = tableView.dequeueReusableCellWithIdentifier(ResuseIdentifiers.SelectableDetailIdentifier, forIndexPath: indexPath) as! UITableViewCell
                cell.textLabel?.text = item.contents
                cell.accessoryType = .DisclosureIndicator
                return cell
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let item = stack[indexPath.section][indexPath.row]
        
        switch item {
        case .Media(let mediaItem):
            return tableView.bounds.size.width / CGFloat(mediaItem.aspectRatio)
        default:
            return UITableViewAutomaticDimension
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var destination = segue.destinationViewController as? UIViewController
        if let navigationController = destination as? UINavigationController {
            destination = navigationController.visibleViewController
        }
        
        if let tweetTableViewController = destination as? TweetTableViewController {
            if let identifier = segue.identifier {
                switch identifier {
                case SegueIdentifiers.PushSpecificSearchTerm:
                    if let cell = sender as? UITableViewCell  {
                        tweetTableViewController.searchText = cell.textLabel?.text
                    }
                default:
                    break
                }
            }
        }
    }

}
