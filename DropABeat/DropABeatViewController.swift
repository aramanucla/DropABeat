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

class DropABeatViewController: UIViewController {
    
     var videoRecorder: VideoRecorder?
    
    
    enum rotationState
    {
        case Rotating
        case NotRotating
    }
    
    var recordRotationState: rotationState = .NotRotating
    
    var song: Song?
    
    
    var likes: [PFObject]? = []
    
    @IBOutlet weak var PausePlay: UIButton!
    
    @IBOutlet weak var dropABeatButton: UIButton!
    
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
        
        dropABeatButton.enabled = false
        PausePlay.enabled = false
        RestartOutlet.enabled = false
        
        
        
        SongNameLabel.text = "Hit the Disc to Drop A Beat!"
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "songPlayStateDidChange:", name: SongPlayStateDidChange, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "AllSongsLoaded:", name: "AllSongsLoaded", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "stopActivityIndicator:", name: "PlaybackStartedNotification", object: nil)
        
        
    }
    
    
    
    func AllSongsLoaded(notification: NSNotification)
    {
        dropABeatButton.enabled = true
    }
    
    
    func stopActivityIndicator(notification: NSNotification)
    {
        actInd.stopAnimating()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    override func viewWillAppear(animated: Bool) {
        //Check if the phone is connected to the internet, if it isnt, then display a message
        
        if(!Reachability.isConnectedToNetwork()){
            
            let alertController: UIAlertController = UIAlertController(title: nil, message: "Internet connection unavailable", preferredStyle: UIAlertControllerStyle.Alert)
            let doneAction: UIAlertAction = UIAlertAction(title: "Okay", style: UIAlertActionStyle.Cancel, handler: nil)
            alertController.addAction(doneAction)
            
            self.presentViewController(alertController, animated: true, completion: nil)
            
        }
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
        if(Reachability.isConnectedToNetwork()){
        
        //Stop Rotating if it is rotating
        
        if(recordRotationState == .Rotating){
            UIView.animateWithDuration(0.1, delay: 0.0, options: UIViewAnimationOptions.BeginFromCurrentState | UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
                let transform: CGAffineTransform = CGAffineTransformIdentity
                self.dropABeatButton.transform = transform
                }, completion: nil)
            recordRotationState = .NotRotating
            
        }
        actInd.startAnimating()
        
        captureButton.enabled = true
    
        song = SongPlayer.sharedInstance.randomSong()
        
        SongNameLabel.text = song?.SongName
        
        NSNotificationCenter.defaultCenter().postNotificationName(ChangeSongPlayState, object: song, userInfo: [SongPlayStateKey: Playing])
        
        PausePlay.enabled = true
        RestartOutlet.enabled = true
        
        
        //Start Rotation
        
        if(recordRotationState == .NotRotating){
        UIView.animateWithDuration(2.0, delay: 0.0, options: UIViewAnimationOptions.Repeat | UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
            let transform: CGAffineTransform = CGAffineTransformMakeRotation(CGFloat(M_PI))
            self.dropABeatButton.transform = transform
            }, completion: nil)
            
            recordRotationState = .Rotating
        
        }
    }
}
    
    @IBAction func RestartButton(sender: AnyObject) {
        
        NSNotificationCenter.defaultCenter().postNotificationName(ChangeSongPlayState, object: song, userInfo: [SongPlayStateKey:Restart])
        
        //Start Rotation
        UIView.animateWithDuration(2.0, delay: 0.0, options: UIViewAnimationOptions.Repeat | UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
            let transform: CGAffineTransform = CGAffineTransformMakeRotation(CGFloat(M_PI))
            self.dropABeatButton.transform = transform
            }, completion: nil)
        
        recordRotationState = .Rotating
    }
    
    @IBAction func PausePlay(sender: AnyObject) {
        //self.dropABeatButton.layer.removeAllAnimations()
        
        if (PausePlay.titleForState(UIControlState.Normal) == "Pause")
        {
            NSNotificationCenter.defaultCenter().postNotificationName(ChangeSongPlayState, object: song, userInfo: [SongPlayStateKey:Paused])
            
            
            //Stop Rotation
            UIView.animateWithDuration(0.1, delay: 0.0, options: UIViewAnimationOptions.BeginFromCurrentState | UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
                let transform: CGAffineTransform = CGAffineTransformIdentity
                self.dropABeatButton.transform = transform
                }, completion: nil)
            
            recordRotationState = .NotRotating

            
        }
        else
        {
            NSNotificationCenter.defaultCenter().postNotificationName(ChangeSongPlayState, object: song, userInfo: [SongPlayStateKey:Playing])
            
            //Start Rotation
            UIView.animateWithDuration(2.0, delay: 0.0, options: UIViewAnimationOptions.Repeat | UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
                let transform: CGAffineTransform = CGAffineTransformMakeRotation(CGFloat(M_PI))
                self.dropABeatButton.transform = transform
                }, completion: nil)
            
            recordRotationState = .Rotating
        }
    }
    
    
    
    @IBAction func showCamera(sender: AnyObject) {
        videoRecorder = VideoRecorder(viewController: self, song: song!, callback: {
            (image: UIImage?) -> Void in
            
        })
    }
    
    
    
}

