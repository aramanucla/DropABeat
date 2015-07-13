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


//Create an AVPlayer and a Selected Song Number
public var AudioPlayer = AVPlayer()
public var SelectedSongNumber = Int()

class ViewController: UIViewController {
    
    //Create an AudioFileList of audio files within the app
    let myAudioFiles = AudioFileList()
    
    //Create an optional AVAudioPlayer (For the locally stored music)
    var audioPlayer: AVAudioPlayer?
    
    @IBOutlet weak var PausePlay: UIButton!
    
    
    @IBOutlet weak var SongNameLabel: UILabel!
    
    //An Array of Song IDs and an Array of Song Names
    var IDArray = [String]()
    var NameArray = [String]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        //Query all of the songs
        var ObjectIDQuery = PFQuery(className: "Songs")
        ObjectIDQuery.findObjectsInBackgroundWithBlock({
            (objectsArray : [AnyObject]?, error: NSError?) -> Void in
            
            var objectIDs = objectsArray as! [PFObject]
            
            
            for i in 0...objectIDs.count-1
            {
                self.IDArray.append(objectIDs[i].valueForKey("objectId") as! String)
                self.NameArray.append(objectIDs[i].valueForKey("SongName") as! String)
            }
            
            
            
            
            
        })
    }
    
    func grabSong()
    {
        var SongQuery = PFQuery(className: "Songs")
        SongQuery.getObjectInBackgroundWithId(IDArray[SelectedSongNumber], block: {
            (object : PFObject?, error : NSError?) -> Void in
            
            if let AudioFileURLTemp = object?.objectForKey("SongFile")?.url
            {
                AudioPlayer = AVPlayer(URL: NSURL(string: AudioFileURLTemp!))
                AudioPlayer.play()
            }
            
            
            
        })
    
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
        
        SelectedSongNumber = randomNumberInParseSongArray()
        grabSong()
        PausePlay.setTitle("Pause", forState: UIControlState.Normal)
        SongNameLabel.text = NameArray[SelectedSongNumber]
    }
    
    @IBAction func Restart(sender: AnyObject) {
      /*  audioPlayer!.stop()
        audioPlayer!.currentTime = 0
        audioPlayer!.play()
        PausePlay.setTitle("Pause", forState: UIControlState.Normal)

*/
        AudioPlayer.pause()
        AudioPlayer.seekToTime(CMTimeMakeWithSeconds(0, 5), completionHandler: nil)
        AudioPlayer.play()
        PausePlay.setTitle("Pause", forState: UIControlState.Normal)
        
    }
    
    
    
    
    @IBAction func PausePlay(sender: AnyObject) {
        
   /*     if(audioPlayer!.playing)
        {
            audioPlayer!.stop()
            PausePlay.setTitle("Play", forState: UIControlState.Normal)
            
        }
            
        else
        {
            audioPlayer!.play()
            PausePlay.setTitle("Pause", forState: UIControlState.Normal)
        }
      
*/
        
        if(AudioPlayer.rate == 1.0)
        {
            AudioPlayer.pause()
            PausePlay.setTitle("Play", forState: UIControlState.Normal)
        }
        
        else
        {
            AudioPlayer.play()
            PausePlay.setTitle("Pause", forState: UIControlState.Normal)
        }
        
    }
    
    
    
    func createAudioPlayer() {
        
      let audioFileString =  myAudioFiles.randomSong()
        
        let aURL = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(audioFileString, ofType: "mp3")!)
        
        audioPlayer = AVAudioPlayer(contentsOfURL: aURL, error: nil)
        
    }
    
    func randomNumberInParseSongArray() -> Int
    {
        var unsignedArrayCount = UInt32(IDArray.count)
        var unsignedRandomNumber = arc4random_uniform(unsignedArrayCount)
        var randomNumber = Int(unsignedRandomNumber)
        
        return randomNumber
    }
    
    
    
}

