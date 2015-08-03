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
    
    var delegate: presentActionSheetDelegate!
    
    
    var userHasNotReportedThisSong: Bool = true
    
    @IBOutlet weak var likeButton: UIButton!
    
    @IBOutlet weak var SongTitleLabel: UILabel!
    
    @IBOutlet weak var uploadedByUser: UILabel!
    
    @IBOutlet weak var restartButton: UIButton!
    
    @IBOutlet weak var playPauseButton: UIButton!
    
    var song: Song?{
        didSet{
            LikeHelper.shouldLikeBeRed(self, user: PFUser.currentUser()!, song: song!)
            
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
    
    
    @IBAction func moreButtonTapped(sender: AnyObject) {
        
        //An Action Sheet that lets you choose to report/share a song
        var myActionSheet: UIAlertController = UIAlertController(title: nil, message: "Choose an option", preferredStyle: UIAlertControllerStyle.ActionSheet)

        
        /**********************Creates Action Sheet**********************/
        
        let reportButtonAction = UIAlertAction(title: "Report", style: UIAlertActionStyle.Default) { (ACTION) -> Void in
            println("report button tapped")
            
            let button = sender as! UIButton
            let view = button.superview
            let cell = view?.superview as! SongSearchTableViewCell
            
            self.delegate.showReportOptions(cell)
            
            
            
        }
        
        
        let shareButtonAction = UIAlertAction(title: "Share", style: UIAlertActionStyle.Default) { (ACTION) -> Void in
            println("Share button tapped")
            
        }
        
        let cancelButtonAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (ACTION) -> Void in
            println("Cancel button tapped")
            
        }
        
        
//        if(userHasNotReportedThisSong){
        myActionSheet.addAction(reportButtonAction)
//        }
        myActionSheet.addAction(shareButtonAction)
        myActionSheet.addAction(cancelButtonAction)
        

        

        //Delegate is songSearchViewController
        delegate.presentActionSheet(myActionSheet)
    }
    
    
    
    
    override func awakeFromNib() {
        SongPlayer.sharedInstance.queryAllSongs()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "songPlayStateDidChange:", name: SongPlayStateDidChange, object: nil)
        restartButton.hidden = true
        
//        
//        if let theUsersWhoReportedSongs = song?.usersWhoReportedSong{
//        for user in theUsersWhoReportedSongs{
//            if (user == PFUser.currentUser())
//            {
//                userHasNotReportedThisSong = false
//            }
//        }
//        }
        
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

protocol presentActionSheetDelegate
{
    func presentActionSheet(actionSheet: UIAlertController) -> Void
    func showReportOptions(cell: SongSearchTableViewCell)->Void
}
