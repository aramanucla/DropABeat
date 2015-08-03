//
//  Post.swift
//  DropABeat
//
//  Created by Alex Raman on 7/14/15.
//  Copyright (c) 2015 Alex Raman. All rights reserved.
//

import Foundation
import Parse

class Song: PFObject, PFSubclassing, Equatable
{
    
    var likes: [PFObject]? = []
    
    
    @NSManaged var numberOfLikes: Int
    @NSManaged var SongFile: PFFile?
    @NSManaged var SongName: String?
    @NSManaged var user: PFUser?
    @NSManaged var usersWhoReportedSong: [PFUser]
    
    
    static func parseClassName() -> String
    {
        return "Song"
    }
    
        
    override class func initialize() {
        var onceToken : dispatch_once_t = 0;
        dispatch_once(&onceToken) {
            // inform Parse about this subclass
            self.registerSubclass()
        }
    }
    
     
    
    
    func toggleLikeSong(user: PFUser, cell:SongSearchTableViewCell)
    {
        //if the user likes the post, unlike it
        if(cell.likeButton.selected == true)
        {
            LikeHelper.unlikePost(user, song: self)
            cell.likeButton.selected = false
        
        }
        
        else
        {
            LikeHelper.likeSong(user, song: self)
            cell.likeButton.selected = true
            
            
        }
    }
    
    func toggleMyFavoritesLikeSong(user: PFUser, cell:BeatsTableViewCell)
    {
        //if the user likes the post, unlike it
        if(cell.likeButton.selected == true)
        {
            LikeHelper.unlikePost(user, song: self)
            cell.likeButton.selected = false
            
        }
            
        else
        {
            LikeHelper.likeSong(user, song: self)
            cell.likeButton.selected = true
            
            
        }
    }

}


func ==(lhs: Song, rhs: Song) -> Bool
{
    return lhs.objectId == rhs.objectId
}