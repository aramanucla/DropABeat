//
//  BeatsTableViewCell.swift
//  DropABeat
//
//  Created by Alex Raman on 7/24/15.
//  Copyright (c) 2015 Alex Raman. All rights reserved.
//

import UIKit
import Parse

class BeatsTableViewCell: UITableViewCell {

    var song: Song?
    
    var delegate: reloadDataDelegate!
    
    @IBOutlet weak var likeButton: UIButton!
    
    @IBOutlet weak var SongTitleLabel: UILabel!
    
    
    @IBOutlet weak var restartButton: UIButton!
    
    @IBOutlet weak var playPauseButton: UIButton!
    
    
    
    
    @IBAction func RestartButtonTapped(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName(ChangeSongPlayState, object: song!, userInfo: [SongPlayStateKey:Restart])
    }
    
    override func awakeFromNib() {
        SongPlayer.sharedInstance.queryAllSongs()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "songPlayStateDidChange:", name: SongPlayStateDidChange, object: nil)
        restartButton.hidden = true
    }
    
    
    func songPlayStateDidChange(notification:NSNotification)
    {
        let info = notification.userInfo?[SongPlayStateKey] as! String
        let notificationSong = notification.object as! Song
        
        
        switch info {
        case Paused:
            if(notificationSong == song)
            {
                playPauseButton.setTitle("Play", forState: UIControlState.Normal)
            }
        case Playing:
            if(notificationSong == song)
            {
                playPauseButton.setTitle("Pause", forState: UIControlState.Normal)
            }
        case Restart:
            if(notificationSong == song)
            {
                playPauseButton.setTitle("Pause", forState: UIControlState.Normal)
            }
        case Stopped:
            if(notificationSong == song)
            {
                restartButton.hidden = true
                playPauseButton.setTitle("Play", forState: UIControlState.Normal)
            }
        default:
            println("Action not implemented; neither pause nor playing")
        }
        
    }
    
    
    
    
    @IBAction func likeSong(sender: AnyObject) {
        unlikePost(PFUser.currentUser()!, song: self.song!)
    }
    
    
    func unlikePost(user: PFUser, song: Song)
    {
        var mySong = song
        var completionBlock = {(success: Bool, error: NSError?)->Void in self.delegate.reload(mySong)}
        
        let query = PFQuery(className: "Like")
        query.whereKey("fromUser", equalTo: user)
        query.whereKey("toSong", equalTo: song)
        
        query.findObjectsInBackgroundWithBlock {
            (results: [AnyObject]?, error: NSError?) -> Void in
            
            if let results = results as? [PFObject] {
                for likes in results {
                    likes.deleteInBackgroundWithBlock(completionBlock)
                }
            }
        }

    }
    
    @IBAction func playSong(sender: UIButton)
    {
        
        
        if(playPauseButton.titleForState(UIControlState.Normal) == "Play")
        {
            NSNotificationCenter.defaultCenter().postNotificationName(ChangeSongPlayState, object: song, userInfo: [SongPlayStateKey:Playing])
        }
        else
        {
            NSNotificationCenter.defaultCenter().postNotificationName(ChangeSongPlayState, object: song, userInfo: [SongPlayStateKey:Paused])
        }
        
        restartButton.hidden = false
        
    }
    


}


protocol reloadDataDelegate{
    func reload(song: Song) -> Void
}
