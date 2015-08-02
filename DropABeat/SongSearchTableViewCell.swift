//
//  SongSearchTableViewCell.swift
//  DropABeat
//
//  Created by Alex Raman on 7/10/15.
//  Copyright (c) 2015 Alex Raman. All rights reserved.
//

import Foundation
import UIKit
import Parse


class SongSearchTableViewCell: UITableViewCell
    
{
    // var tag = 0
    
    
    @IBOutlet weak var likeButton: UIButton!
    
    @IBOutlet weak var SongTitleLabel: UILabel!
    
    @IBOutlet weak var uploadedByUser: UILabel!
    
    @IBOutlet weak var restartButton: UIButton!
    
    @IBOutlet weak var playPauseButton: UIButton!
    
    var song: Song?{
        didSet{
            if let songLabel = song!.objectForKey("SongName") as? String {
                self.SongTitleLabel.text = songLabel
                
                if let username = song!.user?.username!{
                    self.uploadedByUser.text = "Uploaded by " + username
                }
            }
        }
    }
    
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
        let notificationSong = notification.object as? Song
        
        
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
            println("Probably recording, Action not implemented; neither pause nor playing")
        }
        
    }
    
    
    
    
    @IBAction func likeSong(sender: AnyObject) {
        song!.toggleLikeSong(PFUser.currentUser()!, cell: self)
        
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


