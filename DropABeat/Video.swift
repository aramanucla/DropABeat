//
//  Video.swift
//  DropABeat
//
//  Created by Alex Raman on 8/6/15.
//  Copyright (c) 2015 Alex Raman. All rights reserved.
//

import Foundation
import Parse

class Video: PFObject, PFSubclassing, Equatable
{
    @NSManaged var user: PFUser?
    @NSManaged var song: Song?
    @NSManaged var fileSystemPath: String?
    
 
    static func parseClassName() -> String {
        return "Video"
    }
    
    override class func initialize() {
        var onceToken : dispatch_once_t = 0;
        dispatch_once(&onceToken) {
            // inform Parse about this subclass
            self.registerSubclass()
        }
    }
    
}

func ==(lhs: Video, rhs: Video) -> Bool
{
    return lhs.objectId == rhs.objectId
}