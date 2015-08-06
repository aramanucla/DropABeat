//
//  ViewController.swift
//  DropABeat
//
//  Created by Alex Raman on 7/8/15.
//  Copyright (c) 2015 Alex Raman. All rights reserved.
//

import UIKit
import AVFoundation
import Parse
import AVKit
import MediaPlayer



//Create a public activity indicator
public var actInd : UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0,0, 50, 50)) as UIActivityIndicatorView

class ViewController: UIViewController {
    
    var song: Song?
    
    
    var likes: [PFObject]? = []
    
    @IBOutlet weak var PausePlay: UIButton!
    
    
    @IBOutlet weak var SongNameLabel: UILabel!
    
    
    @IBOutlet weak var RestartOutlet: UIButton!
    
    @IBOutlet weak var captureButton: UIButton!
    override func viewDidLoad() {
        
        
        actInd.center = self.view.center
        actInd.hidesWhenStopped = true
        actInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.White
        view.addSubview(actInd)
        
        captureButton.enabled = false
        
         AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, error: nil)
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        SongPlayer.sharedInstance.queryAllSongs()
        
        PausePlay.enabled = false
        RestartOutlet.enabled = false
        
        
        
        SongNameLabel.text = "Hit the Disc to Drop A Beat!"
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "songPlayStateDidChange:", name: SongPlayStateDidChange, object: nil)
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func songPlayStateDidChange(notification:NSNotification)
    {
        let info = notification.userInfo?[SongPlayStateKey] as! String
        let notificationSong = notification.object as? Song
        
        
        switch info {
        case Paused:
            if(notificationSong == song)
            {
                PausePlay.setTitle("Play", forState: UIControlState.Normal)
                PausePlay.setImage(UIImage(named: "Play"), forState: UIControlState.Normal)
            }
        case Playing:
            if(notificationSong == song)
            {
                PausePlay.setTitle("Pause", forState: UIControlState.Normal)
                PausePlay.setImage(UIImage(named: "Pause"), forState: UIControlState.Normal)
            }
        case Restart:
            if(notificationSong == song)
            {
                PausePlay.setTitle("Pause", forState: UIControlState.Normal)
            }
        case Stopped:
            if(notificationSong == song)
            {
                PausePlay.setTitle("Play", forState: UIControlState.Normal)
            }
            
        default:
            println("Action not implemented; neither pause nor playing")
        }
        
    }
    
    
    @IBAction func DropABeat(sender: AnyObject) {
        
        actInd.startAnimating()
        
        captureButton.enabled = true
    
        song = SongPlayer.sharedInstance.randomSong()
        SongNameLabel.text = song!.SongName
        
        NSNotificationCenter.defaultCenter().postNotificationName(ChangeSongPlayState, object: song, userInfo: [SongPlayStateKey: Playing])
        
        PausePlay.enabled = true
        RestartOutlet.enabled = true
        
        
        
    }
    
    @IBAction func RestartButton(sender: AnyObject) {
        
        NSNotificationCenter.defaultCenter().postNotificationName(ChangeSongPlayState, object: song, userInfo: [SongPlayStateKey:Restart])
    }
    
    @IBAction func PausePlay(sender: AnyObject) {
        if (PausePlay.titleForState(UIControlState.Normal) == "Pause")
        {
            NSNotificationCenter.defaultCenter().postNotificationName(ChangeSongPlayState, object: song, userInfo: [SongPlayStateKey:Paused])
        }
        else
        {
            NSNotificationCenter.defaultCenter().postNotificationName(ChangeSongPlayState, object: song, userInfo: [SongPlayStateKey:Playing])
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if(segue.identifier == "showVideoRecorderSegue")
        {
            var upcoming: VideoRecorderViewController = segue.destinationViewController as! VideoRecorderViewController
            
            
            upcoming.song = song!
            
                        
        }
    }
    
    
}

