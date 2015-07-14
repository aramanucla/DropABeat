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


//Create a public Selected Song Number

public var SelectedSongNumber = Int()

class ViewController: UIViewController {
    
    
    let mySongPlayer = SongPlayer()
    
    @IBOutlet weak var PausePlay: UIButton!
    
    
    @IBOutlet weak var SongNameLabel: UILabel!
    
    
    
    //Create an AudioFileList of audio files within the app
    let myAudioFiles = AudioFileList()
    
    //Create an optional AVAudioPlayer (For the locally stored music)
    var audioPlayer: AVAudioPlayer?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        mySongPlayer.queryAllSongs()
    
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func DropABeat(sender: AnyObject) {
        
       /*** createAudioPlayer()
        audioPlayer!.play()
        PausePlay.setTitle("Pause", forState: UIControlState.Normal)

*****/
        
        SelectedSongNumber = mySongPlayer.randomNumberInParseSongArray()
        mySongPlayer.grabSongAndPlay(selectedSongNumber: SelectedSongNumber)
        PausePlay.setTitle("Pause", forState: UIControlState.Normal)
        SongNameLabel.text = mySongPlayer.nameArray[SelectedSongNumber]
    }
    
    @IBAction func Restart(sender: AnyObject) {
      /***  audioPlayer!.stop()
        audioPlayer!.currentTime = 0
        audioPlayer!.play()
        PausePlay.setTitle("Pause", forState: UIControlState.Normal)

****/
        mySongPlayer.restart()
        PausePlay.setTitle("Pause", forState: UIControlState.Normal)
        
    }
    
    @IBAction func PausePlay(sender: AnyObject) {
        
   /************************     if(audioPlayer!.playing)
        {
            audioPlayer!.stop()
            PausePlay.setTitle("Play", forState: UIControlState.Normal)
            
        }
            
        else
        {
            audioPlayer!.play()
            PausePlay.setTitle("Pause", forState: UIControlState.Normal)
        }
      
****************************************************/
        
        if (mySongPlayer.playPause())
        {
            PausePlay.setTitle("Play", forState: UIControlState.Normal)
        }
        
        else
        {
            PausePlay.setTitle("Pause", forState: UIControlState.Normal)
        }
        
    }
    
    
    
 /*   func createAudioPlayer() {
        
      let audioFileString =  myAudioFiles.randomSong()
        
        let aURL = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(audioFileString, ofType: "mp3")!)
        
        audioPlayer = AVAudioPlayer(contentsOfURL: aURL, error: nil)
        
    }
  */
    
}

