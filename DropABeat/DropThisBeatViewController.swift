//
//  DropThisBeatViewController.swift
//  DropABeat
//
//  Created by Alex Raman on 7/13/15.
//  Copyright (c) 2015 Alex Raman. All rights reserved.
//

import UIKit

class DropThisBeatViewController: UIViewController {
    
    
    var song: Song?
    
    
    @IBOutlet weak var restartOutlet: UIButton!
    
    
    @IBOutlet weak var playPauseOutlet: UIButton!
    
    override func viewDidLoad() {
        SongPlayer.sharedInstance.queryAllSongs()
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "songPlayStateDidChange:", name: SongPlayStateDidChange, object: nil)
        
        SongNameLabel.text = song!.SongName
        
        // Do any additional setup after loading the view.
    }
    
    
    func songPlayStateDidChange(notification:NSNotification)
    {
        let info = notification.userInfo?[SongPlayStateKey] as! String
        let notificationSong = notification.object as! Song

        
        
        switch info {
        case Paused:
            if(notificationSong == song)
            {
                playPauseOutlet.setTitle("Play", forState: UIControlState.Normal)
            }
        case Playing:
            if(notificationSong == song)
            {
                playPauseOutlet.setTitle("Pause", forState: UIControlState.Normal)
            }
        case Restart:
            if(notificationSong == song)
            {
                playPauseOutlet.setTitle("Pause", forState: UIControlState.Normal)
            }
        case Stopped:
            if(notificationSong == song)
            {
                playPauseOutlet.setTitle("Play", forState: UIControlState.Normal)
            }
        default:
            println("Action not implemented; neither pause nor playing")
        }
        
    }
    
    
    @IBOutlet weak var SongNameLabel: UILabel!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dropThisBeat(sender: AnyObject) {
        
        
        NSNotificationCenter.defaultCenter().postNotificationName(ChangeSongPlayState, object: song, userInfo: [SongPlayStateKey:Playing])
        
        playPauseOutlet.hidden = false
        restartOutlet.hidden = false
    }
    
    @IBAction func playPauseButton(sender: AnyObject) {
        
        if (playPauseOutlet.titleForState(UIControlState.Normal) == "Pause")
        {
            NSNotificationCenter.defaultCenter().postNotificationName(ChangeSongPlayState, object: song, userInfo: [SongPlayStateKey: Paused])
        }
        else
        {
            NSNotificationCenter.defaultCenter().postNotificationName(ChangeSongPlayState, object: song, userInfo: [SongPlayStateKey:Playing])
        }
    }
    @IBAction func restart(sender: AnyObject) {
        
        NSNotificationCenter.defaultCenter().postNotificationName(ChangeSongPlayState, object: song, userInfo: [SongPlayStateKey: Restart])    }
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
    
    
    
    
    
}
