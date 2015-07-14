//
//  SongPlayer.swift
//  DropABeat
//
//  Created by Alex Raman on 7/13/15.
//  Copyright (c) 2015 Alex Raman. All rights reserved.
//

import Foundation
import Parse
import AVFoundation
import AVKit

public var AudioPlayer = AVPlayer()

class SongPlayer
{
    //An array of each song's ID's and Name in Parse
    var IDArray = [String]()
    var nameArray = [String]()
    
    var selectedSongNumber: Int = 0
    
    //For Parse songs
    var myAudioPlayer = AVPlayer()
    
    //For locally stored songs
    let myAudioFiles = AudioFileList()
    
    
    func queryAllSongs()
    {
        var ObjectIDQuery = PFQuery(className: "Songs")
        ObjectIDQuery.findObjectsInBackgroundWithBlock({
            (objectsArray : [AnyObject]?, error: NSError?) -> Void in
            
            var objectIDs = objectsArray as! [PFObject]
            
            
            for i in 0...objectIDs.count-1
            {
                self.IDArray.append(objectIDs[i].valueForKey("objectId") as! String)
                self.nameArray.append(objectIDs[i].valueForKey("SongName") as! String)
            }
            
            
            
        })

    }
    
    func randomNumberInParseSongArray() -> Int
    {
        var unsignedArrayCount = UInt32(IDArray.count)
        var unsignedRandomNumber = arc4random_uniform(unsignedArrayCount)
        var randomNumber = Int(unsignedRandomNumber)
        
        return randomNumber
    }
    
    
    
    func grabSongAndPlay(#selectedSongNumber: Int)
    {
        var SongQuery = PFQuery(className: "Songs")
        SongQuery.getObjectInBackgroundWithId(IDArray[selectedSongNumber], block: {
            (object : PFObject?, error : NSError?) -> Void in
            
            if let AudioFileURLTemp = object?.objectForKey("SongFile")?.url
            {
                AudioPlayer = AVPlayer(URL: NSURL(string: AudioFileURLTemp!))
                AudioPlayer.play()
            }
            
            
            
        })
        
    }
    
    

    func restart()
    {
        AudioPlayer.pause()
        AudioPlayer.seekToTime(CMTimeMakeWithSeconds(0, 5), completionHandler: nil)
        AudioPlayer.play()

    }
    
    
    //Returns true if Audio was playing then was paused, returns false if Audio wasn't playing but now is
    func playPause() -> Bool
    {
        if(AudioPlayer.rate == 1.0)
        {
            AudioPlayer.pause()
            return true;
            
        }
            
        else
        {
            AudioPlayer.play()
            return false;
        }

    }
    
    
    
    
    
    
    
    
    

}