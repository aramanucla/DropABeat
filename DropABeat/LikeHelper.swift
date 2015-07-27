//
//  File.swift
//  DropABeat
//
//  Created by Alex Raman on 7/23/15.
//  Copyright (c) 2015 Alex Raman. All rights reserved.
//

import Foundation
import Parse


class LikeHelper
{
    
    
    
    static func likeSong(user: PFUser, song: Song) {
        
        song.incrementKey("numberOfLikes", byAmount: 1)
        song.saveInBackground()
        
        let likeObject = PFObject(className: "Like")
        likeObject["fromUser"] = user
        likeObject["toSong"] = song
        
        likeObject.saveInBackgroundWithBlock(nil)
    }
    
    static func unlikePost(user: PFUser, song: Song) {
        
        song.incrementKey("numberOfLikes", byAmount: -1)
        song.saveInBackground()
        
        let query = PFQuery(className: "Like")
        query.whereKey("fromUser", equalTo: user)
        query.whereKey("toSong", equalTo: song)
        
        query.findObjectsInBackgroundWithBlock {
            (results: [AnyObject]?, error: NSError?) -> Void in
            
            if let results = results as? [PFObject] {
                for likes in results {
                    likes.deleteInBackgroundWithBlock(nil)
                }
            }
        }
    }
    
    static func shouldLikeBeRed(cell: SongSearchTableViewCell, user: PFUser, song: Song) {
    
        
        var likes: [PFObject]? = []
        
    var favoriteSongQuery = PFQuery(className: "Like").whereKey("fromUser", equalTo: PFUser.currentUser()!).whereKey("toSong", equalTo: song)
    
    var completionBlock = { (songArray: [AnyObject]?, error: NSError?) -> Void in
        likes = songArray as? [PFObject]
        
        if(likes?.count == 0)
        {
            cell.likeButton.selected = false
        }
            
        else
        {
            likes = []
            cell.likeButton.selected = true
        }
        
        }
        
        favoriteSongQuery.findObjectsInBackgroundWithBlock(completionBlock)
        
    }

    static func shouldLikeBeRed(cell: BeatsTableViewCell, user: PFUser, song: Song) {
        
        
        var likes: [PFObject]? = []
        
        var favoriteSongQuery = PFQuery(className: "Like").whereKey("fromUser", equalTo: PFUser.currentUser()!).whereKey("toSong", equalTo: song)
        
        var completionBlock = { (songArray: [AnyObject]?, error: NSError?) -> Void in
            likes = songArray as? [PFObject]
            
            if(likes?.count == 0)
            {
                cell.likeButton.selected = false
            }
                
            else
            {
                likes = []
                cell.likeButton.selected = true
            }
            
        }
        
        favoriteSongQuery.findObjectsInBackgroundWithBlock(completionBlock)
        
    }
    
 
    
    
    
    
}