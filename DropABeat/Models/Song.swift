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
    @NSManaged var SongFile: PFFile?
    @NSManaged var SongName: String?
    @NSManaged var user: PFUser?
    
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

}


func ==(lhs: Song, rhs: Song) -> Bool
{
    return lhs.objectId == rhs.objectId
}