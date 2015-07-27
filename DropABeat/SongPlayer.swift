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

let Playing = "Playing"
let Paused = "Paused"
let Stopped = "Stopped"
let Restart = "Restart"

let ChangeSongPlayState = "ChangeSongPlayState"
let SongPlayStateDidChange = "SongPlayStateDidChange"
let SongPlayStateKey: NSString = "SongPlayState"

class SongPlayer: NSObject
{
    var audioPlayer = AVPlayer()
    
    var selectedSongNumber: Int = 0
    
    var songs: [Song] = []
    
    var currentSong: Song?
    
    static let sharedInstance = SongPlayer()
    
    override init()
    {
        super.init()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "changeSongPlayState:", name: ChangeSongPlayState, object: nil)
         NSNotificationCenter.defaultCenter().addObserver(self, selector: "playSongFromBeginning:", name: AVPlayerItemDidPlayToEndTimeNotification, object: audioPlayer.currentItem)
    }
    
    func queryAllSongs()
    {
        var allSongQuery = PFQuery(className: "Song")
        allSongQuery.findObjectsInBackgroundWithBlock({
            (objectsArray : [AnyObject]?, error: NSError?) -> Void in
            
            
            self.songs = (objectsArray as? [Song])!
            
            
        })
        
    }
    
    func randomSong() -> Song
    {
        var unsignedArrayCount = UInt32(songs.count)
        var unsignedRandomNumber = arc4random_uniform(unsignedArrayCount)
        var randomNumber = Int(unsignedRandomNumber)
        
        return songs[randomNumber]
    }
    
    
    
    func notifySongPlayStateChange(song: Song?, state: String) {
        NSNotificationCenter.defaultCenter().postNotificationName(SongPlayStateDidChange, object: song, userInfo: [SongPlayStateKey : state])
    }
    
    
    
    func changeSongPlayState(notification: NSNotification)
    {
        let info = notification.userInfo?[SongPlayStateKey] as! String
        
        
        
        switch info {
        case Paused:
            if(self.audioPlayer.rate == 1.0)
            {
                audioPlayer.pause()
                self.notifySongPlayStateChange(self.currentSong, state: Paused)
            }
        case Playing:
            if(self.currentSong?.objectId == notification.object?.objectId)
            {
                self.audioPlayer.play()
                self.notifySongPlayStateChange(self.currentSong, state: Playing)
            }
                
            else{
                
                if(self.currentSong != nil)
                {
                self.notifySongPlayStateChange(self.currentSong, state: Stopped)
                }
                
                self.currentSong = notification.object as? Song
                if let songURL = self.currentSong?.SongFile?.url {
                    
                    self.audioPlayer = AVPlayer(URL: NSURL(string: songURL))
                    self.audioPlayer.play()
                    
                    
                    self.notifySongPlayStateChange(self.currentSong, state: Playing)
                    
                }
            }
        case Restart:
            audioPlayer.pause()
            audioPlayer.seekToTime(CMTimeMakeWithSeconds(0,5), completionHandler: nil)
            audioPlayer.play()
            self.notifySongPlayStateChange(self.currentSong, state: Restart)
            
        default:
            println("Action not implemented; handle additional states in song player")
        }
    }
    
    
    func playSongFromBeginning(notification: NSNotification)
    {
        audioPlayer.seekToTime(CMTimeMakeWithSeconds(0,5), completionHandler: nil)
        audioPlayer.play()

    }
    
}