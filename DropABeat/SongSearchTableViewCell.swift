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
    
    let mySongPlayer = SongPlayer()
    
    
    @IBOutlet weak var SongTitleLabel: UILabel!
    
       
   
     @IBOutlet weak var playPauseButton: UIButton!
    
    
    @IBAction func RestartButtonTapped(sender: AnyObject) {
        mySongPlayer.restart()
        playPauseButton.setTitle("Pause", forState: UIControlState.Normal)
        
    }
    
    override func awakeFromNib() {
        mySongPlayer.queryAllSongs()
    }
    
    @IBAction func playSong(sender: UIButton)
    {
        if (AudioPlayer.rate == 1.0)
        {
            AudioPlayer.pause()
            playPauseButton.setTitle("Play", forState: UIControlState.Normal)
            
        }
        
        else{
        mySongPlayer.grabSongAndPlay(selectedSongNumber: mySongPlayer.IDArray.count - 1 - sender.tag)
            playPauseButton.setTitle("Pause", forState: UIControlState.Normal)
        }
        
    }
    
}




